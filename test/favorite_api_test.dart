import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie_app/features/favorite/data/api/favorite_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  http.Response favoriteResponse(String body) => http.Response(
    body,
    200,
    headers: {'content-type': 'application/json'},
  );

  test('fetchFavoriteMovies maps the results list', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/3/account/12345/favorite/movies');
      return favoriteResponse(
        jsonEncode({
          'results': [
            {
              'id': 550,
              'title': 'Fight Club',
              'overview': 'An insomniac office worker.',
              'poster_path': '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
              'vote_average': 8.4,
              'release_date': '1999-10-15',
            },
          ],
        }),
      );
    });

    final api = FavoriteApi(client: client);
    final result = await api.fetchFavoriteMovies('12345');

    expect(result.isRight(), isTrue);
    final movies = result.getRight().toNullable()!;
    expect(movies.length, 1);
    expect(movies.first.id, 550);
    expect(movies.first.title, 'Fight Club');
  });

  test('addFavoriteMovie posts favorite=true to the account endpoint', () async {
    http.Request? captured;
    Map<String, dynamic>? capturedBody;
    final client = MockClient((request) async {
      captured = request;
      capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
      return favoriteResponse(jsonEncode({'success': true}));
    });

    final api = FavoriteApi(client: client);
    final result = await api.addFavoriteMovie(accountId: '12345', movieId: 550);

    expect(result.isRight(), isTrue);
    expect(captured, isNotNull);
    expect(captured!.url.path, '/3/account/12345/favorite');
    expect(captured!.method, 'POST');
    expect(capturedBody, {
      'media_type': 'movie',
      'media_id': 550,
      'favorite': true,
    });
  });

  test('removeFavoriteMovie posts favorite=false to the account endpoint', () async {
    Map<String, dynamic>? capturedBody;
    final client = MockClient((request) async {
      capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
      return favoriteResponse(jsonEncode({'success': true}));
    });

    final api = FavoriteApi(client: client);
    final result = await api.removeFavoriteMovie(
      accountId: '12345',
      movieId: 550,
    );

    expect(result.isRight(), isTrue);
    expect(capturedBody, {
      'media_type': 'movie',
      'media_id': 550,
      'favorite': false,
    });
  });

  test('setFavorite returns a failure for a non-2xx response', () async {
    final client = MockClient((request) async {
      return http.Response('error', 401);
    });

    final api = FavoriteApi(client: client);
    final result = await api.addFavoriteMovie(accountId: '12345', movieId: 550);

    expect(result.isLeft(), isTrue);
  });
}