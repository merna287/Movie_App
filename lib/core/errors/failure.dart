import 'package:fpdart/fpdart.dart';

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
