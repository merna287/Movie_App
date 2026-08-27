import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/auth/get_started/domain/repositories/auth_repository.dart';
import 'package:movie_app/features/auth/get_started/presentation/cubit/get_started_state.dart';

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
          emit(GetStartedError(LocaleKeys.signInCancelled.tr()));
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
          emit(GetStartedError(LocaleKeys.signInCancelled.tr()));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is CancelledFailure) {
      return LocaleKeys.signInCancelled.tr();
    } else if (failure is AuthFailure) {
      return failure.message;
    }
    return LocaleKeys.unexpectedError.tr();
  }
}
