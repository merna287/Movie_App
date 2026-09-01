import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie_app/features/home/data/api/home_api.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  http.Response buildResponse(List<MovieModel> movies) {
    return http.Response(
      jsonEncode({
        'page': 1,
        'results': movies
            .map((m) => {
                  'id': m.id,
                  'title': m.title,
                  'overview': m.overview,
                  'poster_path': m.posterPath,
                  'backdrop_path': m.backdropPath,
                  'vote_average': m.voteAverage,
                  'release_date': m.releaseDate,
                  'genre_ids': m.genreIds,
                })
            .toList(),
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  final sampleMovie = MovieModel(
    id: 1,
    title: 'A',
    overview: '',
    genreIds: const [28],
    voteAverage: 0,
    releaseDate: '',
  );

  test('fetchDiscoverMoviesByGenre sends with_genres and sort_by', () async {
    Uri? captured;
    final client = MockClient((request) async {
      captured = request.url;
      return buildResponse([sampleMovie]);
    });

    final api = HomeApi(client: client);
    final result = await api.fetchDiscoverMoviesByGenre(
      genreId: 28,
      sortBy: 'popularity.desc',
    );

    expect(result.isRight(), isTrue);
    expect(captured, isNotNull);
    expect(captured!.queryParameters['with_genres'], '28');
    expect(captured!.queryParameters['sort_by'], 'popularity.desc');
    expect(captured!.queryParameters.containsKey('vote_count.gte'), isFalse);
  });

  test('fetchDiscoverMoviesByGenre includes vote_count.gte when provided',
      () async {
    Uri? captured;
    final client = MockClient((request) async {
      captured = request.url;
      return buildResponse([sampleMovie]);
    });

    final api = HomeApi(client: client);
    await api.fetchDiscoverMoviesByGenre(
      genreId: 18,
      sortBy: 'vote_average.desc',
      minVoteCount: 200,
    );

    expect(captured!.queryParameters['with_genres'], '18');
    expect(captured!.queryParameters['sort_by'], 'vote_average.desc');
    expect(captured!.queryParameters['vote_count.gte'], '200');
  });

  test('fetchDiscoverMoviesByGenre maps to MovieModel entities', () async {
    final client = MockClient((request) async => buildResponse([sampleMovie]));
    final api = HomeApi(client: client);
    final result = await api.fetchDiscoverMoviesByGenre(
      genreId: 28,
      sortBy: 'popularity.desc',
    );

    final movies = result.getRight().toNullable()!;
    expect(movies.length, 1);
    expect(movies.first.genreIds, [28]);
  });
}