part of 'friends_bloc.dart';

enum FriendStatus { friends, request, denied, accept, nothing, sent }

sealed class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class OnGetAllFriends extends FriendsEvent {
  @override
  List<Object> get props => [];
}

class GetContactEvent extends FriendsEvent {
  @override
  List<Object> get props => [];
}

class OnSentInviteEvent extends FriendsEvent {
  const OnSentInviteEvent(this.userId);
  final String userId;
  @override
  List<Object> get props => [userId];
}

class OnReferFriend extends FriendsEvent {
  const OnReferFriend();

  @override
  List<Object> get props => [];
}

class OnGetReferelCode extends FriendsEvent {
  const OnGetReferelCode({required this.referCode});
  final String referCode;
  @override
  List<Object> get props => [];
}

class OnGetFriendsData extends FriendsEvent {
  const OnGetFriendsData();
  @override
  List<Object> get props => [];
}

class OnChangeFriendRequestStatus extends FriendsEvent {
  const OnChangeFriendRequestStatus(
      {required this.userId, required this.status});
  final String status;
  final String userId;
  @override
  List<Object> get props => [status, userId];
}

class OnGetFreindsStep extends FriendsEvent {
  const OnGetFreindsStep();

  @override
  List<Object> get props => [];
}

class OnSearchFriends extends FriendsEvent {
  final String name;
  final bool isSearching;
  const OnSearchFriends({required this.isSearching, required this.name});
  @override
  List<Object> get props => [name,isSearching];
}

class OnGetFriendsDataAfter extends FriendsEvent{
  @override
  List<Object> get props => [];
}
