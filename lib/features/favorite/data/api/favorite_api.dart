import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';

class FavoriteApi {
  final http.Client _client;

  FavoriteApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AppResult<List<MovieModel>>> fetchFavoriteMovies(
    String accountId,
  ) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;
      final uri = Uri.parse(ApiEndpoints.favoriteMovies(accountId));
      final response = await _client.get(
        uri,
        headers: {
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
        throw const ParsingException(
          'Response is missing "results" array',
        );
      }

      final movies = rawResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint('TMDB favorites: ${movies.length} movies fetched');
      return movies;
    });
  }

  Future<AppResult<bool>> removeFavoriteMovie({
    required String accountId,
    required int movieId,
  }) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.favoriteMovie(accountId));

      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      debugPrint('TMDB favorites: movie $movieId removed');
      return true;
    });
  }
}
