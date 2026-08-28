import 'package:movie_app/core/errors/failure.dart';

abstract class ResetPasswordRepository {
  Future<AppResult<bool>> sendPasswordResetEmail({
    required String email,
  });
}
