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
            .map(
              (m) => {
                'id': m.id,
                'title': m.title,
                'overview': m.overview,
                'poster_path': m.posterPath,
                'backdrop_path': m.backdropPath,
                'vote_average': m.voteAverage,
                'release_date': m.releaseDate,
                'genre_ids': m.genreIds,
              },
            )
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

  test(
    'fetchDiscoverMoviesByGenre includes vote_count.gte when provided',
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
    },
  );

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

  test('fetchMovieDetails maps runtime, year and genres', () async {
    Uri? captured;
    final client = MockClient((request) async {
      captured = request.url;
      return http.Response(
        jsonEncode({
          'id': 550,
          'title': 'Fight Club',
          'overview': 'An insomniac office worker.',
          'poster_path': '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
          'backdrop_path': null,
          'vote_average': 8.4,
          'release_date': '1999-10-15',
          'runtime': 139,
          'genres': [
            {'id': 18, 'name': 'Drama'},
            {'id': 53, 'name': 'Thriller'},
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = HomeApi(client: client);
    final result = await api.fetchMovieDetails(550);

    expect(result.isRight(), isTrue);
    expect(captured, isNotNull);
    expect(captured!.path, '/3/movie/550');

    final details = result.getRight().toNullable()!.toEntity();
    expect(details.runtimeMinutes, 139);
    expect(details.releaseYear, '1999');
    expect(details.genre, 'Drama');
    expect(details.title, 'Fight Club');
  });

  test('fetchMovieCredits maps cast characters and crew jobs', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'cast': [
            {
              'id': 1,
              'name': 'Brad Pitt',
              'character': 'Tyler Durden',
              'profile_path': '/a.jpg',
            },
            {
              'id': 2,
              'name': 'Edward Norton',
              'character': 'The Narrator',
              'profile_path': '/b.jpg',
            },
          ],
          'crew': [
            {
              'id': 3,
              'name': 'David Fincher',
              'job': 'Director',
              'profile_path': '/c.jpg',
            },
            {
              'id': 4,
              'name': 'Jim Uhls',
              'job': 'Screenplay',
              'profile_path': null,
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = HomeApi(client: client);
    final result = await api.fetchMovieCredits(550);

    expect(result.isRight(), isTrue);

    final credits = result.getRight().toNullable()!.toEntity();
    expect(credits.cast.length, 2);
    expect(credits.cast.first.name, 'Brad Pitt');
    expect(credits.cast.first.character, 'Tyler Durden');
    expect(credits.cast.first.imageUrl, isNotEmpty);
    expect(credits.crew.first.job, 'Director');
    expect(credits.crew.first.name, 'David Fincher');
    expect(credits.crew.first.imageUrl, isNotEmpty);
    expect(credits.crew.last.imageUrl, isEmpty);
  });

  test('fetchMovieVideos maps the video results list', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'results': [
            {
              'key': 'abc123',
              'site': 'YouTube',
              'type': 'Trailer',
              'name': 'Trailer 1',
            },
            {'key': 'def456', 'site': 'Vimeo', 'type': 'Clip', 'name': 'Clip'},
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = HomeApi(client: client);
    final result = await api.fetchMovieVideos(550);

    expect(result.isRight(), isTrue);

    final videos = result
        .getRight()
        .toNullable()!
        .map((video) => video.toEntity())
        .toList();
    expect(videos.length, 2);
    expect(videos.first.key, 'abc123');
    expect(videos.first.isUsableTrailer, isTrue);
    expect(videos.first.watchUrl, 'https://www.youtube.com/watch?v=abc123');
    expect(videos.last.isUsableTrailer, isFalse);
  });
}
