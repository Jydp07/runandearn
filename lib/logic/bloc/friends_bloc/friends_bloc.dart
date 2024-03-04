import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';
import 'package:share/share.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc()
      : super(const FriendsState(
            isLoading: false,
            friends: [],
            error: "",
            isReferelCodeValid: false,
            referelCode: "",
            isAccept: false,
            friendsRequest: [], searchFriend: [], isSearching: false)) {
    on<OnGetAllFriends>(_onGetAllFriends);
    on<GetContactEvent>(_onGetContact);
    on<OnSentInviteEvent>(_onSentInvites);
    on<OnReferFriend>(_onReferFriend);
    on<OnGetReferelCode>(_onGetReferal);
    on<OnGetFriendsData>(_onGetFriendsData);
    on<OnChangeFriendRequestStatus>(_onFreindRequestStatusChange);
    on<OnGetFreindsStep>(_onGetFriendsStep);
    on<OnSearchFriends>(_onSearchFriend);
    on<OnGetFriendsDataAfter>(_onGetFriendsDataAfter);
  }

  final db = DatabaseRepositoryImpl();

  _onGetAllFriends(OnGetAllFriends event, Emitter<FriendsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final allUser = await db.retrieveAllUserData();
      final friends = await db.retrieveFriendsData();
      final currentUser = await db.retrieveUserData();
      List<UserModel> friendUser = [];
      for (var user in allUser) {
        if (!friends.any((element) => user.uid == element.uid)) {
          if (currentUser.uid != user.uid) {
            friendUser.add(user);
          }
        }
      }
      emit(state.copyWith(friendsRequest: friendUser));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onGetContact(GetContactEvent event, Emitter<FriendsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      PermissionStatus permission = await Permission.contacts.request();
      if (permission == PermissionStatus.denied) {
        Permission.contacts.request();
        if (permission == PermissionStatus.denied) {
          emit(state.copyWith(error: "Contact permission denied"));
        }
      } else {
        final contacts = await FlutterContacts.getContacts(
            withPhoto: true, withThumbnail: true, withProperties: true);
        List<UserModel> addContact = [];

        final users = await db.retrieveAllUserData();
        final friends = await db.retrieveFriendsData();
        final user = await db.retrieveUserData();
        for (int i = 0; i < users.length; i++) {
          for (var element in contacts) {
            final userContacts = users[i].number;
            if (element.phones.isNotEmpty) {
              final elementContact = element.phones.first.normalizedNumber;

              final formattedContact = "+91$userContacts";
              if (elementContact == formattedContact) {
                if (!friends.any((element) => element.uid == users[i].uid)) {
                  if (user.number != userContacts) {
                    addContact.add(users[i]);
                  }
                }
              }
            }
            emit(state.copyWith(
              friends: addContact,
            ));
          }
        }
      }
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onSentInvites(OnSentInviteEvent event, Emitter<FriendsState> emit) async {
    try {
      UserModel userModel = UserModel();
      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
        await db.saveFriends(userModel.copyWith(
            friends: event.userId,
            isFriends: '${FriendStatus.sent}',
            uid: currentUserUid));
        await db.saveFriends(userModel.copyWith(
            uid: event.userId,
            friends: currentUserUid,
            isFriends: '${FriendStatus.request}'));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _onReferFriend(OnReferFriend event, Emitter<FriendsState> emit) async {
    try {
      String generateReferralCode() {
        final random = Random();
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        const length = 8;

        return String.fromCharCodes(Iterable.generate(
          length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length)),
        ));
      }

      final String refer = generateReferralCode();
      UserModel userModel = UserModel();
      await db.saveReferelCode(userModel.copyWith(referelCode: refer));
      final appLink = await db.retrieveApplicationLink();
      await Share.share(
          "This is awsome app for run and earn please download from ${appLink.applicationLink} and enter $refer code you will get 20 coins",
          subject: "Look what a app");
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _onGetFriendsDataAfter(OnGetFriendsDataAfter event, Emitter<FriendsState> emit) async {
    final friends = await db.retrieveFriendsData();
    List<UserModel> getFriend = [];
    List<UserModel> requestFriend = [];
    try {
      for (var friend in friends) {
        final userModel = UserModel();
        final friendsData =
            await db.retrieveUserDataByUid(userModel.copyWith(uid: friend.uid));
        getFriend.add(friendsData);
        requestFriend.add(friend);
      }
      emit(state.copyWith(friendsRequest: requestFriend, friends: getFriend));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _onGetReferal(OnGetReferelCode event, Emitter<FriendsState> emit) async {
    final users = await db.retrieveAllUserData();
    final currentUser = await db.retrieveUserData();
    final user = UserModel();

    for (var refUser in users) {
      if (refUser.referelCode == event.referCode) {
        if (currentUser.uid == refUser.uid) {
          continue;
        }
        final coin =
            await db.retrieveUserCoins(user.copyWith(uid: refUser.uid));

        await db.saveUserCoins(user.copyWith(
            coin: coin.coin != null ? coin.coin! + 20 : 20, uid: refUser.uid));
        await db.saveIfReferenced(user.copyWith(isReferedOnce: true));
      }
    }
    final isValid = users.any((element) {
      return element.referelCode == event.referCode;
    });
    emit(state.copyWith(isReferelCodeValid: isValid));
  }

  _onGetFriendsData(OnGetFriendsData event, Emitter<FriendsState> emit) async {
    final friends = await db.retrieveFriendsData();
    List<UserModel> getFriend = [];
    List<UserModel> requestFriend = [];
    emit(state.copyWith(isLoading: true));
    try {
      for (var friend in friends) {
        final userModel = UserModel();
        final friendsData =
            await db.retrieveUserDataByUid(userModel.copyWith(uid: friend.uid));
        getFriend.add(friendsData);
        requestFriend.add(friend);
      }
      emit(state.copyWith(friendsRequest: requestFriend, friends: getFriend));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  _onFreindRequestStatusChange(
      OnChangeFriendRequestStatus event, Emitter<FriendsState> emit) async {
    try {
      UserModel userModel = UserModel();

      await db.saveFriends(userModel.copyWith(
          friends: event.userId, isFriends: event.status, uid: currentUserUid));
      await db.saveFriends(userModel.copyWith(
          uid: event.userId, friends: currentUserUid, isFriends: event.status));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  _onGetFriendsStep(OnGetFreindsStep event, Emitter<FriendsState> emit) async {
    UserModel userModel = UserModel();
    emit(state.copyWith(isLoading: true));
    try {
      final getData = await db.retrieveFriendsData();
      List<UserModel> friends = [];
      List<UserModel> userStep = [];
      for (var friend in getData) {
        if (friend.isFriends == 'FriendStatus.accept') {
          final getFriends = await db
              .retrieveUserDataByUid(userModel.copyWith(uid: friend.uid));
          final steps = await db
              .retrieveUserStepsByUid(userModel.copyWith(uid: friend.uid));
          friends.add(getFriends);
          userStep.add(steps);
        }
      }
      emit(state.copyWith(friends: friends, friendsRequest: userStep));
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  _onSearchFriend(OnSearchFriends event, Emitter<FriendsState> emit) async {
    try{
      emit(state.copyWith(isSearching: event.isSearching));
      final allUser = await db.retrieveAllUserData();
      final friends = await db.retrieveFriendsData();
      final currentUser = await db.retrieveUserData();
      List<UserModel> friendUser = [];
      for (var user in allUser) {
        if (!friends.any((element) => user.uid == element.uid)) {
          if (currentUser.uid != user.uid) {
            friendUser.add(user);
          }
        }
      }
      List<UserModel> searchedFriends = [];
      friendUser.every((element) {
        if(element.name!.toLowerCase().contains(event.name.toLowerCase())){
        searchedFriends.add(element);
        }
        return true;
      },);
      emit(state.copyWith(searchFriend: searchedFriends,friends: searchedFriends));
    }catch(ex){
      emit(state.copyWith(error: ex.toString()));
    }
  }
}
