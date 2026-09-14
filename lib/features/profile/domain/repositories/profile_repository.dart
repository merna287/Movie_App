import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';

abstract class ProfileRepository {
  Future<AppResult<User?>> updateProfile({
    required String displayName,
    required String email,
    String? newPassword,
  });
}