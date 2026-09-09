import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/profile/data/data_sources/profile_data_source.dart';
import 'package:movie_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<AppResult<User?>> updateProfile({
    required String displayName,
    required String email,
    String? newPassword,
  }) {
    return _dataSource.updateProfile(
      displayName: displayName,
      email: email,
      newPassword: newPassword,
    );
  }
}