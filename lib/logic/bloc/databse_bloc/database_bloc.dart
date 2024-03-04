import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository _databaseRepository;
  DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
    on<DatabaseUpdate>((event, emit) async {
      UserModel userData = await _databaseRepository.retrieveUserData();
      final isReferedOnce = await _databaseRepository.retrieveIfReferedOnce();
      if (userData.email != null) {
        emit(DatabaseUpdateSuccess(userData, isReferedOnce.isReferedOnce));
      }
    });
    on<UpdateUserData>(_onUpdateUserData);
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    UserModel userData = await _databaseRepository.retrieveUserData();
    UserModel userExtraData = await _databaseRepository.retrieveUserExtraData(userData);
    if (userData.email != null) {
      emit(DatabaseSuccess(userData, userExtraData));
    }
  }

  _onUpdateUserData(UpdateUserData event, Emitter<DatabaseState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (event.name.isNotEmpty &&
        event.number.length == 10 &&
        event.height >= 3 &&
        event.weight >= 20) {
      UserModel user = UserModel();
      final updated = user.copyWith(
        uid: uid,
          name: event.name,
          number: event.number,
          height: event.height,
          weight: event.weight);
      await _databaseRepository.updateUserProfiledata(updated);
      emit(const UserUpdateSuccess());
    } else {
      emit(DatabaseError());
    }
  }
}
