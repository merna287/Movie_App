import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/data/api/home_api.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';

class _MockHomeApi extends HomeApi {
  List<MovieModel> mockDiscoverMovies = [];

  @override
  Future<AppResult<List<MovieModel>>> fetchDiscoverMoviesByGenre({
    required int genreId,
    required String sortBy,
    int? minVoteCount,
  }) async {
    return Right(mockDiscoverMovies);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockHomeApi api;
  late HomeRepositoryImpl repository;

  final genres = [
    const Genre(id: 28, name: 'Action'),
    const Genre(id: 12, name: 'Adventure'),
    const Genre(id: 35, name: 'Comedy'),
  ];

  MovieModel model({
    required int id,
    required List<int> genreIds,
  }) =>
      MovieModel(
        id: id,
        title: 'Movie $id',
        overview: 'Overview',
        posterPath: '/path$id.jpg',
        voteAverage: 8.0,
        releaseDate: '2023-01-01',
        genreIds: genreIds,
      );

  setUp(() {
    api = _MockHomeApi();
    repository = HomeRepositoryImpl(api);
  });

  test('getMoviesByGenre filters out movies that do not contain genreId', () async {
    api.mockDiscoverMovies = [
      model(id: 1, genreIds: [28, 12]), // Has Action (28)
      model(id: 2, genreIds: [35]),     // Only Comedy, no Action!
      model(id: 3, genreIds: [28]),     // Has Action (28)
      model(id: 4, genreIds: []),       // Empty genres
    ];

    final result = await repository.getMoviesByGenre(
      genreId: 28,
      sortBy: 'popularity.desc',
      genres: genres,
    );

    expect(result.isRight(), isTrue);
    final movies = result.getRight().toNullable()!;
    expect(movies.map((m) => m.id), [1, 3]);
    expect(movies.every((m) => m.genreIds.contains(28)), isTrue);
    // Primary genre prefers selected category (Action) even if Adventure (12) is first in genreIds
    expect(movies.first.genre, 'Action');
  });
}
