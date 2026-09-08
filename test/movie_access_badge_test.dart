import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/views/movie_section_screen.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_card.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_card.dart';
import 'package:movie_app/features/search/presentation/widgets/search_movie_card.dart';

class _InMemoryAssetLoader extends AssetLoader {
  final Map<String, dynamic> _data;

  _InMemoryAssetLoader(this._data);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) =>
      Future.value(_data);
}

late Map<String, dynamic> _translations;

Movie _movie({
  required int id,
  required String title,
  required double rating,
}) =>
    Movie(
      id: id,
      title: title,
      overview: '',
      imageUrl: 'https://image.tmdb.org/t/p/w500/example.jpg',
      rating: rating,
      releaseYear: '2024',
      genre: 'Drama',
    );

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: _InMemoryAssetLoader(_translations),
      child: AppScreenUtilScope(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: child,
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    final json = await rootBundle.loadString('assets/translations/en.json');
    _translations = jsonDecode(json) as Map<String, dynamic>;
  });

  group('Movie access status single source of truth', () {
    test('isPremium derives from rating', () {
      expect(_movie(id: 1, title: 'A', rating: 8.4).isPremium, isTrue);
      expect(_movie(id: 2, title: 'B', rating: 7.0).isPremium, isTrue);
      expect(_movie(id: 3, title: 'C', rating: 6.9).isPremium, isFalse);
      expect(_movie(id: 4, title: 'D', rating: 5.0).isPremium, isFalse);
    });

    testWidgets('premium movie shows the same Premium badge on Home and Search',
        (tester) async {
      final movies = [_movie(id: 550, title: 'Fight Club', rating: 8.4)];

      await _pump(
        tester,
        Scaffold(
          body: ListView(
            children: [
              SizedBox(
                width: 295,
                height: 154,
                child: FeaturedMovieCard(movie: movies.first),
              ),
              SizedBox(
                width: 135,
                height: 231,
                child: MovieCard(movie: movies.first),
              ),
              SearchMovieCard(movie: movies.first),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Premium'), findsNWidgets(3));
      expect(find.text('Free'), findsNothing);

      await _pump(
        tester,
        MovieSectionScreen(title: 'See all', movies: movies),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Premium'), findsOneWidget);
      expect(find.text('Free'), findsNothing);
    });

    testWidgets('free movie shows the same Free badge on Home and Search', (
      tester,
    ) async {
      final movies = [_movie(id: 600, title: 'The Room', rating: 4.6)];

      await _pump(
        tester,
        Scaffold(
          body: ListView(
            children: [
              SizedBox(
                width: 295,
                height: 154,
                child: FeaturedMovieCard(movie: movies.first),
              ),
              SizedBox(
                width: 135,
                height: 231,
                child: MovieCard(movie: movies.first),
              ),
              SearchMovieCard(movie: movies.first),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Free'), findsNWidgets(3));
      expect(find.text('Premium'), findsNothing);

      await _pump(
        tester,
        MovieSectionScreen(title: 'See all', movies: movies),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Premium'), findsNothing);
    });
  });
}