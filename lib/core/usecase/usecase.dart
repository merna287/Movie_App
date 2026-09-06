/// Base contract for application use cases (domain layer).
abstract interface class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// Marker for use cases that take no input.
final class NoParams {
  const NoParams();
}
