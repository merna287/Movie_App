import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/auth/create_new_password/data/data_sources/create_new_password_data_source.dart';
import 'package:movie_app/features/auth/create_new_password/domain/repositories/create_new_password_repository.dart';

class CreateNewPasswordRepositoryImpl implements CreateNewPasswordRepository {
  final CreateNewPasswordDataSource _dataSource;

  CreateNewPasswordRepositoryImpl(this._dataSource);

  @override
  Future<AppResult<bool>> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) {
    return _dataSource.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }
}
