import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  final List<Movie> movies;
  final List<Genre> genres;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> trendingMovies;

  const HomeSuccess({
    required this.movies,
    required this.genres,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.trendingMovies,
  });
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
