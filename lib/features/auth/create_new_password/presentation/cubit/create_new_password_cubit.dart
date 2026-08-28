import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/auth/create_new_password/domain/repositories/create_new_password_repository.dart';
import 'package:movie_app/features/auth/create_new_password/presentation/cubit/create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final CreateNewPasswordRepository _repository;

  CreateNewPasswordCubit(this._repository)
      : super(const CreateNewPasswordInitial());

  Future<void> confirmNewPassword({
    required String code,
    required String newPassword,
  }) async {
    emit(const CreateNewPasswordLoading());

    final result = await _repository.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );

    result.fold(
      (failure) {
        emit(CreateNewPasswordError(_mapFailureToMessage(failure)));
      },
      (success) {
        emit(const CreateNewPasswordSuccess());
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
