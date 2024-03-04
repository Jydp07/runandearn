part of 'form_bloc.dart';

enum Status { signIn, signUp,signUpExtra,signInWithGoogle,forgetPassword}

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends FormEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends FormEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}
class RepasswordChanged extends FormEvent {
  final String password;
  final String repassword;
  const RepasswordChanged(this.password,this.repassword);

  @override
  List<Object> get props => [password,repassword];
}

class NameChanged extends FormEvent {
  final String name;
  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}
class NumberChanged extends FormEvent {
  final String number;
  const NumberChanged(this.number);

  @override
  List<Object> get props => [number];
}

class GenderChanged extends FormEvent {
  final String gender;
  const GenderChanged(this.gender);

  @override
  List<Object> get props => [gender];
}
class DOBChanged extends FormEvent {
  final String dob;
  const DOBChanged(this.dob);

  @override
  List<Object> get props => [dob];
}

class WeightChanged extends FormEvent {
  final double weight;
  const WeightChanged(this.weight);

  @override
  List<Object> get props => [weight];
}

class HeightChanged extends FormEvent {
  final double height;
  const HeightChanged(this.height);

  @override
  List<Object> get props => [height];
}

class ForgetPassword extends FormEvent{
  const ForgetPassword();
  @override
  List<Object> get props => [];
}

class FormSubmittedSignUp extends FormEvent {
  final Status value;
  const FormSubmittedSignUp({required this.value});

  @override
  List<Object> get props => [value];
}

class FormSubmittedSignUpExtra extends FormEvent {
  const FormSubmittedSignUpExtra();

  @override
  List<Object> get props => [];
}

class FormSucceeded extends FormEvent {
  const FormSucceeded();

  @override
  List<Object> get props => [];
}