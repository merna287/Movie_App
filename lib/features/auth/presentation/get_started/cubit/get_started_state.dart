import 'package:firebase_auth/firebase_auth.dart';

sealed class GetStartedState {
  const GetStartedState();
}

final class GetStartedInitial extends GetStartedState {
  const GetStartedInitial();
}

final class GetStartedLoading extends GetStartedState {
  const GetStartedLoading();
}

final class GetStartedSuccess extends GetStartedState {
  final User user;

  const GetStartedSuccess(this.user);
}

final class GetStartedError extends GetStartedState {
  final String message;

  const GetStartedError(this.message);
}
