import 'package:get_it/get_it.dart';
import 'package:movie_app/features/auth/get_started/data/data_sources/facebook_auth_datasource.dart';
import 'package:movie_app/features/details/data/api/details_api.dart';
import 'package:movie_app/features/details/data/repositories/details_repository_impl.dart';
import 'package:movie_app/features/details/domain/repositories/details_repository.dart';
import 'package:movie_app/features/details/presentation/cubit/movie_details_cubit.dart';
import 'package:movie_app/features/home/data/api/home_api.dart';
import 'package:movie_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
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
import 'package:movie_app/features/auth/create_new_password/data/data_sources/create_new_password_data_source.dart';
import 'package:movie_app/features/auth/create_new_password/data/repositories/create_new_password_repository_impl.dart';
import 'package:movie_app/features/auth/create_new_password/domain/repositories/create_new_password_repository.dart';
import 'package:movie_app/features/auth/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:movie_app/features/favorite/data/api/favorite_api.dart';
import 'package:movie_app/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:movie_app/features/search/data/api/search_api.dart';
import 'package:movie_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_app/features/search/presentation/cubit/search_cubit.dart';

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
  getIt.registerLazySingleton<RegisterDataSource>(() => RegisterDataSource());
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(getIt<RegisterDataSource>()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<RegisterRepository>()),
  );
  getIt.registerLazySingleton<LoginDataSource>(() => LoginDataSource());
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(getIt<LoginDataSource>()),
  );
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepository>()));
  getIt.registerLazySingleton<ResetPasswordDataSource>(
    () => ResetPasswordDataSource(),
  );
  getIt.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepositoryImpl(getIt<ResetPasswordDataSource>()),
  );
  getIt.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(getIt<ResetPasswordRepository>()),
  );
  getIt.registerLazySingleton<CreateNewPasswordDataSource>(
    () => CreateNewPasswordDataSource(),
  );
  getIt.registerLazySingleton<CreateNewPasswordRepository>(
    () => CreateNewPasswordRepositoryImpl(getIt<CreateNewPasswordDataSource>()),
  );
  getIt.registerFactory<CreateNewPasswordCubit>(
    () => CreateNewPasswordCubit(getIt<CreateNewPasswordRepository>()),
  );
  getIt.registerLazySingleton<HomeApi>(() => HomeApi());
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeApi>()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepository>()));
  getIt.registerLazySingleton<DetailsApi>(() => DetailsApi());
  getIt.registerLazySingleton<DetailsRepository>(
    () => DetailsRepositoryImpl(getIt<DetailsApi>()),
  );
  getIt.registerFactory<MovieDetailsCubit>(
    () => MovieDetailsCubit(getIt<DetailsRepository>()),
  );
  getIt.registerLazySingleton<FavoriteApi>(() => FavoriteApi());
  getIt.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(getIt<FavoriteApi>()),
  );
  getIt.registerLazySingleton<FavoriteCubit>(
    () => FavoriteCubit(getIt<FavoriteRepository>()),
  );
  getIt.registerLazySingleton<SearchApi>(() => SearchApi());
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(getIt<SearchApi>()),
  );
  getIt.registerLazySingleton<SearchCubit>(
    () => SearchCubit(getIt<SearchRepository>()),
  );
}
