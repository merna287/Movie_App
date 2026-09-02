import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/entities/movie_credits.dart';
import 'package:movie_app/features/home/domain/entities/movie_details.dart';
import 'package:movie_app/features/home/domain/entities/movie_video.dart';

abstract class HomeRepository {
  Future<AppResult<List<Movie>>> getFeaturedMovies();
  Future<AppResult<List<Genre>>> getMovieGenres();
  Future<AppResult<List<Movie>>> getPopularMovies(List<Genre> genres);
  Future<AppResult<List<Movie>>> getTopRatedMovies(List<Genre> genres);
  Future<AppResult<List<Movie>>> getTrendingMovies(List<Genre> genres);
  Future<AppResult<List<Movie>>> getMoviesByGenre({
    required int genreId,
    required String sortBy,
    int? minVoteCount,
    required List<Genre> genres,
  });
  Future<AppResult<MovieDetails>> getMovieDetails(int movieId);
  Future<AppResult<MovieCredits>> getMovieCredits(int movieId);
  Future<AppResult<List<MovieVideo>>> getMovieVideos(int movieId);
}
