import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';

class FacebookAuthDataSource {
  static const List<String> _permissions = ['email', 'public_profile'];

  final FirebaseAuth _firebaseAuth;

  FacebookAuthDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppResult<User?>> signInWithFacebook() async {
    try {
      final loginResult = await FacebookAuth.instance.login(
        permissions: _permissions,
      );

      if (loginResult.status != LoginStatus.success) {
        if (loginResult.status == LoginStatus.cancelled) {
          return const Left(CancelledFailure());
        }

        return Left(
          AuthFailure(
            message: loginResult.message ?? LocaleKeys.facebookLoginFailed.tr(),
          ),
        );
      }

      final accessToken = loginResult.accessToken?.tokenString;

      if (accessToken == null) {
        return Left(
          AuthFailure(
            message: LocaleKeys.failedToObtainFacebookAccessToken.tr(),
          ),
        );
      }

      final credential = FacebookAuthProvider.credential(accessToken);

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Facebook Auth Error: ${e.code}');
      debugPrint('Message: ${e.message}');

      return Left(
        AuthFailure(
          message: e.message ?? LocaleKeys.firebaseAuthenticationFailed.tr(),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Facebook Login Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      return Left(
        AuthFailure(
          message: e.toString(),
        ),
      );
    }
  }
}