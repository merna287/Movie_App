import 'package:movie_app/features/details/domain/entities/movie_video.dart';

class MovieVideoModel {
  final String key;
  final String site;
  final String type;
  final String name;

  const MovieVideoModel({
    required this.key,
    this.site = '',
    this.type = '',
    this.name = '',
  });

  factory MovieVideoModel.fromJson(Map<String, dynamic> json) {
    return MovieVideoModel(
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
    );
  }

  MovieVideo toEntity() =>
      MovieVideo(key: key, site: site, type: type, name: name);
}
