import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeInitial());

  Future<void> loadHomeData() async {
    if (ApiConfig.readAccessToken.isEmpty) {
      debugPrint('TMDB token configured: false');
      emit(const HomeError('TMDB token is missing. Add it to your .env file.'));
      return;
    }

    emit(const HomeLoading());

    final featuredResult = await _repository.getFeaturedMovies();
    if (featuredResult.isLeft()) {
      emit(
        HomeError(HomeCubit.failureMessage(featuredResult.getLeft().toNullable()!)),
      );
      return;
    }

    final genresResult = await _repository.getMovieGenres();
    if (genresResult.isLeft()) {
      emit(
        HomeError(HomeCubit.failureMessage(genresResult.getLeft().toNullable()!)),
      );
      return;
    }

    final featured = featuredResult.getRight().toNullable()!;
    final genres = genresResult.getRight().toNullable()!;

    final popularResult = await _repository.getPopularMovies(genres);

    popularResult.fold(
      (failure) {
        emit(HomeError(HomeCubit.failureMessage(failure)));
      },
      (popular) {
        debugPrint(
          'TMDB: ${featured.length} featured, ${genres.length} genres, '
          '${popular.length} popular movies loaded',
        );
        emit(
          HomeSuccess(movies: featured, genres: genres, popularMovies: popular),
        );
      },
    );
  }

  static String failureMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return LocaleKeys.noInternetConnection.tr();
    }
    if (failure is ServerFailure) {
      final statusCode = failure.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return 'TMDB authentication failed. Check your API token.';
      }
      if (statusCode != null) {
        return 'TMDB request failed (HTTP $statusCode).';
      }
      return failure.serverMessage ?? LocaleKeys.unexpectedError.tr();
    }
    if (failure is ParsingFailure) {
      return 'Failed to parse TMDB response.';
    }
    return LocaleKeys.unexpectedError.tr();
  }
}
