sealed class CreateNewPasswordState {
  const CreateNewPasswordState();
}

final class CreateNewPasswordInitial extends CreateNewPasswordState {
  const CreateNewPasswordInitial();
}

final class CreateNewPasswordLoading extends CreateNewPasswordState {
  const CreateNewPasswordLoading();
}

final class CreateNewPasswordSuccess extends CreateNewPasswordState {
  const CreateNewPasswordSuccess();
}

final class CreateNewPasswordError extends CreateNewPasswordState {
  final String message;

  const CreateNewPasswordError(this.message);
}
