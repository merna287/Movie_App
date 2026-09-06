import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';

class RegisterDataSource {
  final FirebaseAuth _firebaseAuth;

  RegisterDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<User?>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final username = name.trim();
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      debugPrint('[AUTH-TRACE] signup username = "$username"');

      await _saveDisplayName(user, username);

      var resolved = _firebaseAuth.currentUser ?? user;
      final stored = resolved.displayName?.trim() ?? '';
      debugPrint('[AUTH-TRACE] firebase displayName = "$stored"');

      if (stored.isEmpty) {
        debugPrint(
          '[AUTH-TRACE] firebase displayName not persisted yet; saving again',
        );
        await _saveDisplayName(resolved, username);
        resolved = _firebaseAuth.currentUser ?? resolved;
        final verified = resolved.displayName?.trim() ?? '';
        debugPrint(
          '[AUTH-TRACE] firebase displayName (after retry) = "$verified"',
        );
        if (verified.isEmpty) {
          throw AuthFailure(
            code: 'display-name-not-saved',
            message: LocaleKeys.profileNameSaveFailed.tr(),
          );
        }
      }

      return resolved;
    });
  }

  Future<void> _saveDisplayName(User user, String username) async {
    await user.updateDisplayName(username);
    try {
      await user.reload();
    } catch (_) {
      debugPrint('[AUTH-TRACE] reload after saving displayName failed');
    }
  }
}
