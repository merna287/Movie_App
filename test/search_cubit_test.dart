import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';
import 'package:movie_app/features/search/domain/entities/search_home_data.dart';
import 'package:movie_app/features/search/domain/entities/search_results.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movie_app/features/search/presentation/cubit/search_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSearchRepository implements SearchRepository {
  List<Movie> results = const [];
  List<Actor> actors = const [];
  bool topIsActor = false;
  Failure? failure;
  Completer<void>? gate;

  int searchAllCalls = 0;
  final List<String> queries = [];
  SearchHomeData homeData = const SearchHomeData(
    todayMovies: [],
    recommended: [],
  );

  @override
  Future<AppResult<List<Movie>>> searchMovies(String query) async {
    final currentGate = gate;
    if (currentGate != null) await currentGate.future;
    if (failure != null) return Left(failure!);
    return Right(results);
  }

  @override
  Future<AppResult<SearchResults>> searchAll(String query) async {
    searchAllCalls++;
    queries.add(query);
    final currentGate = gate;
    if (currentGate != null) await currentGate.future;
    if (failure != null) return Left(failure!);
    return Right(
      SearchResults(
        movies: results,
        actors: actors,
        topIsActor: topIsActor,
      ),
    );
  }

  @override
  Future<AppResult<SearchHomeData>> getSearchHomeData() async {
    if (failure != null) return Left(failure!);
    return Right(homeData);
  }
}

Movie _movie(int id, {String title = ''}) => Movie(
  id: id,
  title: title.isEmpty ? 'Movie $id' : title,
  overview: '',
  imageUrl: 'https://image.tmdb.org/t/p/w500/img$id.jpg',
  rating: 7,
  releaseYear: '2024',
);

Actor _actor(int id) => Actor(
  id: id,
  name: 'Actor $id',
  imageUrl: '',
  knownFor: [_movie(100 + id)],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeSearchRepository repository;
  late SearchCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = _FakeSearchRepository();
    cubit = SearchCubit(
      repository,
      debounceDuration: const Duration(milliseconds: 20),
    );
    await EasyLocalization.ensureInitialized();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('starts in the idle state', () {
    expect(cubit.state, isA<SearchIdle>());
  });

  test('loadInitialData emits idle with home data', () async {
    repository.homeData = const SearchHomeData(
      todayMovies: [Movie(id: 1, title: 'Today', overview: '', imageUrl: '', rating: 8, releaseYear: '2024')],
      recommended: [Movie(id: 2, title: 'Pick', overview: '', imageUrl: '', rating: 7, releaseYear: '2023')],
    );

    await cubit.loadInitialData();

    final state = cubit.state;
    expect(state, isA<SearchIdle>());
    final idle = state as SearchIdle;
    expect(idle.todayMovies.single.title, 'Today');
    expect(idle.recommended.single.title, 'Pick');
  });

  test('search emits loading then movie results', () async {
    repository.results = [_movie(1, title: 'Fight Club'), _movie(2, title: 'Drive')];

    await cubit.search('fight club');

    expect(repository.searchAllCalls, 1);
    expect(repository.queries.single, 'fight club');
    expect(cubit.state, isA<SearchMovieResults>());
    final state = cubit.state as SearchMovieResults;
    expect(state.query, 'fight club');
    expect(state.movies.map((m) => m.title), ['Fight Club', 'Drive']);
  });

  test('query with top-ranked actor shows actor results', () async {
    repository.actors = [_actor(1), _actor(2)];
    repository.results = [_movie(1, title: 'Movie 1')];
    repository.topIsActor = true;

    await cubit.search('john');

    final state = cubit.state;
    expect(state, isA<SearchActorResults>());
    final actorState = state as SearchActorResults;
    expect(actorState.actors, hasLength(2));
    expect(actorState.movies, hasLength(2));
    expect(actorState.movies.first.title, isNotEmpty);
  });

  test('empty query stays idle and does not call the API', () async {
    await cubit.search('   ');

    expect(cubit.state, isA<SearchIdle>());
    expect(repository.searchAllCalls, 0);

    cubit.onQueryChanged('');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(cubit.state, isA<SearchIdle>());
    expect(repository.searchAllCalls, 0);
  });

  test('search debounces rapid keystrokes to a single request', () async {
    repository.results = [_movie(1, title: 'Fight Club')];

    cubit.onQueryChanged('fi');
    await Future<void>.delayed(const Duration(milliseconds: 1));
    cubit.onQueryChanged('fight');
    await Future<void>.delayed(const Duration(milliseconds: 1));
    cubit.onQueryChanged('fight club');

    await Future<void>.delayed(const Duration(milliseconds: 80));

    expect(repository.searchAllCalls, 1);
    expect(repository.queries.single, 'fight club');
    expect(cubit.state, isA<SearchMovieResults>());
  });

  test('empty results emit the empty state', () async {
    await cubit.search('zzzz');

    expect(cubit.state, isA<SearchEmpty>());
    expect((cubit.state as SearchEmpty).query, 'zzzz');
  });

  test('failure emits an error state with a localized message', () async {
    repository.failure = const UnknownFailure();

    await cubit.search('fight');

    final state = cubit.state;
    expect(state, isA<SearchError>());
    expect((state as SearchError).message, LocaleKeys.unexpectedError.tr());
  });

  test('retry re-runs the last query', () async {
    repository.failure = const UnknownFailure();
    await cubit.search('fight');
    expect(cubit.state, isA<SearchError>());
    expect(repository.searchAllCalls, 1);

    repository.failure = null;
    repository.results = [_movie(1, title: 'Fight Club')];
    await cubit.retry();

    expect(repository.searchAllCalls, 2);
    expect(repository.queries.last, 'fight');
    expect(cubit.state, isA<SearchMovieResults>());
  });

  test('stale in-flight responses are dropped after a newer query', () async {
    final gate = Completer<void>();
    repository.gate = gate;
    repository.results = [_movie(1, title: 'Fight Club')];

    final emitted = <SearchState>[];
    final subscription = cubit.stream.listen(emitted.add);

    cubit.onQueryChanged('old query');
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(cubit.state, isA<SearchLoading>());

    cubit.onQueryChanged('new query');
    repository.gate = null;
    repository.results = [_movie(2, title: 'Drive')];

    gate.complete();
    await Future<void>.delayed(const Duration(milliseconds: 80));

    final latest = cubit.state;
    expect(latest, isA<SearchMovieResults>());
    expect((latest as SearchMovieResults).query, 'new query');
    expect(latest.movies.single.title, 'Drive');

    final staleSnapshot = emitted.whereType<SearchMovieResults>().toList();
    expect(staleSnapshot, hasLength(1));
    expect(staleSnapshot.single.query, 'new query');

    await subscription.cancel();
  });
}