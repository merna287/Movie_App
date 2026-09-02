import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/home/domain/entities/cast_member.dart';

class CastMemberModel {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const CastMemberModel({
    required this.id,
    required this.name,
    this.character = '',
    this.profilePath,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
    );
  }

  CastMember toEntity() {
    return CastMember(
      id: id,
      name: name,
      character: character,
      imageUrl: ApiEndpoints.imageUrl(profilePath ?? ''),
    );
  }
}
