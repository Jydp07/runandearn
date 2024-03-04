part of 'database_bloc.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();
  
  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseSuccess extends DatabaseState {
  final UserModel userData;
  final UserModel userExtraData;
  const DatabaseSuccess(this.userData,this.userExtraData);

    @override
  List<Object?> get props => [userData,userExtraData];
}

class UserUpdateSuccess extends DatabaseState {
  
  const UserUpdateSuccess();

    @override
  List<Object?> get props => [];
}
class DatabaseUpdateSuccess extends DatabaseState {
  const DatabaseUpdateSuccess(this.userData, this.isReferedOnce);
  final UserModel? userData;
  final bool? isReferedOnce;
    @override
  List<Object?> get props => [userData,isReferedOnce];
}
class DatabaseError extends DatabaseState {
      @override
  List<Object?> get props => [];
}