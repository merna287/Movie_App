import 'package:movie_app/features/search/data/models/search_actor_model.dart';
import 'package:movie_app/features/search/data/models/search_movie_model.dart';

/// Parsed `search/multi` response split by result type.
class SearchMultiModel {
  final List<SearchMovieModel> movies;
  final List<SearchActorModel> actors;

  /// Whether the first ranked result is a person.
  final bool topIsActor;

  const SearchMultiModel({
    required this.movies,
    required this.actors,
    required this.topIsActor,
  });
}