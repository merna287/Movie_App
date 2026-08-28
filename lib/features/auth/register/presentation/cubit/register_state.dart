import 'package:firebase_auth/firebase_auth.dart';

sealed class RegisterState {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

final class RegisterSuccess extends RegisterState {
  final User user;

  const RegisterSuccess(this.user);
}

final class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);
}
