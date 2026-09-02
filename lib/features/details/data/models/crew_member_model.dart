import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/details/domain/entities/crew_member.dart';

class CrewMemberModel {
  final int id;
  final String name;
  final String job;
  final String? profilePath;

  const CrewMemberModel({
    required this.id,
    required this.name,
    required this.job,
    this.profilePath,
  });

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) {
    return CrewMemberModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      profilePath: json['profile_path'],
    );
  }

  CrewMember toEntity() {
    return CrewMember(
      id: id,
      name: name,
      job: job,
      imageUrl: ApiEndpoints.imageUrl(profilePath ?? ''),
    );
  }
}
