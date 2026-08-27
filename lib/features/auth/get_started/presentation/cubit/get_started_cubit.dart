import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/features/auth/presentation/get_started/cubit/get_started_state.dart';

class GetStartedCubit extends Cubit<GetStartedState> {
  final AuthRepository _authRepository;

  GetStartedCubit(this._authRepository) : super(const GetStartedInitial());

  Future<void> signInWithGoogle() async {
    emit(const GetStartedLoading());

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        emit(GetStartedError(message));
      },
      (user) {
        if (user != null) {
          emit(GetStartedSuccess(user));
        } else {
          emit(const GetStartedError('Sign-in was cancelled'));
        }
      },
    );
  }

  Future<void> signInWithFacebook() async {
    emit(const GetStartedLoading());

    final result = await _authRepository.signInWithFacebook();

    result.fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        emit(GetStartedError(message));
      },
      (user) {
        if (user != null) {
          emit(GetStartedSuccess(user));
        } else {
          emit(const GetStartedError('Sign-in was cancelled'));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is CancelledFailure) {
      return 'Sign-in was cancelled';
    } else if (failure is AuthFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred';
  }
}
