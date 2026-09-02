import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/core/network/api_endpoints.dart';
import 'package:movie_app/features/details/data/models/movie_credits_model.dart';
import 'package:movie_app/features/details/data/models/movie_details_model.dart';
import 'package:movie_app/features/details/data/models/movie_video_model.dart';

class DetailsApi {
  final http.Client _client;

  DetailsApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AppResult<MovieDetailsModel>> fetchMovieDetails(int movieId) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.movieDetails(movieId));

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

      debugPrint('TMDB details: movie $movieId fetched');
      return MovieDetailsModel.fromJson(decoded);
    });
  }

  Future<AppResult<MovieCreditsModel>> fetchMovieCredits(int movieId) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.movieCredits(movieId));

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

      debugPrint('TMDB credits: movie $movieId fetched');
      return MovieCreditsModel.fromJson(decoded);
    });
  }

  Future<AppResult<List<MovieVideoModel>>> fetchMovieVideos(int movieId) {
    return safeApiCall(() async {
      const token = ApiConfig.readAccessToken;

      final uri = Uri.parse(ApiEndpoints.movieVideos(movieId));

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

      final videos = rawResults
          .whereType<Map<String, dynamic>>()
          .map(MovieVideoModel.fromJson)
          .toList();

      debugPrint(
        'TMDB videos: ${videos.length} videos fetched for movie $movieId',
      );
      return videos;
    });
  }
}
