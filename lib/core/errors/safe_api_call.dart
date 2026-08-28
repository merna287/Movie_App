import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

Future<AppResult<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();

    return Right(result);
  } on SocketException {
    return const Left(NetworkFailure());
  } on NetworkException {
    return const Left(NetworkFailure());
  } on ServerException catch (e) {
    String? serverMessage;

    if (e.responseBody != null) {
      try {
        final jsonBody = jsonDecode(e.responseBody!);

        if (jsonBody is Map<String, dynamic>) {
          serverMessage =
              jsonBody['message']?.toString() ?? jsonBody['error']?.toString();
        }
      } catch (_) {
        serverMessage = null;
      }
    }

    return Left(
      ServerFailure(statusCode: e.statusCode, serverMessage: serverMessage),
    );
  } on ParsingException {
    return const Left(ParsingFailure());
  } on CacheException {
    return const Left(CacheFailure());
  } on AuthException catch (e) {
    return Left(AuthFailure(message: e.message));
  } on AuthFailure catch (e) {
    return Left(e);
  } on FirebaseAuthException catch (e) {
    return Left(
      AuthFailure(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
      ),
    );
  } on Failure catch (e) {
    return Left(e);
  } catch (_) {
    return const Left(UnknownFailure());
  }
}

String _mapFirebaseAuthError(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'This email is already registered. Please sign in instead.';
    case 'weak-password':
      return 'The password is too weak. Please choose a stronger password.';
    case 'invalid-email':
      return 'The email address is invalid.';
    case 'user-not-found':
      return 'No account found with this email address.';
    case 'operation-not-allowed':
      return 'Email/password sign-up is not enabled.';
    case 'network-request-failed':
    case 'network_error':
      return 'No internet connection. Please try again.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    default:
      return 'Authentication failed. Please try again.';
  }
}
