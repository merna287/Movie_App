import 'package:get_it/get_it.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/facebook_auth_datasource.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/google_auth_datasource.dart';
import 'package:movie_app/features/auth/get_started/data/repositories/auth_repository_impl.dart';
import 'package:movie_app/features/auth/get_started/domain/repositories/auth_repository.dart';
import 'package:movie_app/features/auth/get_started/presentation/cubit/get_started_cubit.dart';

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
}
