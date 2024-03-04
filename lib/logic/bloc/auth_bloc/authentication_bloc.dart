import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/repository/authentication_repository.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        UserModel user = await _authenticationRepository.getCurrentUser().first;
        if (user.uid != "uid") {
          String? name = await _authenticationRepository.retrieveUserName(user);
          emit(AuthenticationSuccess(name: name));
        } else {
          emit(AuthenticationFailure());
        }
      } else if (event is AuthenticationGoogleStarted) {
        UserModel user = UserModel();
        final databaseRepository = DatabaseRepositoryImpl();
        final googleSignIn = GoogleSignIn();
        final auth = FirebaseAuth.instance;
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        UserModel updatedUser = user.copyWith(
            uid: userCredential.user?.uid,
            name: userCredential.user?.displayName,
            email: userCredential.user?.email,
            number: userCredential.user?.phoneNumber,
            isVerified: true);
        await databaseRepository.saveUserData(updatedUser);
        emit(const AuthenticationGoogleSuccess());
      } else if (event is AuthenticationSignedOut) {
        await _authenticationRepository.signOut();
        await _authenticationRepository.signOutGoogle();
        emit(AuthenticationFailure());
      }
    });
  }
}
