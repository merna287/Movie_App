import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';

abstract class AuthRepository {
  Future<AppResult<User?>> signInWithGoogle();

  Future<AppResult<User?>> signInWithFacebook();
}
