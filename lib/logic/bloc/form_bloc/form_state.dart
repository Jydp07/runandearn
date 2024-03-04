part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  const FormState();
}

class FormsValidate extends FormState {
  const FormsValidate(
      {required this.email,
      required this.password,
      required this.repassword,
      required this.height,
      required this.dob,
      required this.name,
      required this.gender,
      required this.isNumberValid,
      required this.weight,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isFormValid,
      required this.isLoading,
      this.errorMessage = "",
      required this.isNameValid,
      required this.isGenderValid,
      required this.number,
      required this.isDOBValid,
      required this.isHeightValid,
      required this.isWeightValid,
      required this.isFormValidateFailed,
      required this.isPasswordMatch,
      this.isFormSuccessful = false});

  final String email;
  final double height;
  final double weight;
  final String name;
  final String number;
  final String gender;
  final String dob;
  final bool isPasswordMatch;
  final bool isNumberValid;
  final String password;
  final String repassword;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final bool isNameValid;
  final bool isGenderValid;
  final bool isDOBValid;
  final bool isHeightValid;
  final bool isWeightValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;

  FormsValidate copyWith(
      {String? email,
      String? password,
      String? repassword,
      bool? isEmailValid,
      String? name,
      String? number,
      bool? isPasswordValid,
      bool? isPasswordMatch,
      bool? isFormValid,
      bool? isLoading,
      bool? isGenderValid,
      bool? isDOBValid,
      bool? isHeightValid,
      bool? isWeightValid,
      bool? isNumberValid,
      String? gender,
      double? height,
      String? dob,
      double? weight,
      String? errorMessage,
      bool? isNameValid,
      bool? isFormValidateFailed,
      bool? isFormSuccessful}) {
    return FormsValidate(
        email: email ?? this.email,
        password: password ?? this.password,
        isPasswordMatch: isPasswordMatch ?? this.isPasswordMatch,
        repassword: repassword ?? this.repassword,
        gender: gender ?? this.gender,
        name: name ?? this.name,
        number: number ?? this.number,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        isNumberValid: isNumberValid ?? this.isNumberValid,
        dob: dob ?? this.dob,
        isDOBValid: isDOBValid ?? this.isDOBValid,
        isHeightValid: isHeightValid ?? this.isHeightValid,
        isWeightValid: isWeightValid ?? this.isWeightValid,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isFormValid: isFormValid ?? this.isFormValid,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isNameValid: isNameValid ?? this.isNameValid,
        isGenderValid: isGenderValid ?? this.isGenderValid,
        isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
        isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful);
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        isLoading,
        number,
        errorMessage,
        isNameValid,
        name,
        isNumberValid,
        isDOBValid,
        isGenderValid,
        isHeightValid,
        isWeightValid,
        dob,
        gender,
        height,
        weight,
        isFormValidateFailed,
        isFormSuccessful,
        isPasswordMatch,
        repassword,
      ];
}
