import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';

class SearchResults {
  final List<Movie> movies;
  final List<Actor> actors;

  /// Whether the highest-ranked TMDB `search/multi` result is a person.
  /// Drives which result layout the Search screen shows.
  final bool topIsActor;

  const SearchResults({
    required this.movies,
    required this.actors,
    required this.topIsActor,
  });

  bool get isEmpty => movies.isEmpty && actors.isEmpty;
}