sealed class ResetPasswordState {
  const ResetPasswordState();
}

final class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

final class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

final class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();
}

final class ResetPasswordError extends ResetPasswordState {
  final String message;

  const ResetPasswordError(this.message);
}
