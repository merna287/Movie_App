import 'package:movie_app/features/details/data/models/cast_member_model.dart';
import 'package:movie_app/features/details/data/models/crew_member_model.dart';
import 'package:movie_app/features/details/domain/entities/movie_credits.dart';

class MovieCreditsModel {
  final List<CastMemberModel> cast;
  final List<CrewMemberModel> crew;

  const MovieCreditsModel({required this.cast, required this.crew});

  factory MovieCreditsModel.fromJson(Map<String, dynamic> json) {
    return MovieCreditsModel(
      cast: (json['cast'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CastMemberModel.fromJson)
          .toList(),
      crew: (json['crew'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CrewMemberModel.fromJson)
          .toList(),
    );
  }

  MovieCredits toEntity() {
    return MovieCredits(
      cast: cast.map((member) => member.toEntity()).toList(),
      crew: crew.map((member) => member.toEntity()).toList(),
    );
  }
}
