import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/auth/login/data/data_sources/login_data_source.dart';
import 'package:movie_app/features/auth/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource _dataSource;

  LoginRepositoryImpl(this._dataSource);

  @override
  Future<AppResult<User?>> signIn({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
