import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';

abstract class LoginRepository {
  Future<AppResult<User?>> signIn({
    required String email,
    required String password,
  });
}
