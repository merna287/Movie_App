import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';

class LoginDataSource {
  final FirebaseAuth _firebaseAuth;

  LoginDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<User?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return userCredential.user;
    });
  }
}
