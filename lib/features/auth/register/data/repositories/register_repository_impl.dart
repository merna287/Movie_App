import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/auth/register/data/data_sources/register_data_source.dart';
import 'package:movie_app/features/auth/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource _dataSource;

  RegisterRepositoryImpl(this._dataSource);

  @override
  Future<AppResult<User?>> signUp({
    required String email,
    required String password,
  }) {
    return _dataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
