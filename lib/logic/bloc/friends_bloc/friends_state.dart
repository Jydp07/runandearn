part of 'friends_bloc.dart';

class FriendsState extends Equatable {
  const FriendsState(
      {required this.isLoading,
      required this.friends,
      required this.error,
      required this.isAccept,
      required this.searchFriend,
      required this.isReferelCodeValid,
      required this.friendsRequest,
      required this.isSearching,
      required this.referelCode});
  final bool isLoading;
  final List<UserModel> friends;
  final List<UserModel> friendsRequest;
  final List<UserModel> searchFriend;
  final String referelCode;
  final bool isAccept;
  final bool isReferelCodeValid;
  final String error;
  final bool isSearching;

  FriendsState copyWith(
      {bool? isLoading,
      List<UserModel>? friends,
      String? error,
      String? referelCode,
      bool? isAccept,
      List<UserModel>? searchFriend,
      List<UserModel>? friendsRequest,
      bool? isSearching,
      bool? isReferelCodeValid}) {
    return FriendsState(
        isLoading: isLoading ?? this.isLoading,
        friends: friends ?? this.friends,
        error: error ?? this.error,
        friendsRequest: friendsRequest ?? this.friendsRequest,
        isAccept: isAccept ?? this.isAccept,
        isSearching: isSearching ?? this.isSearching,
        searchFriend: searchFriend ?? this.searchFriend,
        referelCode: referelCode ?? this.referelCode,
        isReferelCodeValid: isReferelCodeValid ?? this.isReferelCodeValid);
  }

  @override
  List<Object> get props => [
        isLoading,
        friends,
        error,
        referelCode,
        isSearching,
        isReferelCodeValid,
        friendsRequest,
        searchFriend
      ];
}
