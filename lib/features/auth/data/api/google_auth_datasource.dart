import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/core/errors/failure.dart';

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
        return const Left(
          AuthFailure(message: 'Failed to obtain Google ID token'),
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
      return Left(AuthFailure(message: e.description ?? 'Google sign-in failed'));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Firebase authentication failed'));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
