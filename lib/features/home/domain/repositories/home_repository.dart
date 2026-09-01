import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

abstract class HomeRepository {
  Future<AppResult<List<Movie>>> getFeaturedMovies();
  Future<AppResult<List<Genre>>> getMovieGenres();
  Future<AppResult<List<Movie>>> getPopularMovies(List<Genre> genres);
  Future<AppResult<List<Movie>>> getTopRatedMovies(List<Genre> genres);
  Future<AppResult<List<Movie>>> getTrendingMovies(List<Genre> genres);
}
