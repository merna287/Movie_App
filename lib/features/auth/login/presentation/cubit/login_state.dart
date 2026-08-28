import 'package:firebase_auth/firebase_auth.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess(this.user);
}

final class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);
}
