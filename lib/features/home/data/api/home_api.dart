import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';
import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';

class HomeApi {
  final http.Client _client;

  HomeApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AppResult<List<MovieModel>>> fetchDiscoverMovies() {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      if (token.isEmpty) {
        debugPrint('TMDB token configured: false');
      } else {
        debugPrint('TMDB token configured: true');
      }

      final uri = Uri.parse(
        ApiEndpoints.discoverMovies,
      ).replace(queryParameters: {'sort_by': 'popularity.desc'});

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
        throw const ParsingException('Response is missing "results" array');
      }

      final movies = rawResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint('TMDB discover: ${movies.length} movies fetched');
      return movies;
    });
  }
}
