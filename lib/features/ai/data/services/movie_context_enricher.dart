import 'package:movie_app/features/details/domain/entities/movie_credits.dart';
import 'package:movie_app/features/details/domain/entities/movie_details.dart';
import 'package:movie_app/features/details/domain/repositories/details_repository.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';

/// Enriches Gemini prompts with TMDB movie data when the user asks about a movie.
class MovieContextEnricher {
  final SearchRepository _searchRepository;
  final DetailsRepository _detailsRepository;

  MovieContextEnricher(
    this._searchRepository,
    this._detailsRepository,
  );

  Future<String> enrichInput(String userMessage) async {
    final context = await _buildMovieContext(userMessage);
    if (context == null || context.isEmpty) return userMessage;
    return '$userMessage\n\n---\nTMDB Movie Context (use when relevant):\n$context';
  }

  Future<String?> _buildMovieContext(String userMessage) async {
    final query = userMessage.trim();
    if (query.length < 3) return null;

    final searchResult = await _searchRepository.searchMovies(query);
    final movies = searchResult.fold((_) => const <Movie>[], (list) => list);
    if (movies.isEmpty) return null;

    final match = _pickRelevantMovie(query, movies);
    if (match == null) return null;

    final detailsResult = await _detailsRepository.getMovieDetails(match.id);
    final creditsResult = await _detailsRepository.getMovieCredits(match.id);

    MovieDetails? details;
    MovieCredits? credits;

    detailsResult.fold((_) {}, (value) => details = value);
    creditsResult.fold((_) {}, (value) => credits = value);

    return _formatContext(
      movie: match,
      details: details,
      credits: credits,
    );
  }

  Movie? _pickRelevantMovie(String query, List<Movie> movies) {
    final normalizedQuery = query.toLowerCase();

    for (final movie in movies.take(5)) {
      final title = movie.title.toLowerCase();
      if (normalizedQuery.contains(title) || title.contains(normalizedQuery)) {
        return movie;
      }
    }

    final asksAboutMovie = RegExp(
      r'\b(about|explain|describe|who directed|director of|cast of|'
      r'starring|similar to|compare|rating of|review of|plot of|story of)\b',
      caseSensitive: false,
    ).hasMatch(query);

    if (!asksAboutMovie) return null;

    for (final movie in movies.take(3)) {
      final words = movie.title
          .toLowerCase()
          .split(RegExp(r'\s+'))
          .where((word) => word.length > 3);
      if (words.any(normalizedQuery.contains)) return movie;
    }

    return null;
  }

  String _formatContext({
    required Movie movie,
    MovieDetails? details,
    MovieCredits? credits,
  }) {
    final buffer = StringBuffer()
      ..writeln('- Movie ID: ${movie.id}')
      ..writeln('- Title: ${details?.title ?? movie.title}')
      ..writeln('- Overview: ${details?.overview ?? movie.overview}')
      ..writeln('- Genres: ${details?.genre ?? movie.genre}')
      ..writeln('- Rating: ${(details?.rating ?? movie.rating).toStringAsFixed(1)}/10')
      ..writeln('- Release year: ${details?.releaseYear ?? movie.releaseYear}');

    final runtime = details?.runtimeMinutes;
    if (runtime != null && runtime > 0) {
      buffer.writeln('- Runtime: $runtime minutes');
    }

    if (credits != null) {
      final cast = credits.cast
          .take(5)
          .map((member) => '${member.name} as ${member.character}')
          .join(', ');
      if (cast.isNotEmpty) buffer.writeln('- Cast: $cast');

      final directors = credits.crew
          .where((member) => member.job.toLowerCase() == 'director')
          .take(3)
          .map((member) => member.name)
          .join(', ');
      if (directors.isNotEmpty) buffer.writeln('- Director(s): $directors');
    }

    return buffer.toString().trim();
  }
}
