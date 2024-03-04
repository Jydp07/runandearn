part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class DatabaseFetched extends DatabaseEvent {
  const DatabaseFetched();
  @override
  List<Object?> get props => [];
}

class DatabaseUpdate extends DatabaseEvent {
  const DatabaseUpdate();
  @override
  List<Object?> get props => [];
}

class UpdateUserData extends DatabaseEvent {
  const UpdateUserData(
      {required this.name,
      required this.number,
      required this.height,
      required this.weight});
  final String name;
  final String number;
  final double height;
  final double weight;
  @override
  List<Object?> get props => [name, number, height, weight];
}
