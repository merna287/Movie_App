class Movie {
  final int id;
  final String title;
  final String overview;
  final String imageUrl;
  final double rating;
  final String releaseYear;
  final String genre;
  final List<int> genreIds;

  /// `movie` or `tv` (used by search results to render the Movie/Series type).
  final String mediaType;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.imageUrl,
    required this.rating,
    required this.releaseYear,
    this.genre = '',
    this.genreIds = const [],
    this.mediaType = 'movie',
  });

  Movie copyWith({
    String? title,
    String? imageUrl,
    double? rating,
    String? releaseYear,
    String? genre,
    List<int>? genreIds,
    String? mediaType,
  }) {
    return Movie(
      id: id,
      title: title ?? this.title,
      overview: overview,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      releaseYear: releaseYear ?? this.releaseYear,
      genre: genre ?? this.genre,
      genreIds: genreIds ?? this.genreIds,
      mediaType: mediaType ?? this.mediaType,
    );
  }
}
