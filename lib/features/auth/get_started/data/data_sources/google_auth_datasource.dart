import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';

class GoogleAuthDataSource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  GoogleAuthDataSource({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  Future<AppResult<User?>> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.authenticate();

      final authentication = account.authentication;
      final idToken = authentication.idToken;

      if (idToken == null) {
        return Left(
          AuthFailure(message: LocaleKeys.failedToObtainGoogleIdToken.tr()),
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return Right(userCredential.user);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(CancelledFailure());
      }
      return Left(
        AuthFailure(
          message: e.description ?? LocaleKeys.googleSignInFailed.tr(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? LocaleKeys.firebaseAuthenticationFailed.tr(),
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
