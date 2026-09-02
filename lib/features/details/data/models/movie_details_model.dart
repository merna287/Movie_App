import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/home/domain/entities/movie_details.dart';

class MovieDetailsModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final int? runtimeMinutes;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.genres = const [],
    this.runtimeMinutes,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawGenres = json['genres'] as List? ?? [];

    return MovieDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: rawGenres
          .whereType<Map<String, dynamic>>()
          .map((genre) => genre['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
      runtimeMinutes: (json['runtime'] as num?)?.toInt(),
    );
  }

  MovieDetails toEntity() {
    final imagePath = backdropPath ?? posterPath;

    return MovieDetails(
      id: id,
      title: title,
      overview: overview,
      imageUrl: ApiEndpoints.imageUrl(imagePath ?? '', size: 'w780'),
      rating: voteAverage,
      releaseYear: releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '',
      genre: genres.firstOrNull ?? '',
      runtimeMinutes: runtimeMinutes,
    );
  }
}
