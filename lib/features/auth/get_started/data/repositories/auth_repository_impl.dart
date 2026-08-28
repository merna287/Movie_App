import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/facebook_auth_datasource.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/google_auth_datasource.dart';
import 'package:movie_app/features/auth/get_started/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleAuthDataSource _googleDataSource;
  final FacebookAuthDataSource _facebookDataSource;

  AuthRepositoryImpl(this._googleDataSource, this._facebookDataSource);

  @override
  Future<AppResult<User?>> signInWithGoogle() {
    return _googleDataSource.signInWithGoogle();
  }

  @override
  Future<AppResult<User?>> signInWithFacebook() {
    return _facebookDataSource.signInWithFacebook();
  }
}
