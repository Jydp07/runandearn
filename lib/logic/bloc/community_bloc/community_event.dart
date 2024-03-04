part of 'community_bloc.dart';

sealed class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object> get props => [];
}

class OnPickVideo extends CommunityEvent {
  @override
  List<Object> get props => [];
}

class OnChangedCaption extends CommunityEvent {
  final String description;

  const OnChangedCaption(this.description);
  @override
  List<Object> get props => [description];
}

class OnGetCommunityData extends CommunityEvent{
  const OnGetCommunityData({this.onThisPage = false});
  final bool onThisPage;
  @override
  List<Object> get props => [onThisPage];
}

class OnChangedReels extends CommunityEvent{
  const OnChangedReels({this.index = 0,this.onThisPage = false});
  final int index;
  final bool onThisPage;
  @override
  List<Object> get props => [index,onThisPage];
}
class OnPlayPauseVideo extends CommunityEvent{
  final bool isPlaying;

  const OnPlayPauseVideo({required this.isPlaying});
  @override
  List<Object> get props => [isPlaying];
}

class DisposeObjects extends CommunityEvent{
  @override
  List<Object> get props => [];
}
class OnSpeakerChanged extends CommunityEvent {

  const OnSpeakerChanged();
  @override
  List<Object> get props => [];
}

class UploadVideoEvent extends CommunityEvent {
  @override
  List<Object> get props => [];
}

class OnThisPage extends CommunityEvent{
  const OnThisPage({required this.onthispage});
  final bool onthispage;
  @override
  List<Object> get props => [onthispage];
} 