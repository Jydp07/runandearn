part of 'community_bloc.dart';

class CommunityState extends Equatable {
  const CommunityState(
      {required this.isVideoPicked,
      required this.video,
      required this.isLoading,
      required this.error,
      required this.isSpeakerOn,
      this.controller,
      required this.fileInfo,
      required this.onThisPage,
      required this.communityData,
      required this.isUploaded,
      required this.isPlaying,
      required this.users,
      required this.description});
  final bool isVideoPicked;
  final File video;
  final String error;
  final bool isLoading;
  final List<VideoPlayerController> fileInfo;
  final bool isSpeakerOn;
  final bool isUploaded;
  final bool isPlaying;
  final bool onThisPage;
  final List<CommunityModel> communityData;
  final List<UserModel> users;
  final VideoPlayerController? controller;
  final String description;

  CommunityState copyWith(
      {bool? isVideoPicked,
      File? video,
      String? description,
      bool? isLoading,
      String? error,
      bool? isPlaying,
      List<VideoPlayerController>? fileInfo,
      List<UserModel>? users,
      bool? onThisPage,
      bool? isUploaded,
      List<CommunityModel>? communityData,
      VideoPlayerController? controller,
      bool? isSpeakerOn}) {
    return CommunityState(
        isVideoPicked: isVideoPicked ?? this.isVideoPicked,
        video: video ?? this.video,
        error: error ?? this.error,
        users:users ?? this.users,
        onThisPage:onThisPage ?? this.onThisPage,
        fileInfo: fileInfo ?? this.fileInfo,
        isPlaying: isPlaying ?? this.isPlaying,
        communityData: communityData ?? this.communityData,
        isUploaded: isUploaded ?? this.isUploaded,
        isLoading: isLoading ?? this.isLoading,
        isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
        controller: controller ?? this.controller,
        description: description ?? this.description);
  }

  @override
  List<Object?> get props => [
        isVideoPicked,
        video,
        description,
        isLoading,
        error,
        users,
        fileInfo,
        onThisPage,
        isSpeakerOn,
        controller,
        isUploaded,
        communityData,
        isPlaying
      ];
}
