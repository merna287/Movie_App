import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/auth/login/domain/repositories/login_repository.dart';
import 'package:movie_app/features/auth/login/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;

  LoginCubit(this._loginRepository) : super(const LoginInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _loginRepository.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(LoginError(_mapFailureToMessage(failure)));
      },
      (user) {
        if (user != null) {
          emit(LoginSuccess(user));
        } else {
          emit(LoginError(LocaleKeys.signInCancelled.tr()));
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
