import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/details/data/api/details_api.dart';
import 'package:movie_app/features/details/domain/entities/movie_credits.dart';
import 'package:movie_app/features/details/domain/entities/movie_details.dart';
import 'package:movie_app/features/details/domain/entities/movie_video.dart';
import 'package:movie_app/features/details/domain/repositories/details_repository.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  final DetailsApi _api;

  DetailsRepositoryImpl(this._api);

  @override
  Future<AppResult<MovieDetails>> getMovieDetails(int movieId) async {
    final result = await _api.fetchMovieDetails(movieId);

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<AppResult<MovieCredits>> getMovieCredits(int movieId) async {
    final result = await _api.fetchMovieCredits(movieId);

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<AppResult<List<MovieVideo>>> getMovieVideos(int movieId) async {
    final result = await _api.fetchMovieVideos(movieId);

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }
}
