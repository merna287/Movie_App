import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/data/api/home_api.dart';
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
}
