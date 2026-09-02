import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/domain/entities/movie_credits.dart';
import 'package:movie_app/features/home/domain/entities/movie_details.dart';
import 'package:movie_app/features/home/domain/entities/movie_video.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';

class _FakeHomeRepository implements HomeRepository {
  final genreMovies = <int, Map<String, List<Movie>>>{};
  final getMoviesByGenreCalls = <(int, String, int?)>[];
  final _callCountById = <int, int>{};

  Completer<void>? gate;
  int? gateGenreId;

  @override
  Future<AppResult<List<Movie>>> getFeaturedMovies() async => Right(_movies);

  @override
  Future<AppResult<List<Genre>>> getMovieGenres() async => Right(_genres);

  @override
  Future<AppResult<List<Movie>>> getPopularMovies(List<Genre> genres) async =>
      Right(_popular);

  @override
  Future<AppResult<List<Movie>>> getTopRatedMovies(List<Genre> genres) async =>
      Right(_topRated);

  @override
  Future<AppResult<List<Movie>>> getTrendingMovies(List<Genre> genres) async =>
      Right(_trending);

  @override
  Future<AppResult<List<Movie>>> getMoviesByGenre({
    required int genreId,
    required String sortBy,
    int? minVoteCount,
    required List<Genre> genres,
  }) async {
    getMoviesByGenreCalls.add((genreId, sortBy, minVoteCount));
    final gate = this.gate;
    final holds =
        gate != null && (gateGenreId == null || gateGenreId == genreId);
    if (holds) await gate.future;
    final callIndex = _callCountById[genreId] ?? 0;
    _callCountById[genreId] = callIndex + 1;

    final data = genreMovies[genreId];
    if (data == null) return Right(const []);

    // Cubit makes only two requests per genre: popular, then topRated.
    // Trending reuses the popular result.
    switch (callIndex) {
      case 0:
        return Right(data['popular'] ?? const []);
      default:
        return Right(data['topRated'] ?? const []);
    }
  }

  @override
  Future<AppResult<MovieDetails>> getMovieDetails(int movieId) async => Right(
    MovieDetails(
      id: movieId,
      title: 'Movie $movieId',
      overview: '',
      imageUrl: '',
      rating: 1,
      releaseYear: '2020',
      genre: 'Action',
      runtimeMinutes: 120,
    ),
  );

  @override
  Future<AppResult<MovieCredits>> getMovieCredits(int movieId) async =>
      const Right(MovieCredits(cast: [], crew: []));

  @override
  Future<AppResult<List<MovieVideo>>> getMovieVideos(int movieId) async =>
      const Right(<MovieVideo>[]);
}

const _genres = [Genre(id: 28, name: 'Action'), Genre(id: 35, name: 'Comedy')];

Movie _movie(int id, List<int> genreIds) => Movie(
  id: id,
  title: 'Movie $id',
  overview: '',
  imageUrl: '',
  rating: 1,
  releaseYear: '2020',
  genreIds: genreIds,
);

final _movies = [_movie(1, <int>[])];
final _popular = [
  _movie(10, const [28]),
  _movie(11, const [35]),
  _movie(12, const [28, 35]),
];
final _topRated = [
  _movie(20, const [28]),
  _movie(21, const [35]),
];
final _trending = [
  _movie(30, const [35]),
  _movie(31, const [28]),
];

final _actionPopular = [
  _movie(100, const [28]),
  _movie(101, const [28]),
];
final _actionTopRated = [
  _movie(200, const [28]),
];

