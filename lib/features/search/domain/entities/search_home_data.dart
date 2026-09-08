import 'package:movie_app/features/home/domain/entities/movie.dart';

/// Data shown on the initial Search screen (empty query):
/// a "Today" spotlight movie and a "Recommend for you" horizontal list.
class SearchHomeData {
  final List<Movie> todayMovies;
  final List<Movie> recommended;

  const SearchHomeData({
    required this.todayMovies,
    required this.recommended,
  });
}