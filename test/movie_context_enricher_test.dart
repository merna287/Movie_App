import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/ai/data/services/movie_context_enricher.dart';
import 'package:movie_app/features/details/domain/entities/cast_member.dart';
import 'package:movie_app/features/details/domain/entities/crew_member.dart';
import 'package:movie_app/features/details/domain/entities/movie_credits.dart';
import 'package:movie_app/features/details/domain/entities/movie_details.dart';
import 'package:movie_app/features/details/domain/repositories/details_repository.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/details/domain/entities/movie_video.dart';
import 'package:movie_app/features/search/domain/entities/search_home_data.dart';
import 'package:movie_app/features/search/domain/entities/search_results.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';

class _FakeSearchRepository implements SearchRepository {
  List<Movie> movies = const [];

  @override
  Future<AppResult<List<Movie>>> searchMovies(String query) async =>
      Right(movies);

  @override
  Future<AppResult<SearchResults>> searchAll(String query) async =>
      throw UnimplementedError();

  @override
  Future<AppResult<SearchHomeData>> getSearchHomeData() async =>
      throw UnimplementedError();
}

class _FakeDetailsRepository implements DetailsRepository {
  MovieDetails? details;
  MovieCredits? credits;

  @override
  Future<AppResult<MovieDetails>> getMovieDetails(int movieId) async =>
      Right(details!);

  @override
  Future<AppResult<MovieCredits>> getMovieCredits(int movieId) async =>
      Right(credits!);

  @override
  Future<AppResult<List<MovieVideo>>> getMovieVideos(int movieId) async =>
      throw UnimplementedError();
}

void main() {
  late _FakeSearchRepository searchRepository;
  late _FakeDetailsRepository detailsRepository;
  late MovieContextEnricher enricher;

  setUp(() {
    searchRepository = _FakeSearchRepository();
    detailsRepository = _FakeDetailsRepository();
    enricher = MovieContextEnricher(searchRepository, detailsRepository);
  });

  test('does not enrich generic recommendation requests', () async {
    searchRepository.movies = [
      const Movie(
        id: 1,
        title: 'Random Action Movie',
        overview: 'Overview',
        imageUrl: '',
        rating: 7.5,
        releaseYear: '2020',
        genre: 'Action',
      ),
    ];

    final result = await enricher.enrichInput('Recommend me an action movie');

    expect(result, 'Recommend me an action movie');
  });

  test('enriches when the user asks about a specific movie title', () async {
    searchRepository.movies = [
      const Movie(
        id: 550,
        title: 'Fight Club',
        overview: 'An insomniac office worker.',
        imageUrl: '',
        rating: 8.4,
        releaseYear: '1999',
        genre: 'Drama',
      ),
    ];
    detailsRepository.details = const MovieDetails(
      id: 550,
      title: 'Fight Club',
      overview: 'An insomniac office worker.',
      imageUrl: '',
      rating: 8.4,
      releaseYear: '1999',
      genre: 'Drama',
      runtimeMinutes: 139,
    );
    detailsRepository.credits = const MovieCredits(
      cast: [
        CastMember(
          id: 1,
          name: 'Brad Pitt',
          character: 'Tyler Durden',
          imageUrl: '',
        ),
      ],
      crew: [
        CrewMember(
          id: 2,
          name: 'David Fincher',
          job: 'Director',
          imageUrl: '',
        ),
      ],
    );

    final result = await enricher.enrichInput('Tell me about Fight Club');

    expect(result, contains('TMDB Movie Context'));
    expect(result, contains('Fight Club'));
    expect(result, contains('David Fincher'));
    expect(result, contains('Brad Pitt'));
  });
}
