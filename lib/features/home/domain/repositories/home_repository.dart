import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class HomeRepository {
  Future<AppResult<List<Movie>>> getFeaturedMovies();
}
