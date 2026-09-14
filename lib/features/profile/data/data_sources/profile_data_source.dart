import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';

class ProfileDataSource {
  final FirebaseAuth _firebaseAuth;

  ProfileDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<User?>> updateProfile({
    required String displayName,
    required String email,
    String? newPassword,
  }) {
    return safeApiCall(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      await user.updateProfile(displayName: displayName.trim());

      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      if (email.trim().toLowerCase() != (user.email ?? '').toLowerCase()) {
        await user.verifyBeforeUpdateEmail(email.trim());
      }

      await user.reload();
      return _firebaseAuth.currentUser ?? user;
    });
  }
}