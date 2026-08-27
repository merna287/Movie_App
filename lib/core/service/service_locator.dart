import 'package:get_it/get_it.dart';
import 'package:movie_app/features/auth/data/api/facebook_auth_datasource.dart';
import 'package:movie_app/features/auth/data/api/google_auth_datasource.dart';
import 'package:movie_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/features/auth/presentation/get_started/cubit/get_started_cubit.dart';

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
