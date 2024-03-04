part of 'stepcounter_bloc.dart';

class StepcounterState extends Equatable {
  const StepcounterState({
    required this.lastSevenDaysStep,
    required this.isLoading,
    required this.error,
    required this.step,
    required this.targetCoin,
    required this.calories,
    required this.kilometer,
    required this.time,
    required this.coin,
    required this.water,
    required this.goal,
  });
  final int step;
  final int time;
  final int targetCoin;
  final double calories;
  final double kilometer;
  final int goal;
  final int coin;
  final int water;
  final List<UserModel> lastSevenDaysStep;
  final bool isLoading;
  final String error;

  StepcounterState copyWith(
      {int? step,
      int? time,
      double? calories,
      double? kilometer,
      int? goal,
      List<UserModel>? lastSevenDaysStep,
      bool? isLoading,
      String? error,
      int? targetCoin,
      int? water,
      int? coin}) {
    return StepcounterState(
        step: step ?? this.step,
        time: time ?? this.time,
        coin: coin ?? this.coin,
        calories: calories ?? this.calories,
        kilometer: kilometer ?? this.kilometer,
        goal: goal ?? this.goal,
        water:water ?? this.water,
        isLoading: isLoading ?? this.isLoading,
        lastSevenDaysStep: lastSevenDaysStep ?? this.lastSevenDaysStep,
        error: error ?? this.error,
        targetCoin: targetCoin ?? this.targetCoin);
  }

  @override
  List<Object> get props =>
      [step, calories, kilometer, time, goal, isLoading, error, targetCoin,lastSevenDaysStep,water];
}
