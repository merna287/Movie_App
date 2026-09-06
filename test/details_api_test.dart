import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie_app/features/details/data/api/details_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    final api = DetailsApi(client: client);
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

    final api = DetailsApi(client: client);
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

    final api = DetailsApi(client: client);
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
