import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';
part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormsValidate> {
  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;
  FormBloc(this._authenticationRepository, this._databaseRepository)
      : super(const FormsValidate(
            email: "",
            password: "",
            name: "",
            isNumberValid: true,
            isEmailValid: true,
            isPasswordValid: true,
            isPasswordMatch: true,
            isFormValid: false,
            isLoading: false,
            isNameValid: true,
            isFormValidateFailed: false,
            height: 0,
            number: '',
            isHeightValid: true,
            weight: 0,
            isWeightValid: true,
            dob: '',
            gender: '',
            isGenderValid: true,
            isDOBValid: true,
            repassword: "")) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<NumberChanged>(_onNumberChanged);
    on<GenderChanged>(_onGenderValid);
    on<DOBChanged>(_onDOBValid);
    on<HeightChanged>(_onHeightValid);
    on<WeightChanged>(_onWeightValid);
    on<FormSubmittedSignUp>(_onFormSubmittedSignUp);
    on<FormSucceeded>(_onFormSucceeded);
    on<RepasswordChanged>(_onRepasswordChanged);
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$',
  );
  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPassValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _isRepassMatch(String password, String repassword) {
    return password == repassword;
  }

  bool _isNameValid(String name) {
    return name.isNotEmpty;
  }

  bool _isNumberValid(String number) {
    return number.length == 10;
  }

  bool _isGenderValid(String gender) {
    return gender.isNotEmpty;
  }

  bool _isDOBValid(String dob) {
    return dob.isNotEmpty;
  }

  bool _isHeightValid(double height) {
    return height > 0;
  }

  bool _isWeightValid(double weight) {
    return weight > 0;
  }

  _onEmailChanged(EmailChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      errorMessage: "",
      email: event.email,
      isFormSuccessful: false,
      isFormValidateFailed: false,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      errorMessage: "",
      password: event.password,
      isFormSuccessful: false,
      isFormValidateFailed: false,
      isPasswordValid: _isPassValid(event.password),
    ));
  }

  _onRepasswordChanged(RepasswordChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      errorMessage: "",
      isFormSuccessful: false,
      isFormValidateFailed: false,
      repassword: event.repassword,
      isPasswordMatch: _isRepassMatch(event.password, event.repassword),
    ));
  }

  _onNameChanged(NameChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      errorMessage: "",
      name: event.name,
      isFormSuccessful: false,
      isFormValidateFailed: false,
      isNameValid: _isNameValid(event.name),
    ));
  }

  _onNumberChanged(NumberChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      errorMessage: "",
      number: event.number,
      isFormSuccessful: false,
      isFormValidateFailed: false,
      isNumberValid: _isNumberValid(event.number),
    ));
  }

  _onGenderValid(GenderChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
        errorMessage: "",
        isFormSuccessful: false,
        isFormValidateFailed: false,
        gender: event.gender,
        isGenderValid: _isGenderValid(event.gender)));
  }

  _onDOBValid(DOBChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
        errorMessage: "",
        dob: event.dob,
        isFormSuccessful: false,
        isFormValidateFailed: false,
        isDOBValid: _isDOBValid(event.dob)));
  }

  _onHeightValid(HeightChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
        errorMessage: "",
        height: event.height,
        isFormSuccessful: false,
        isFormValidateFailed: false,
        isHeightValid: _isHeightValid(event.height)));
  }

  _onWeightValid(WeightChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
        errorMessage: "",
        weight: event.weight,
        isFormSuccessful: false,
        isFormValidateFailed: false,
        isWeightValid: _isWeightValid(event.weight)));
  }

  _onFormSubmittedSignUp(
      FormSubmittedSignUp event, Emitter<FormsValidate> emit) async {
    UserModel user = UserModel(
        email: state.email, password: state.password, name: state.name);

    if (event.value == Status.signUp) {
      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, user);
    } else if (event.value == Status.signUpExtra) {
      await _onFormSubmittedSignUpExtra(event, emit, user);
    } else if (event.value == Status.signInWithGoogle) {
      await _signInWithGoogle(event, emit, user);
    }else if(event.value == Status.forgetPassword){
      await _forgetPassword(event, emit, user);
    }
  }

  _onFormSubmittedSignUpExtra(FormSubmittedSignUp event,
      Emitter<FormsValidate> emit, UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isDOBValid(state.dob) &&
            _isGenderValid(state.gender) &&
            _isHeightValid(state.height) &&
            _isWeightValid(state.weight),
        isLoading: true));
    if (state.isFormValid) {
      try {
        User? authUser = FirebaseAuth.instance.currentUser;
        UserModel updatedUser = user.copyWith(
            gender: state.gender,
            dob: state.dob,
            uid: authUser?.uid,
            height: state.height,
            weight: state.weight,
            isExtraData: true);
        await _databaseRepository.updateUserdata(updatedUser);
        emit(state.copyWith(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }

  _updateUIAndSignUp(FormSubmittedSignUp event, Emitter<FormsValidate> emit,
      UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isPassValid(state.password) &&
            _isEmailValid(state.email) &&
            _isNameValid(state.name) &&
            _isRepassMatch(state.password, state.repassword),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signUp(user);
        UserModel updatedUser = user.copyWith(
          uid: authUser?.user?.uid,
          isVerified: authUser?.user?.emailVerified,
          number: state.number,
          name: state.name,
        );
        await _databaseRepository.saveUserData(updatedUser);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: "Verify email."));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(FormSubmittedSignUp event, Emitter<FormsValidate> emit,
      UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isPassValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signIn(user);
        UserModel updatedUser = user.copyWith(
            uid: authUser?.user?.uid,
            isVerified: authUser?.user?.emailVerified);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _signInWithGoogle(FormSubmittedSignUp event, Emitter<FormsValidate> emit,
      UserModel user) async {
    try {} on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: e.message, isFormValid: false));
    }
  }

  _forgetPassword(FormSubmittedSignUp event, Emitter<FormsValidate> emit,
      UserModel userModel) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        AuthenticationRepositoryImpl authRepository =
            AuthenticationRepositoryImpl();
        await authRepository
            .forgetPassword(userModel.copyWith(email: state.email));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }
}
