import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/auth/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:movie_app/features/auth/reset_password/presentation/cubit/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository _repository;

  ResetPasswordCubit(this._repository) : super(const ResetPasswordInitial());

  Future<void> sendResetPasswordEmail({
    required String email,
  }) async {
    emit(const ResetPasswordLoading());

    final result = await _repository.sendPasswordResetEmail(email: email);

    result.fold(
      (failure) {
        emit(ResetPasswordError(_mapFailureToMessage(failure)));
      },
      (success) {
        emit(const ResetPasswordSuccess());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return LocaleKeys.noInternetConnection.tr();
    }
    return LocaleKeys.unexpectedError.tr();
  }
}
