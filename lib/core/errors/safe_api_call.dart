import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
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
      return LocaleKeys.emailAlreadyInUse.tr();
    case 'weak-password':
      return LocaleKeys.weakPassword.tr();
    case 'invalid-email':
      return LocaleKeys.invalidEmailAddress.tr();
    case 'user-not-found':
      return LocaleKeys.userNotFound.tr();
    case 'operation-not-allowed':
      return LocaleKeys.operationNotAllowed.tr();
    case 'invalid-action-code':
      return LocaleKeys.invalidActionCode.tr();
    case 'expired-action-code':
      return LocaleKeys.expiredActionCode.tr();
    case 'network-request-failed':
    case 'network_error':
      return LocaleKeys.noInternetConnection.tr();
    case 'too-many-requests':
      return LocaleKeys.tooManyRequests.tr();
    default:
      return LocaleKeys.authenticationFailedTryAgain.tr();
  }
}
