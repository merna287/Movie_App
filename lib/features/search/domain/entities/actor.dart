import 'package:movie_app/features/home/domain/entities/movie.dart';

class Actor {
  final int id;
  final String name;
  final String imageUrl;

  /// Movies the actor is famous for (TMDB `known_for`).
  final List<Movie> knownFor;

  const Actor({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.knownFor = const [],
  });
}