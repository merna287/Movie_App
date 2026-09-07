import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/data/api/search_api.dart';
import 'package:movie_app/features/search/domain/entities/search_home_data.dart';
import 'package:movie_app/features/search/domain/entities/search_results.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchApi _api;

  List<Genre>? _cachedGenres;

  SearchRepositoryImpl(this._api);

  @override
  Future<AppResult<List<Movie>>> searchMovies(String query) async {
    final result = await _api.fetchSearchMovies(query);

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<AppResult<SearchResults>> searchAll(String query) async {
    final genres = await _cachedGenresOrEmpty();

    final result = await _api.fetchMultiSearch(query);

    return result.fold(
      (failure) => Left(failure),
      (model) {
        final movies = model.movies
            .map(
              (movie) => movie.toEntity(
                genre: _primaryGenre(movie.genreIds, genres),
              ),
            )
            .toList();

        final actors = model.actors
            .map(
              (actor) => actor.toEntity(
                (genreIds) => _primaryGenre(genreIds, genres),
              ),
            )
            .toList();

        debugPrint(
          'TMDB searchAll "$query": '
          '${movies.length} movies, ${actors.length} actors',
        );

        return Right(
          SearchResults(
            movies: movies,
            actors: actors,
            topIsActor: model.topIsActor,
          ),
        );
      },
    );
  }

  @override
  Future<AppResult<SearchHomeData>> getSearchHomeData() async {
    final genres = await _cachedGenresOrEmpty();

    final results = await Future.wait([
      _api.fetchNowPlayingMovies(),
      _api.fetchPopularMovies(),
    ]);

    final failed = results.indexWhere((result) => result.isLeft());
    if (failed != -1) {
      return Left(results[failed].getLeft().toNullable()!);
    }

    final nowPlayingModels = results[0].getRight().toNullable()!;
    final popularModels = results[1].getRight().toNullable()!;

    final todayMovies = nowPlayingModels
        .map((model) => model.toEntity(genre: _primaryGenre(model.genreIds, genres)))
        .toList();
    final recommended = popularModels
        .map((model) => model.toEntity(genre: _primaryGenre(model.genreIds, genres)))
        .toList();

    return Right(
      SearchHomeData(todayMovies: todayMovies, recommended: recommended),
    );
  }

  Future<List<Genre>> _cachedGenresOrEmpty() async {
    final cached = _cachedGenres;
    if (cached != null) return cached;

    final result = await _api.fetchMovieGenres();
    if (result.isLeft()) return const [];

    final genres = result
        .getRight()
        .toNullable()!
        .map((model) => model.toEntity())
        .toList();
    _cachedGenres = genres;
    return genres;
  }

  String _primaryGenre(List<int> genreIds, List<Genre> genres) {
    for (final id in genreIds) {
      for (final genre in genres) {
        if (genre.id == id) {
          return genre.name;
        }
      }
    }
    return '';
  }
}