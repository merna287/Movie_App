import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class FavoriteRepository {
  Future<AppResult<List<Movie>>> getFavoriteMovies(String accountId);

  Future<AppResult<bool>> removeFavorite({
    required String accountId,
    required int movieId,
  });
}
