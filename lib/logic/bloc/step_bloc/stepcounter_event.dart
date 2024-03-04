part of 'stepcounter_bloc.dart';

abstract class StepcounterEvent extends Equatable {
  const StepcounterEvent();

  @override
  List<Object> get props => [];
}

class OnStepIcreamentEvent extends StepcounterEvent {
  const OnStepIcreamentEvent({required this.step});
  final int step;
  @override
  List<Object> get props => [step];
}

class OnTimeIcreamentEvent extends StepcounterEvent {
  const OnTimeIcreamentEvent({
    required this.time,
  });
  final int time;
  @override
  List<Object> get props => [time];
}

class OntakePermissionEvent extends StepcounterEvent {
  const OntakePermissionEvent();

  @override
  List<Object> get props => [];
}

class OnGetStepsEvent extends StepcounterEvent {
  const OnGetStepsEvent();

  @override
  List<Object> get props => [];
}

class OnSetStepsEvent extends StepcounterEvent {
  const OnSetStepsEvent();

  @override
  List<Object> get props => [];
}

class OnGoalUpdate extends StepcounterEvent {
  const OnGoalUpdate({
    required this.goal,
    required this.targetCoin,
  });
  final int goal;
  final int targetCoin;
  @override
  List<Object> get props => [];
}

class OnGoalGet extends StepcounterEvent {
  const OnGoalGet();
  @override
  List<Object> get props => [];
}

class OnGetLastSevenDayStep extends StepcounterEvent{
  const OnGetLastSevenDayStep();

  @override
  List<Object> get props => [];
}

class OnGetLastMonthStep extends StepcounterEvent{
  const OnGetLastMonthStep();
  
  @override
  List<Object> get props => [];
}

class OnSetWater extends StepcounterEvent{
  @override
  List<Object> get props => [];
}

class OnGetWater extends StepcounterEvent{
  @override
  List<Object> get props => [];
}