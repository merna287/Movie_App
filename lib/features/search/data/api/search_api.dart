import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/search/data/models/search_actor_model.dart';
import 'package:movie_app/features/search/data/models/search_movie_model.dart';
import 'package:movie_app/features/search/data/models/search_multi_model.dart';

class SearchApi {
  final http.Client _client;

  SearchApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AppResult<List<MovieModel>>> fetchSearchMovies(
    String query, {
    int page = 1,
  }) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.searchMovies).replace(
        queryParameters: <String, String>{
          'query': query,
          'include_adult': 'false',
          'page': '$page',
        },
      );

      final response = await _client.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final rawResults = decoded['results'];

      if (rawResults is! List) {
        throw const ParsingException('Response is missing "results" array');
      }

      final movies = rawResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint('TMDB search "$query": ${movies.length} movies fetched');
      return movies;
    });
  }

  Future<AppResult<SearchMultiModel>> fetchMultiSearch(
    String query, {
    int page = 1,
  }) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.searchMulti).replace(
        queryParameters: <String, String>{
          'query': query,
          'include_adult': 'false',
          'page': '$page',
        },
      );

      final response = await _client.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final rawResults = decoded['results'];

      if (rawResults is! List) {
        throw const ParsingException('Response is missing "results" array');
      }

      final movies = <SearchMovieModel>[];
      final actors = <SearchActorModel>[];
      String? topType;

      for (final item in rawResults.whereType<Map<String, dynamic>>()) {
        final type = item['media_type']?.toString() ?? '';
        topType ??= type;

        switch (type) {
          case 'movie' || 'tv':
            movies.add(SearchMovieModel.fromJson(item));
          case 'person':
            actors.add(SearchActorModel.fromJson(item));
        }
      }

      debugPrint(
        'TMDB multi search "$query": '
        '${movies.length} movies, ${actors.length} actors fetched',
      );

      return SearchMultiModel(
        movies: movies,
        actors: actors,
        topIsActor: topType == 'person',
      );
    });
  }

  Future<AppResult<List<GenreModel>>> fetchMovieGenres() {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.movieCategories);

      final response = await _client.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final rawGenres = decoded['genres'];

      if (rawGenres is! List) {
        throw const ParsingException('Response is missing "genres" array');
      }

      return rawGenres
          .map((item) => GenreModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  Future<AppResult<List<MovieModel>>> fetchNowPlayingMovies() {
    return _fetchMovieResults(
      Uri.parse(ApiEndpoints.nowPlayingMovies),
      logLabel: 'now playing',
    );
  }

  Future<AppResult<List<MovieModel>>> fetchPopularMovies() {
    return _fetchMovieResults(
      Uri.parse(ApiEndpoints.popularMovies),
      logLabel: 'popular',
    );
  }

  Future<AppResult<List<MovieModel>>> _fetchMovieResults(
    Uri requestUri, {
    required String logLabel,
  }) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final response = await _client.get(
        requestUri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final rawResults = decoded['results'];

      if (rawResults is! List) {
        throw const ParsingException('Response is missing "results" array');
      }

      final movies = rawResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint('TMDB $logLabel: ${movies.length} movies fetched');
      return movies;
    });
  }
}