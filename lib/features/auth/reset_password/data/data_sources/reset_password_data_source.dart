import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';

class ResetPasswordDataSource {
  final FirebaseAuth _firebaseAuth;

  ResetPasswordDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<bool>> sendPasswordResetEmail({
    required String email,
  }) {
    return safeApiCall(() async {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return true;
    });
  }
}
