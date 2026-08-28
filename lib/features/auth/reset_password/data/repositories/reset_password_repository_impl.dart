import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/auth/reset_password/data/data_sources/reset_password_data_source.dart';
import 'package:movie_app/features/auth/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordDataSource _dataSource;

  ResetPasswordRepositoryImpl(this._dataSource);

  @override
  Future<AppResult<bool>> sendPasswordResetEmail({
    required String email,
  }) {
    return _dataSource.sendPasswordResetEmail(email: email);
  }
}
