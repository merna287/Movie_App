import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';

class CreateNewPasswordDataSource {
  final FirebaseAuth _firebaseAuth;

  CreateNewPasswordDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<bool>> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) {
    return safeApiCall(() async {
      await _firebaseAuth.verifyPasswordResetCode(code);

      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );

      return true;
    });
  }
}
