import 'package:movie_app/features/home/domain/entities/movie.dart';

sealed class FavoriteState {
  const FavoriteState();

  List<Movie> get movies => const [];
}

final class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

final class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

final class FavoriteLoaded extends FavoriteState {
  @override
  final List<Movie> movies;

  final String? errorMessage;

  const FavoriteLoaded({required this.movies, this.errorMessage});
}

final class FavoriteRemoving extends FavoriteState {
  @override
  final List<Movie> movies;

  const FavoriteRemoving({required this.movies});
}

final class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);
}