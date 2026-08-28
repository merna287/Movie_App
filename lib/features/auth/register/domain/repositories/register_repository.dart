import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';

abstract class RegisterRepository {
  Future<AppResult<User?>> signUp({
    required String email,
    required String password,
  });
}
