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
