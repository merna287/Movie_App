class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String imageUrl;
  final double rating;
  final String releaseYear;
  final String genre;
  final int? runtimeMinutes;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.imageUrl,
    required this.rating,
    required this.releaseYear,
    this.genre = '',
    this.runtimeMinutes,
  });
}
