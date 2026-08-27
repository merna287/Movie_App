import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:movie_app/features/auth/register/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _registerRepository;

  RegisterCubit(this._registerRepository) : super(const RegisterInitial());

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoading());

    final result = await _registerRepository.signUp(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(RegisterError(_mapFailureToMessage(failure)));
      },
      (user) {
        if (user != null) {
          emit(RegisterSuccess(user));
        } else {
          emit(RegisterError(LocaleKeys.registrationCancelled.tr()));
        }
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