final _comedyPopular = [
  _movie(110, const [35]),
];
final _comedyTopRated = [
  _movie(210, const [35]),
  _movie(211, const [35]),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeHomeRepository repository;
  late HomeCubit cubit;

  setUp(() {
    repository = _FakeHomeRepository();
    repository.genreMovies[28] = {
      'popular': _actionPopular,
      'topRated': _actionTopRated,
    };
    repository.genreMovies[35] = {
      'popular': _comedyPopular,
      'topRated': _comedyTopRated,
    };
    cubit = HomeCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  test('loads home data with full lists initially (All)', () async {
    await cubit.loadHomeData();
    final state = cubit.state as HomeSuccess;
    expect(state.visiblePopularMovies.length, 3);
    expect(state.visibleTopRatedMovies.length, 2);
    expect(state.visibleTrendingMovies.length, 2);
    expect(state.selectedGenreId, isNull);
    expect(state.isGenreLoading, isFalse);
  });

  test(
    'selectGenre loads genre-specific data via repository for all sections',
    () async {
      await cubit.loadHomeData();
      await cubit.selectGenre(28);

      final state = cubit.state as HomeSuccess;
      expect(state.selectedGenreId, 28);
      expect(state.visiblePopularMovies.map((m) => m.id).toList(), [100, 101]);
      expect(state.visibleTopRatedMovies.map((m) => m.id).toList(), [200]);
      // Trending reuses the Most Popular Discover result (identical query).
      expect(state.visibleTrendingMovies.map((m) => m.id).toList(), [100, 101]);
      expect(repository.getMoviesByGenreCalls.length, 2);
      expect(repository.getMoviesByGenreCalls[0].$1, 28);
      expect(repository.getMoviesByGenreCalls[0].$2, 'popularity.desc');
      expect(repository.getMoviesByGenreCalls[1].$2, 'vote_average.desc');
      expect(repository.getMoviesByGenreCalls[1].$3, isNotNull);
    },
  );

  test('selectGenre works for another genre (Comedy)', () async {
    await cubit.loadHomeData();
    await cubit.selectGenre(35);

    final state = cubit.state as HomeSuccess;
    expect(state.selectedGenreId, 35);
    expect(state.visiblePopularMovies.map((m) => m.id).toList(), [110]);
    expect(state.visibleTopRatedMovies.map((m) => m.id).toList(), [210, 211]);
    expect(state.visibleTrendingMovies.map((m) => m.id).toList(), [110]);
  });

  test('setGenreLoading emits loading state while fetching', () async {
    await cubit.loadHomeData();
    final future = cubit.selectGenre(28);
    final loadingState = cubit.state as HomeSuccess;
    expect(loadingState.isGenreLoading, isTrue);
    expect(loadingState.selectedGenreId, 28);
    await future;
    expect((cubit.state as HomeSuccess).isGenreLoading, isFalse);
  });

  test('caches genre data and does not re-request the same genre', () async {
    await cubit.loadHomeData();
    await cubit.selectGenre(28);
    await cubit.selectGenre(35);
    await cubit.selectGenre(28);

    expect(repository.getMoviesByGenreCalls.length, 4);
    final state = cubit.state as HomeSuccess;
    expect(state.selectedGenreId, 28);
    expect(state.visiblePopularMovies.map((m) => m.id).toList(), [100, 101]);
  });

  test(
    're-tapping the same genre while loading does not duplicate requests',
    () async {
      await cubit.loadHomeData();

      final gate = Completer<void>();
      repository.gate = gate;
      final first = cubit.selectGenre(28);
      final second = cubit.selectGenre(28);

      expect(repository.getMoviesByGenreCalls.length, 2);
      gate.complete();
      await Future.wait([first, second]);

      expect(repository.getMoviesByGenreCalls.length, 2);
      final state = cubit.state as HomeSuccess;
      expect(state.selectedGenreId, 28);
      expect(state.isGenreLoading, isFalse);
      repository.gate = null;
    },
  );

  test('fires popular and top rated requests concurrently', () async {
    await cubit.loadHomeData();

    final gate = Completer<void>();
    repository.gate = gate;
    final loading = cubit.selectGenre(28);

    // Both independent Discover requests must have started while the first
    // one is still held by the gate (i.e. they are not run sequentially).
    expect(repository.getMoviesByGenreCalls.length, 2);
    gate.complete();
    await loading;

    final state = cubit.state as HomeSuccess;
    expect(state.selectedGenreId, 28);
    expect(state.visiblePopularMovies.length, 2);
    expect(state.visibleTopRatedMovies.length, 1);
    repository.gate = null;
  });

  test('stale genre response does not overwrite a newer selection', () async {
    await cubit.loadHomeData();

    // Hold Action's requests until after Comedy has resolved.
    final actionGate = Completer<void>();
    repository.gate = actionGate;
    repository.gateGenreId = 28;
    final action = cubit.selectGenre(28);

    // Comedy is not gated and completes while Action is still in flight.
    final comedy = cubit.selectGenre(35);
    await comedy;
    expect((cubit.state as HomeSuccess).selectedGenreId, 35);

    actionGate.complete();
    await action;

    // Action's late-arriving results must be cached but discarded from state.
    final state = cubit.state as HomeSuccess;
    expect(state.selectedGenreId, 35);
    expect(state.visiblePopularMovies.map((m) => m.id).toList(), [110]);
    expect(repository.getMoviesByGenreCalls.length, 4);

    // Re-selecting Action is instant thanks to the cached (discarded) results.
    await cubit.selectGenre(28);
    expect(repository.getMoviesByGenreCalls.length, 4);
    expect(
      (cubit.state as HomeSuccess).visiblePopularMovies
          .map((m) => m.id)
          .toList(),
      [100, 101],
    );
    repository.gate = null;
    repository.gateGenreId = null;
  });

  test(
    'selectGenre(null) restores the original data without API requests',
    () async {
      await cubit.loadHomeData();
      await cubit.selectGenre(28);
      final callsAfterGenre = repository.getMoviesByGenreCalls.length;
      await cubit.selectGenre(null);

      final state = cubit.state as HomeSuccess;
      expect(state.selectedGenreId, isNull);
      expect(state.visiblePopularMovies.length, 3);
      expect(state.visibleTopRatedMovies.length, 2);
      expect(state.visibleTrendingMovies.length, 2);
      expect(repository.getMoviesByGenreCalls.length, callsAfterGenre);
    },
  );

  test('switching All → Action → Comedy → All works correctly', () async {
    await cubit.loadHomeData();
    await cubit.selectGenre(28);
    expect((cubit.state as HomeSuccess).visiblePopularMovies.length, 2);

    await cubit.selectGenre(35);
    expect((cubit.state as HomeSuccess).visiblePopularMovies.length, 1);

    await cubit.selectGenre(null);
    final state = cubit.state as HomeSuccess;
    expect(state.selectedGenreId, isNull);
    expect(state.visiblePopularMovies.length, 3);
    expect(state.visibleTopRatedMovies.length, 2);
    expect(state.visibleTrendingMovies.length, 2);
  });

  test(
    'selectGenre with a genre producing no data returns empty lists',
    () async {
      await cubit.loadHomeData();
      await cubit.selectGenre(99);

      final state = cubit.state as HomeSuccess;
      expect(state.selectedGenreId, 99);
      expect(state.visiblePopularMovies, isEmpty);
      expect(state.visibleTopRatedMovies, isEmpty);
      expect(state.visibleTrendingMovies, isEmpty);
    },
  );
}
