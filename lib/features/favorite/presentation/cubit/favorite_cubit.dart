import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteCubit(this._repository) : super(const FavoriteInitial());

  Future<void> load() async {
    final accountId = ApiConfig.accountId;

    if (accountId.isEmpty) {
      debugPrint('TMDB account id not configured');
      emit(
        const FavoriteError(
          'TMDB account id is missing. Add it via --dart-define=TMDB_ACCOUNT_ID.',
        ),
      );
      return;
    }

    emit(const FavoriteLoading());

    final result = await _repository.getFavoriteMovies(accountId);

    result.fold(
      (failure) => emit(FavoriteError(failureMessage(failure))),
      (movies) => emit(FavoriteLoaded(movies: movies)),
    );
  }

  Future<void> removeMovie(int movieId) async {
    final current = state;
    if (current is! FavoriteLoaded) return;

    final accountId = ApiConfig.accountId;
    final listBefore = current.movies;

    // Keep the list visible while the request is in flight. The heart button
    // is disabled during removal, and the removed movie is dropped only after
    // the API call succeeds.
    emit(FavoriteRemoving(movies: listBefore));

    final result = await _repository.removeFavorite(
      accountId: accountId,
      movieId: movieId,
    );

    result.fold(
      (failure) {
        final message = failureMessage(failure);
        // Failure keeps the current list intact; re-emit the loaded list so the
        // UI can react and the screen can surface the error message.
        emit(FavoriteLoaded(movies: listBefore, errorMessage: message));
      },
      (success) {
        emit(FavoriteLoaded(movies: listBefore.where((m) => m.id != movieId).toList()));
      },
    );
  }

  Movie? movieById(int movieId) {
    final current = state;
    if (current is FavoriteLoaded || current is FavoriteRemoving) {
      return current.movies.where((m) => m.id == movieId).firstOrNull;
    }
    return null;
  }
}