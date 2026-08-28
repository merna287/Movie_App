import 'package:movie_app/core/errors/failure.dart';

abstract class CreateNewPasswordRepository {
  Future<AppResult<bool>> confirmPasswordReset({
    required String code,
    required String newPassword,
  });
}
