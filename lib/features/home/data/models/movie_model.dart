import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/core/network/api_endpoints.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.genreIds = const [],
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: (json['genre_ids'] as List? ?? []).cast<int>(),
    );
  }

  Movie toEntity({String genre = ''}) {
    final imagePath = backdropPath ?? posterPath;

    return Movie(
      id: id,
      title: title,
      overview: overview,
      imageUrl: ApiEndpoints.imageUrl(imagePath ?? '', size: 'w780'),
      rating: voteAverage,
      releaseYear: releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '',
      genre: genre,
    );
  }
}
