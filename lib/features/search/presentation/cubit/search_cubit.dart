import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/entities/search_results.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_app/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repository;

  /// Delay between the last keystroke and the actual TMDB request.
  final Duration debounceDuration;

  Timer? _debounce;
  String _lastQuery = '';

  /// Monotonically increasing token used to drop responses that belong to a
  /// query which has been superseded by a newer one.
  int _requestSeq = 0;

  List<Movie> _todayMovies = const [];
  List<Movie> _recommended = const [];
  bool _idleLoading = false;
  bool _idleLoaded = false;

  SearchCubit(
    this._repository, {
    this.debounceDuration = const Duration(milliseconds: 400),
  }) : super(const SearchIdle());

  /// Loads the "Today" + "Recommend for you" data shown while the query is
  /// empty. Once loaded the data is cached so switching between tabs does not
  /// refetch it.
  Future<void> loadInitialData() async {
    if (_idleLoading || _idleLoaded) return;

    _idleLoading = true;
    emit(const SearchIdle(loading: true));

    final result = await _repository.getSearchHomeData();

    if (isClosed) return;
    _idleLoading = false;

    result.fold(
      (failure) {
        debugPrint(
          'Search home data failed: ${failureMessage(failure)}',
        );
        emit(const SearchIdle());
      },
      (data) {
        _idleLoaded = true;
        _todayMovies = data.todayMovies;
        _recommended = data.recommended;
        emit(
          SearchIdle(
            todayMovies: _todayMovies,
            recommended: _recommended,
          ),
        );
      },
    );
  }

  void onQueryChanged(String raw) {
    _debounce?.cancel();
    _requestSeq++;

    final query = raw.trim();
    _lastQuery = query;

    if (query.isEmpty) {
      emit(
        SearchIdle(
          todayMovies: _todayMovies,
          recommended: _recommended,
        ),
      );
      return;
    }

    _debounce = Timer(debounceDuration, () => _runSearch(query));
  }

  Future<void> search(String raw) async {
    _debounce?.cancel();
    _requestSeq++;

    final query = raw.trim();
    _lastQuery = query;

    if (query.isEmpty) {
      emit(
        SearchIdle(
          todayMovies: _todayMovies,
          recommended: _recommended,
        ),
      );
      return;
    }

    await _runSearch(query);
  }

  Future<void> retry() {
    final query = _lastQuery;
    if (query.isEmpty) {
      emit(
        SearchIdle(
          todayMovies: _todayMovies,
          recommended: _recommended,
        ),
      );
      return Future.value();
    }
    return _runSearch(query);
  }

  Future<void> _runSearch(String query) async {
    final requestId = ++_requestSeq;
    emit(SearchLoading(query: query));

    final result = await _repository.searchAll(query);

    if (isClosed || requestId != _requestSeq) return;

    result.fold(
      (failure) => emit(
        SearchError(message: failureMessage(failure), query: query),
      ),
      (results) => emit(_resultState(query, results)),
    );
  }

  SearchState _resultState(String query, SearchResults results) {
    if (results.isEmpty) return SearchEmpty(query: query);

    // A person as the top-ranked hit drives the Actors + Movie Related view.
    if (results.topIsActor && results.actors.isNotEmpty) {
      return SearchActorResults(
        query: query,
        actors: results.actors,
        movies: _relatedMovies(results),
      );
    }

    return SearchMovieResults(query: query, movies: results.movies);
  }

  List<Movie> _relatedMovies(SearchResults results) {
    final seen = <int>{};
    final related = <Movie>[];

    for (final actor in results.actors) {
      for (final movie in actor.knownFor) {
        if (movie.imageUrl.isEmpty) continue;
        if (seen.add(movie.id)) related.add(movie);
      }
    }

    // Fall back to the plain movie hits when no actor has known-for movies.
    return related.isEmpty ? results.movies : related;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}