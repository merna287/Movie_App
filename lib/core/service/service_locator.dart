import 'package:get_it/get_it.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/facebook_auth_datasource.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/google_auth_datasource.dart';
import 'package:movie_app/features/auth/get_started/data/repositories/auth_repository_impl.dart';
import 'package:movie_app/features/auth/get_started/domain/repositories/auth_repository.dart';
import 'package:movie_app/features/auth/get_started/presentation/cubit/get_started_cubit.dart';
import 'package:movie_app/features/auth/login/data/data_sources/login_data_source.dart';
import 'package:movie_app/features/auth/login/data/repositories/login_repository_impl.dart';
import 'package:movie_app/features/auth/login/domain/repositories/login_repository.dart';
import 'package:movie_app/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:movie_app/features/auth/register/data/data_sources/register_data_source.dart';
import 'package:movie_app/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:movie_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:movie_app/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:movie_app/features/auth/reset_password/data/data_sources/reset_password_data_source.dart';
import 'package:movie_app/features/auth/reset_password/data/repositories/reset_password_repository_impl.dart';
import 'package:movie_app/features/auth/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:movie_app/features/auth/reset_password/presentation/cubit/reset_password_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<GoogleAuthDataSource>(
    () => GoogleAuthDataSource(),
  );
  getIt.registerLazySingleton<FacebookAuthDataSource>(
    () => FacebookAuthDataSource(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<GoogleAuthDataSource>(),
      getIt<FacebookAuthDataSource>(),
    ),
  );
  getIt.registerFactory<GetStartedCubit>(
    () => GetStartedCubit(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterDataSource>(
    () => RegisterDataSource(),
  );
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(getIt<RegisterDataSource>()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<RegisterRepository>()),
  );
  getIt.registerLazySingleton<LoginDataSource>(
    () => LoginDataSource(),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(getIt<LoginDataSource>()),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordDataSource>(
    () => ResetPasswordDataSource(),
  );
  getIt.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepositoryImpl(getIt<ResetPasswordDataSource>()),
  );
  getIt.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(getIt<ResetPasswordRepository>()),
  );
}
