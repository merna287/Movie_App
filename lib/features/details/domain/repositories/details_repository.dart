import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/details/domain/entities/movie_credits.dart';
import 'package:movie_app/features/details/domain/entities/movie_details.dart';
import 'package:movie_app/features/details/domain/entities/movie_video.dart';

abstract class DetailsRepository {
  Future<AppResult<MovieDetails>> getMovieDetails(int movieId);
  Future<AppResult<MovieCredits>> getMovieCredits(int movieId);
  Future<AppResult<List<MovieVideo>>> getMovieVideos(int movieId);
}
