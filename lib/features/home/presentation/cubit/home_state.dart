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

  const HomeSuccess(this.movies);
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
