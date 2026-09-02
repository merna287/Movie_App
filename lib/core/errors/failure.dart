import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';

sealed class Failure {
  final String message;

  const Failure({required this.message});

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

final class ServerFailure extends Failure {
  final int? statusCode;
  final String? serverMessage;

  const ServerFailure({
    this.statusCode,
    this.serverMessage,
    super.message = 'Server error',
  });
}

final class ParsingFailure extends Failure {
  const ParsingFailure({super.message = 'Failed to parse response'});
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

final class AuthFailure extends Failure {
  final String? code;

  const AuthFailure({
    super.message = 'Email or password is incorrect',
    this.code,
  });
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed'});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unknown error'});
}

final class CancelledFailure extends Failure {
  const CancelledFailure({super.message = 'Operation cancelled'});
}

typedef AppResult<T> = Either<Failure, T>;

String failureMessage(Failure failure) {
  if (failure is NetworkFailure) {
    return LocaleKeys.noInternetConnection.tr();
  }
  if (failure is ServerFailure) {
    final statusCode = failure.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return 'TMDB authentication failed. Check your API token.';
    }
    if (statusCode != null) {
      return 'TMDB request failed (HTTP $statusCode).';
    }
    return failure.serverMessage ?? LocaleKeys.unexpectedError.tr();
  }
  if (failure is ParsingFailure) {
    return 'Failed to parse TMDB response.';
  }
  return LocaleKeys.unexpectedError.tr();
}
