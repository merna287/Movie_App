import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class _FakeFavoriteRepository implements FavoriteRepository {
  List<Movie> favorites = const [];
  Failure? listFailure;
  Failure? addFailure;
  Failure? removeFailure;
  Completer<void>? addGate;

  int addCalls = 0;
  int removeCalls = 0;

  @override
  Future<AppResult<List<Movie>>> getFavoriteMovies(String accountId) async {
    if (listFailure != null) return Left(listFailure!);
    return Right(favorites);
  }

  @override
  Future<AppResult<bool>> addFavorite({
    required String accountId,
    required int movieId,
  }) async {
    addCalls++;
    final gate = addGate;
    if (gate != null) await gate.future;
    if (addFailure != null) return Left(addFailure!);
    futures.add(movieId);
    return const Right(true);
  }

  @override
  Future<AppResult<bool>> removeFavorite({
    required String accountId,
    required int movieId,
  }) async {
    removeCalls++;
    if (removeFailure != null) return Left(removeFailure!);
    futures.remove(movieId);
    return const Right(true);
  }

  // Mirrors what a real backend would hold after add/remove calls.
  final Set<int> futures = {};
}

Movie _movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  overview: '',
  imageUrl: '',
  rating: 1,
  releaseYear: '2020',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeFavoriteRepository repository;
  late FavoriteCubit cubit;

  setUp(() {
    repository = _FakeFavoriteRepository();
    cubit = FavoriteCubit(
      repository,
      isAuthenticated: () => true,
      accountId: '12345',
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('load exposes the saved favorites', () async {
    repository.favorites = [_movie(1), _movie(2)];

    await cubit.load();

    final state = cubit.state as FavoriteLoaded;
    expect(state.movies.map((m) => m.id), [1, 2]);
    expect(cubit.isFavorite(1), isTrue);
    expect(cubit.isFavorite(3), isFalse);
  });

  test('load emits error when list request fails', () async {
    repository.listFailure = const UnknownFailure();

    await cubit.load();

    expect(cubit.state, isA<FavoriteError>());
  });

  test('toggleMovie adds a movie through the repository', () async {
    await cubit.load();

    await cubit.toggleMovie(_movie(9));

    final state = cubit.state as FavoriteLoaded;
    expect(state.movies.map((m) => m.id), [9]);
    expect(repository.addCalls, 1);
    expect(repository.futures, {9});
  });

  test('toggleMovie removes a movie that is already favorite', () async {
    repository.favorites = [_movie(9)];
    await cubit.load();

    await cubit.toggleMovie(_movie(9));

    final state = cubit.state as FavoriteLoaded;
    expect(state.movies, isEmpty);
    expect(repository.removeCalls, 1);
    expect(repository.futures, isEmpty);
  });

  test('second tap on the same movie is ignored while in flight', () async {
    await cubit.load();

    final gate = Completer<void>();
    repository.addGate = gate;

    final first = cubit.toggleMovie(_movie(9));
    final second = cubit.toggleMovie(_movie(9));

    expect(repository.addCalls, 1);
    gate.complete();
    await Future.wait([first, second]);

    expect(repository.addCalls, 1);
    expect((cubit.state as FavoriteLoaded).movies.map((m) => m.id), [9]);
    repository.addGate = null;
  });

  test('failed add restores the previous list and surfaces the message', () async {
    await cubit.load();
    repository.addFailure = const UnknownFailure();

    await cubit.toggleMovie(_movie(9));

    final state = cubit.state as FavoriteLoaded;
    expect(state.movies, isEmpty);
    expect(state.errorMessage, isNotNull);
    expect(repository.futures, isEmpty);
  });

  test('unauthenticated toggle does not call the repository', () async {
    cubit = FavoriteCubit(
      repository,
      isAuthenticated: () => false,
      accountId: '12345',
    );
    await cubit.load();

    await cubit.toggleMovie(_movie(9));

    final state = cubit.state as FavoriteLoaded;
    expect(state.errorMessage, LocaleKeys.signInRequired.tr());
    expect(repository.addCalls, 0);
    expect(repository.removeCalls, 0);
  });

  test('toggle without an account id emits an error', () async {
    cubit = FavoriteCubit(
      repository,
      isAuthenticated: () => true,
      accountId: '',
    );

    await cubit.toggleMovie(_movie(9));

    expect(cubit.state, isA<FavoriteError>());
    expect(repository.addCalls, 0);
  });

  test('removeMovie removes the movie and keeps the list otherwise', () async {
    repository.favorites = [_movie(1), _movie(2)];
    await cubit.load();

    await cubit.removeMovie(1);

    final state = cubit.state as FavoriteLoaded;
    expect(state.movies.map((m) => m.id), [2]);
    expect(repository.removeCalls, 1);
  });

  test('isPending reflects an in-flight toggle', () async {
    await cubit.load();

    final gate = Completer<void>();
    repository.addGate = gate;

    final toggle = cubit.toggleMovie(_movie(9));

    expect(cubit.isPending(9), isTrue);
    expect(cubit.state, isA<FavoriteToggling>());
    expect((cubit.state as FavoriteToggling).pendingMovieId, 9);

    gate.complete();
    await toggle;

    expect(cubit.isPending(9), isFalse);
    repository.addGate = null;
  });
}