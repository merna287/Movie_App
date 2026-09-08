import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/search/data/models/search_movie_model.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';

class SearchActorModel {
  final int id;
  final String name;
  final String? profilePath;
  final List<SearchMovieModel> knownFor;

  const SearchActorModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownFor = const [],
  });

  factory SearchActorModel.fromJson(Map<String, dynamic> json) {
    final rawKnownFor = json['known_for'] as List? ?? [];

    return SearchActorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['original_name'] ?? '',
      profilePath: json['profile_path'],
      knownFor: rawKnownFor
          .whereType<Map<String, dynamic>>()
          .map(SearchMovieModel.fromJson)
          .toList(),
    );
  }

  Actor toEntity(String Function(List<int> genreIds) genreMapper) {
    return Actor(
      id: id,
      name: name,
      imageUrl: ApiEndpoints.imageUrl(profilePath ?? '', size: 'w185'),
      knownFor: knownFor
          .map((movie) => movie.toEntity(genre: genreMapper(movie.genreIds)))
          .toList(),
    );
  }
}