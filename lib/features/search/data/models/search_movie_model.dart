import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

/// A movie or TV show entry coming from TMDB `search/multi`.
/// TV shows carry `name`/`first_air_date` instead of `title`/`release_date`.
class SearchMovieModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  /// `movie` or `tv` (from TMDB `media_type`).
  final String mediaType;

  const SearchMovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    this.genreIds = const [],
    this.mediaType = 'movie',
  });

  factory SearchMovieModel.fromJson(Map<String, dynamic> json) {
    return SearchMovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      genreIds: (json['genre_ids'] as List? ?? []).cast<int>(),
      mediaType: json['media_type']?.toString() ?? 'movie',
    );
  }

  Movie toEntity({String genre = ''}) {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      imageUrl: ApiEndpoints.imageUrl(posterPath ?? '', size: 'w500'),
      rating: voteAverage,
      releaseYear: releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '',
      genre: genre,
      genreIds: genreIds,
      mediaType: mediaType,
    );
  }
}