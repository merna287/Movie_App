import 'dart:convert';
import 'dart:io';

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
  } on AuthFailure catch (e) {
    return Left(e);
  } on Failure catch (e) {
    return Left(e);
  } catch (_) {
    return const Left(UnknownFailure());
  }
}
