import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runandearn/logic/bloc/coin_bloc/coin_bloc.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'stepcounter_event.dart';
part 'stepcounter_state.dart';

class StepcounterBloc extends Bloc<StepcounterEvent, StepcounterState> {
  StepcounterBloc()
      : super(const StepcounterState(
            step: 0,
            calories: 0,
            kilometer: 0,
            time: 0,
            goal: 1000,
            isLoading: false,
            error: "",
            targetCoin: 500,
            lastSevenDaysStep: [],
            coin: 0,
            water: 0)) {
    final db = DatabaseRepositoryImpl();
    on<OnStepIcreamentEvent>((event, emit) {
      emit(state.copyWith(
        step: event.step,
        calories: state.step * 0.04,
        kilometer: (state.step * 0.76) / 1000,
      ));
    });
    
    on<OnGetStepsEvent>((event, emit) async {
      final getStep = await db.retrieveUserSteps();
      emit(state.copyWith(
        step: getStep.steps,
        calories: state.step * 0.04,
        kilometer: (state.step * 0.76) / 1000,
      ));
    });

    on<OnSetStepsEvent>((event, emit) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      //final getStep = await db.retrieveUserSteps();
      UserModel user = UserModel();
      UserModel updateSteps = user.copyWith(
          uid: uid, steps: state.step);
      await db.saveUserSteps(updateSteps);
    });

    on<OntakePermissionEvent>(_onTakePermission);

    on<OnTimeIcreamentEvent>((event, emit) {
      emit(state.copyWith(time: event.time));
    });

    on<OnGoalUpdate>((event, emit) async {
      UserModel user = UserModel();
      UserModel updateGoal =
          user.copyWith(goal: event.goal, coin: event.targetCoin);
      await db.saveUserGoal(updateGoal);
    });

    on<OnGoalGet>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        UserModel user = await db.retrieveUserGoal();
        final uid = FirebaseAuth.instance.currentUser?.uid;
        final getCoin = await db.retrieveUserCoins(user.copyWith(uid: uid));
        emit(state.copyWith(
            goal: user.goal, targetCoin: user.coin, coin: getCoin.coin));
      } catch (ex) {
        emit(state.copyWith(error: ex.toString()));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnGetLastSevenDayStep>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final lastSevenDaysSteps = await db.retrieveLastSevenDaysData();
        emit(state.copyWith(lastSevenDaysStep: lastSevenDaysSteps));
      } catch (ex) {
        emit(state.copyWith(error: ex.toString()));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnGetLastMonthStep>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final lastMonthSteps = await db.retrieveLastMonthData();
        emit(state.copyWith(lastSevenDaysStep: lastMonthSteps));
      } catch (ex) {
        emit(state.copyWith(error: ex.toString()));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<OnSetWater>((event, emit) async {
      try {
        final userModel = UserModel();
        final water = await db.retrieveWater();
        await db.addWater(userModel.copyWith(
            water: water.water != null ? water.water! + 1 : 1));
        add(OnGetWater());
      } catch (ex) {
        emit(state.copyWith(error: ex.toString()));
      }
    });

    on<OnGetWater>((event, emit) async {
      try {
        final water = await db.retrieveWater();
        emit(state.copyWith(water: water.water));
      } catch (ex) {
        emit(state.copyWith(error: ex.toString()));
      }
    });
  }
   final db = DatabaseRepositoryImpl();
  //late Timer time;
  _onTakePermission(
      OntakePermissionEvent event, Emitter<StepcounterState> emit) async {
        final data = await db.retrieveUserSteps();
        int step = data.steps ?? 0;
    try {
      PermissionStatus permission =
          await Permission.activityRecognition.request();
      if (permission == PermissionStatus.denied) {
        emit(state.copyWith(error: "Permission Denied"));
      } else if (permission == PermissionStatus.granted) {
        Pedometer.stepCountStream.listen((event) {
          add(OnStepIcreamentEvent(step: step++));
          coinBloc.add(CoinIcreament(step));
        },);
        // const oneSecond = Duration(seconds: 1);
        // time = Timer.periodic(oneSecond, (timer) {
        //   add(OnTimeIcreamentEvent(time: timer.tick));
        // });
      }
    } catch (ex) {
      emit(state.copyWith(error: ex.toString()));
    }
  }

  final coinBloc = CoinBloc();
}
