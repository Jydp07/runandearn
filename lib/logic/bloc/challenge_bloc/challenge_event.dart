part of 'challenge_bloc.dart';

sealed class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object> get props => [];
}

class OnNameChanged extends ChallengeEvent{
  const OnNameChanged({required this.name});

  final String name;
  @override
  List<Object> get props => [name];
}

class OnPriceChanged extends ChallengeEvent{
  const OnPriceChanged({required this.price});

  final double price;
  @override
  List<Object> get props => [price];
}

class OnImageChanged extends ChallengeEvent{
  const OnImageChanged();
  @override
  List<Object> get props => [];
}

class OnStepsChanges extends ChallengeEvent{
  const OnStepsChanges({required this.steps});
  final int steps;
  @override
  List<Object> get props => [];
}

class OnDescriptionChanged extends ChallengeEvent{
  const OnDescriptionChanged({required this.description});

  final String description;
  @override
  List<Object> get props => [description];
}

class OnTimeLimitChanged extends ChallengeEvent{
  const OnTimeLimitChanged({required this.dayLimit});
  final int dayLimit;

  @override
  List<Object> get props => [dayLimit];
}

class OnSubmitData extends ChallengeEvent{
  @override
  List<Object> get props => [];
}

class OnDeleteChallenge extends ChallengeEvent{
  const OnDeleteChallenge({required this.uid});
  final String uid;
  @override
  List<Object> get props => [uid];
}

class OnGetChallengeData extends ChallengeEvent{
  const OnGetChallengeData();

  @override
  List<Object> get props => [];
}

class OnAcceptChallenge extends ChallengeEvent{
  const OnAcceptChallenge({required this.steps, required this.prize,required this.uid});
  final int steps;
  final String uid;
  final double prize;
  @override
  List<Object> get props => [steps,prize];
}

class OnGetUserChallenge extends ChallengeEvent{
  const OnGetUserChallenge();
  @override
  List<Object> get props => [];
}

class OnClaimReward extends ChallengeEvent{
  const OnClaimReward({required this.uid});
  final String uid;
  @override
  List<Object> get props => [uid];
}

class OnRewardUser extends ChallengeEvent{
  const OnRewardUser({required this.uid});
  final String uid;
  @override
  List<Object> get props => [uid];
}

class OnDeleteHistory extends ChallengeEvent{
  const OnDeleteHistory({required this.uid});
  final String uid;
  @override
  List<Object> get props => [uid];
}