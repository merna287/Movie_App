import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/data/api/home_api.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApi _api;

  HomeRepositoryImpl(this._api);

  @override
  Future<AppResult<List<Movie>>> getFeaturedMovies() async {
    final result = await _api.fetchDiscoverMovies();

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<AppResult<List<Genre>>> getMovieGenres() async {
    final result = await _api.fetchMovieGenres();

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<AppResult<List<Movie>>> getPopularMovies(List<Genre> genres) async {
    final result = await _api.fetchPopularMovies();
    return _mapMovieResult(result, genres);
  }

  @override
  Future<AppResult<List<Movie>>> getTopRatedMovies(List<Genre> genres) async {
    final result = await _api.fetchTopRatedMovies();
    return _mapMovieResult(result, genres);
  }

  @override
  Future<AppResult<List<Movie>>> getTrendingMovies(List<Genre> genres) async {
    final result = await _api.fetchTrendingMovies();
    return _mapMovieResult(result, genres);
  }

  @override
  Future<AppResult<List<Movie>>> getMoviesByGenre({
    required int genreId,
    required String sortBy,
    int? minVoteCount,
    required List<Genre> genres,
  }) async {
    final result = await _api.fetchDiscoverMoviesByGenre(
      genreId: genreId,
      sortBy: sortBy,
      minVoteCount: minVoteCount,
    );
    return _mapMovieResult(result, genres);
  }

  AppResult<List<Movie>> _mapMovieResult(
    AppResult<List<MovieModel>> result,
    List<Genre> genres,
  ) {
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(
        models
            .map((model) => model.toEntity(genre: _primaryGenre(model, genres)))
            .toList(),
      ),
    );
  }

  String _primaryGenre(MovieModel model, List<Genre> genres) {
    for (final id in model.genreIds) {
      for (final genre in genres) {
        if (genre.id == id) {
          return genre.name;
        }
      }
    }
    return '';
  }
}
