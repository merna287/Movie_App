import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  final List<Movie> movies;
  final List<Genre> genres;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> trendingMovies;
  final int? selectedGenreId;
  final List<Movie> filteredPopularMovies;
  final List<Movie> filteredTopRatedMovies;
  final List<Movie> filteredTrendingMovies;
  final bool isGenreLoading;

  const HomeSuccess({
    required this.movies,
    required this.genres,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.trendingMovies,
    this.selectedGenreId,
    this.filteredPopularMovies = const <Movie>[],
    this.filteredTopRatedMovies = const <Movie>[],
    this.filteredTrendingMovies = const <Movie>[],
    this.isGenreLoading = false,
  });

  HomeSuccess copyWith({
    int? selectedGenreId,
    bool clearSelectedGenreId = false,
    List<Movie>? filteredPopularMovies,
    List<Movie>? filteredTopRatedMovies,
    List<Movie>? filteredTrendingMovies,
    bool? isGenreLoading,
  }) {
    return HomeSuccess(
      movies: movies,
      genres: genres,
      popularMovies: popularMovies,
      topRatedMovies: topRatedMovies,
      trendingMovies: trendingMovies,
      selectedGenreId: clearSelectedGenreId ? null : selectedGenreId,
      filteredPopularMovies:
          filteredPopularMovies ?? this.filteredPopularMovies,
      filteredTopRatedMovies:
          filteredTopRatedMovies ?? this.filteredTopRatedMovies,
      filteredTrendingMovies:
          filteredTrendingMovies ?? this.filteredTrendingMovies,
      isGenreLoading: isGenreLoading ?? this.isGenreLoading,
    );
  }

  List<Movie> get visiblePopularMovies =>
      selectedGenreId == null ? popularMovies : filteredPopularMovies;

  List<Movie> get visibleTopRatedMovies =>
      selectedGenreId == null ? topRatedMovies : filteredTopRatedMovies;

  List<Movie> get visibleTrendingMovies =>
      selectedGenreId == null ? trendingMovies : filteredTrendingMovies;
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
