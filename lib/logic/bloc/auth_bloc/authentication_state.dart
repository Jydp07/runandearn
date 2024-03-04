part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  
  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
      @override
  List<Object?> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final String? name;
  const AuthenticationSuccess({this.name});

    @override
  List<Object?> get props => [name];
}

class AuthenticationGoogleSuccess extends AuthenticationState {
  final String? name;
  const AuthenticationGoogleSuccess({this.name});

    @override
  List<Object?> get props => [name];
}

class AuthenticationFailure extends AuthenticationState {
      @override
  List<Object?> get props => [];
}
