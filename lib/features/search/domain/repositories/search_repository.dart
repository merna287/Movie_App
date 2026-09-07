import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/entities/search_home_data.dart';
import 'package:movie_app/features/search/domain/entities/search_results.dart';

abstract class SearchRepository {
  Future<AppResult<List<Movie>>> searchMovies(String query);

  Future<AppResult<SearchResults>> searchAll(String query);

  Future<AppResult<SearchHomeData>> getSearchHomeData();
}