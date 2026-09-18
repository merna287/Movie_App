import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;
  final bool Function() _isAuthenticated;
  final String _accountId;
  final Set<int> _pendingIds = {};

  FavoriteCubit(
    this._repository, {
    bool Function()? isAuthenticated,
    String? accountId,
  })  : _isAuthenticated = isAuthenticated ?? _defaultAuthCheck,
        _accountId = accountId ?? ApiConfig.accountId,
        super(const FavoriteInitial());

  static bool _defaultAuthCheck() {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  List<Movie> get _visibleMovies => switch (state) {
        FavoriteLoaded(:final movies) => movies,
        FavoriteRemoving(:final movies) => movies,
        FavoriteToggling(:final movies) => movies,
        _ => const <Movie>[],
      };

  Future<void> load() async {
    if (_pendingIds.isNotEmpty) return;
    if (state is FavoriteLoading) return;

    if (_accountId.isEmpty) {
      debugPrint('TMDB account id not configured');
      emit(
        const FavoriteError(
          'TMDB account id is missing. Add it via --dart-define=TMDB_ACCOUNT_ID.',
        ),
      );
      return;
    }

    emit(const FavoriteLoading());

    final result = await _repository.getFavoriteMovies(_accountId);

    result.fold(
      (failure) => emit(FavoriteError(failureMessage(failure))),
      (movies) => emit(FavoriteLoaded(movies: movies)),
    );
  }

  bool isFavorite(int movieId) {
    final current = state;
    if (current is FavoriteLoaded ||
        current is FavoriteRemoving ||
        current is FavoriteToggling) {
      return current.movies.any((m) => m.id == movieId);
    }
    return false;
  }

  bool isPending(int movieId) => _pendingIds.contains(movieId);

  bool _hasLoadedFavorites() {
    return state is FavoriteLoaded ||
        state is FavoriteRemoving ||
        state is FavoriteToggling;
  }

  Future<bool> _ensureFavoritesLoaded() async {
    if (_hasLoadedFavorites()) {
      return true;
    }

    if (state is FavoriteLoading) {
      await stream.firstWhere((current) => current is! FavoriteLoading);
    } else {
      await load();
    }

    return _hasLoadedFavorites();
  }

  Future<void> toggleMovie(Movie movie) async {
    if (!_pendingIds.add(movie.id)) return;

    try {
      if (!_isAuthenticated()) {
        _emitMessage(LocaleKeys.signInRequired.tr());
        return;
      }

      if (_accountId.isEmpty) {
        emit(
          const FavoriteError(
            'TMDB account id is missing. Add it via --dart-define=TMDB_ACCOUNT_ID.',
          ),
        );
        return;
      }

      if (!_hasLoadedFavorites() && !await _ensureFavoritesLoaded()) return;

      final favorites = _visibleMovies;
      final isMovieFavorite = favorites.any((m) => m.id == movie.id);

      final optimistic = isMovieFavorite
          ? favorites.where((m) => m.id != movie.id).toList()
          : [...favorites, movie];
      emit(FavoriteToggling(movies: optimistic, pendingMovieId: movie.id));

      final result = isMovieFavorite
          ? await _repository.removeFavorite(
              accountId: _accountId,
              movieId: movie.id,
            )
          : await _repository.addFavorite(
              accountId: _accountId,
              movieId: movie.id,
            );

      result.fold(
        (failure) => emit(
          FavoriteLoaded(
            movies: favorites,
            errorMessage: failureMessage(failure),
          ),
        ),
        (success) => emit(FavoriteLoaded(movies: optimistic)),
      );
    } finally {
      _pendingIds.remove(movie.id);
    }
  }

  Future<void> removeMovie(int movieId) async {
    if (_pendingIds.contains(movieId)) return;

    if (!_isAuthenticated()) {
      _emitMessage(LocaleKeys.signInRequired.tr());
      return;
    }

    final current = state;
    if (current is! FavoriteLoaded) return;

    if (_accountId.isEmpty) {
      emit(
        const FavoriteError(
          'TMDB account id is missing. Add it via --dart-define=TMDB_ACCOUNT_ID.',
        ),
      );
      return;
    }

    final listBefore = current.movies;

    _pendingIds.add(movieId);
    emit(FavoriteRemoving(movies: listBefore));

    final result = await _repository.removeFavorite(
      accountId: _accountId,
      movieId: movieId,
    );

    _pendingIds.remove(movieId);

    result.fold(
      (failure) {
        final message = failureMessage(failure);
        emit(FavoriteLoaded(movies: listBefore, errorMessage: message));
      },
      (success) {
        emit(
          FavoriteLoaded(
            movies: listBefore.where((m) => m.id != movieId).toList(),
          ),
        );
      },
    );
  }

  void _emitMessage(String message) {
    emit(FavoriteLoaded(movies: _visibleMovies, errorMessage: message));
  }

  Movie? movieById(int movieId) {
    final current = state;
    if (current is FavoriteLoaded ||
        current is FavoriteRemoving ||
        current is FavoriteToggling) {
      return current.movies.where((m) => m.id == movieId).firstOrNull;
    }
    return null;
  }
}
