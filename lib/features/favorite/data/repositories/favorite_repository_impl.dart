import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/favorite/data/api/favorite_api.dart';
import 'package:movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteApi _api;

  FavoriteRepositoryImpl(this._api);

  @override
  Future<AppResult<List<Movie>>> getFavoriteMovies(String accountId) async {
    final result = await _api.fetchFavoriteMovies(accountId);

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<AppResult<bool>> removeFavorite({
    required String accountId,
    required int movieId,
  }) async {
    return _api.removeFavoriteMovie(accountId: accountId, movieId: movieId);
  }
}