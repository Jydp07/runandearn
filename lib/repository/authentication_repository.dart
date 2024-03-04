import 'package:google_sign_in/google_sign_in.dart';
import 'package:runandearn/models/user_model.dart';
import 'package:runandearn/services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runandearn/services/database_services.dart';
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationService service = AuthenticationService();
  DatabaseService dbService = DatabaseService();
  @override
  Stream<UserModel> getCurrentUser() {
    return service.retrieveCurrentUser();
  }
  @override
  Future<UserCredential?> signUp(UserModel user) {
    try {
      return service.signUp(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) {
    try {
      return service.signIn(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
  @override
  Future<void> signOut() {
    return service.signOut();
  }

  @override
  Future<GoogleSignInAccount?> signOutGoogle(){
    return service.googleSignOut();
  }
  @override
  Future<String?> retrieveUserName(UserModel user) {
    return dbService.retrieveUserName(user);
  }
  
  @override
  Future<void> forgetPassword(UserModel userModel) {
    return service.forgetPassword(userModel);
  }
}

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential?> signUp(UserModel user);
  Future<UserCredential?> signIn(UserModel user);
  Future<void> signOut();
  Future<void> forgetPassword(UserModel userModel);
  Future<GoogleSignInAccount?> signOutGoogle();
  Future<String?> retrieveUserName(UserModel user);
}
