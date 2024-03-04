import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc() : super(const CoinState(coin: 0)) {
    final databaseRepository = DatabaseRepositoryImpl();
    on<CoinIcreament>((event, emit) async {
      if (event.steps == 500) {
        final currentUser = await databaseRepository.retrieveUserData();
        UserModel user = UserModel();
        final getCoins = await databaseRepository
            .retrieveUserCoins(user.copyWith(uid: currentUser.uid));
        databaseRepository.saveUserCoins(user.copyWith(
            coin: getCoins.coin != null ? getCoins.coin! + 1 : 1));
        emit(state.copyWith(coin: getCoins.coin));
      }
    });

    on<CoinGet>((event, emit) async {
      final currentUser = await databaseRepository.retrieveUserData();
      UserModel user = UserModel();
      final data = await databaseRepository
          .retrieveUserCoins(user.copyWith(uid: currentUser.uid));
      emit(state.copyWith(coin: data.coin));
    });
  }
}
