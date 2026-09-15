import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  static const String _mostPopularSort = 'popularity.desc';
  static const String _topRatedSort = 'vote_average.desc';
  static const int _topRatedMinVoteCount = 200;

  final Map<int, _GenreMovies> _genreCache = {};

  HomeCubit(this._repository) : super(const HomeInitial());

  bool _isLoadingHomeData = false;

  Future<void> loadHomeData({bool force = false}) async {
    if (!force) {
      if (state is HomeSuccess) return;
      if (_isLoadingHomeData) return;
    }

    if (ApiConfig.readAccessToken.isEmpty) {
      debugPrint('TMDB token configured: false');
      emit(const HomeError('TMDB token is missing. Add it to your .env file.'));
      return;
    }

    _isLoadingHomeData = true;
    if (state is! HomeSuccess) {
      emit(const HomeLoading());
    }

    final featuredResult = await _repository.getFeaturedMovies();
    if (featuredResult.isLeft()) {
      _isLoadingHomeData = false;
      emit(HomeError(failureMessage(featuredResult.getLeft().toNullable()!)));
      return;
    }

    final genresResult = await _repository.getMovieGenres();
    if (genresResult.isLeft()) {
      _isLoadingHomeData = false;
      emit(HomeError(failureMessage(genresResult.getLeft().toNullable()!)));
      return;
    }

    final featured = featuredResult.getRight().toNullable()!;
    final genres = genresResult.getRight().toNullable()!;

    final popularResult = await _repository.getPopularMovies(genres);
    if (popularResult.isLeft()) {
      _isLoadingHomeData = false;
      emit(HomeError(failureMessage(popularResult.getLeft().toNullable()!)));
      return;
    }

    final topRatedResult = await _repository.getTopRatedMovies(genres);
    if (topRatedResult.isLeft()) {
      _isLoadingHomeData = false;
      emit(HomeError(failureMessage(topRatedResult.getLeft().toNullable()!)));
      return;
    }

    final trendingResult = await _repository.getTrendingMovies(genres);
    if (trendingResult.isLeft()) {
      _isLoadingHomeData = false;
      emit(HomeError(failureMessage(trendingResult.getLeft().toNullable()!)));
      return;
    }

    final popular = popularResult.getRight().toNullable()!;
    final topRated = topRatedResult.getRight().toNullable()!;
    final trending = trendingResult.getRight().toNullable()!;

    debugPrint(
      'TMDB: ${featured.length} featured, ${genres.length} genres, '
      '${popular.length} popular, ${topRated.length} top rated, '
      '${trending.length} trending movies loaded',
    );
    _isLoadingHomeData = false;
    emit(
      HomeSuccess(
        movies: featured,
        genres: genres,
        popularMovies: popular,
        topRatedMovies: topRated,
        trendingMovies: trending,
      ),
    );
  }

  Future<void> selectGenre(int? genreId) async {
    final current = state;
    if (current is! HomeSuccess) return;

    // Same genre is already selected (either showing data or still loading);
    // do not re-request or duplicate in-flight requests.
    if (current.selectedGenreId == genreId) return;

    // All: no API request, restore the original data.
    if (genreId == null) {
      if (current.selectedGenreId == null) return;
      emit(current.copyWith(clearSelectedGenreId: true, isGenreLoading: false));
      return;
    }

    // Reuse cached genre data when available.
    final cached = _genreCache[genreId];
    if (cached != null) {
      emit(
        current.copyWith(
          selectedGenreId: genreId,
          isGenreLoading: false,
          filteredPopularMovies: cached.popular,
          filteredTopRatedMovies: cached.topRated,
          filteredTrendingMovies: cached.trending,
        ),
      );
      return;
    }

    // Filter immediately from loaded movies using their genreIds, then fetch
    // the full genre-specific lists from the API in the background.
    emit(
      current.copyWith(
        selectedGenreId: genreId,
        isGenreLoading: true,
        filteredPopularMovies: _filterMoviesByGenre(current.popularMovies, genreId),
        filteredTopRatedMovies:
            _filterMoviesByGenre(current.topRatedMovies, genreId),
        filteredTrendingMovies:
            _filterMoviesByGenre(current.trendingMovies, genreId),
      ),
    );

    final genres = current.genres;

    // Popular and Top Rated are independent Discover queries: run them
    // concurrently so the total wait is roughly a single round trip instead of
    // two sequential ones. Trending cannot be genre-filtered on the TMDB API,
    // so it reuses the exact popularity-desc Discover query already fetched
    // for Most Popular (its closest correct approximation) instead of issuing
    // a duplicate request for the same data.
    final results = await Future.wait([
      _repository.getMoviesByGenre(
        genreId: genreId,
        sortBy: _mostPopularSort,
        genres: genres,
      ),
      _repository.getMoviesByGenre(
        genreId: genreId,
        sortBy: _topRatedSort,
        minVoteCount: _topRatedMinVoteCount,
        genres: genres,
      ),
    ]);

    final failedIndex = results.indexWhere((result) => result.isLeft());
    if (failedIndex != -1) {
      emit(
        HomeError(failureMessage(results[failedIndex].getLeft().toNullable()!)),
      );
      return;
    }

    final popularMovies = results[0].getRight().toNullable()!;
    final topRatedMovies = results[1].getRight().toNullable()!;

    // Cache even if the user already moved to another category, so revisiting
    // this genre is instant.
    _genreCache[genreId] = _GenreMovies(
      popular: popularMovies,
      topRated: topRatedMovies,
      trending: popularMovies,
    );

    // A newer selection may have replaced this one while the requests were in
    // flight; do not overwrite it with stale data.
    final latest = state;
    if (latest is! HomeSuccess || latest.selectedGenreId != genreId) return;

    emit(
      current.copyWith(
        selectedGenreId: genreId,
        isGenreLoading: false,
        filteredPopularMovies: popularMovies,
        filteredTopRatedMovies: topRatedMovies,
        filteredTrendingMovies: popularMovies,
      ),
    );
  }

  List<Movie> _filterMoviesByGenre(List<Movie> movies, int genreId) {
    return movies.where((movie) => movie.genreIds.contains(genreId)).toList();
  }
}

class _GenreMovies {
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<Movie> trending;

  const _GenreMovies({
    required this.popular,
    required this.topRated,
    required this.trending,
  });
}
