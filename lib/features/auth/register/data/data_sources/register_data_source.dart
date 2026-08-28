import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';

class RegisterDataSource {
  final FirebaseAuth _firebaseAuth;

  RegisterDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<User?>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return userCredential.user;
    });
  }
}
