import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';

sealed class SearchState {
  const SearchState();
}

/// Empty query — initial Search screen with "Today" and "Recommend for you".
final class SearchIdle extends SearchState {
  final bool loading;
  final List<Movie> todayMovies;
  final List<Movie> recommended;

  const SearchIdle({
    this.loading = false,
    this.todayMovies = const [],
    this.recommended = const [],
  });
}

final class SearchLoading extends SearchState {
  final String query;

  const SearchLoading({this.query = ''});
}

/// Query matched movies/tv shows (movie result screen).
final class SearchMovieResults extends SearchState {
  final String query;
  final List<Movie> movies;

  const SearchMovieResults({required this.query, required this.movies});
}

/// Query matched actors — "Actors" section + "Movie Related" list.
final class SearchActorResults extends SearchState {
  final String query;
  final List<Actor> actors;
  final List<Movie> movies;

  const SearchActorResults({
    required this.query,
    required this.actors,
    required this.movies,
  });
}

final class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty({required this.query});
}

final class SearchError extends SearchState {
  final String message;
  final String query;

  const SearchError({required this.message, required this.query});
}