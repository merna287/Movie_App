import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/features/details/presentation/views/movie_details_screen.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/views/movie_section_screen.dart';

class _InMemoryAssetLoader extends AssetLoader {
  final Map<String, dynamic> _data;

  _InMemoryAssetLoader(this._data);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) =>
      Future.value(_data);
}

late Map<String, dynamic> _translations;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    final json = await rootBundle.loadString('assets/translations/en.json');
    _translations = jsonDecode(json) as Map<String, dynamic>;
    setupServiceLocator();
  });

  testWidgets(
    'Movie Details opened as a pushed route resolves FavoriteCubit',
    (tester) async {
      final movie = Movie(
        id: 550,
        title: 'Fight Club',
        overview: 'An insomniac office worker and a devil-may-care soap maker.',
        imageUrl: 'https://image.tmdb.org/t/p/w500/example.jpg',
        rating: 8.4,
        releaseYear: '1999',
        genre: 'Drama',
      );

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
                  home: const Scaffold(body: SizedBox.shrink()),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => MovieDetailsScreen(movie: movie),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Fight Club'), findsOneWidget);
      expect(find.text('Premium'), findsNothing);
      expect(find.text('Free'), findsNothing);
    },
  );

  testWidgets('See-all movie list shows the movie access badge from data', (
    tester,
  ) async {
    final movie = Movie(
      id: 550,
      title: 'Fight Club',
      overview: 'An insomniac office worker and a devil-may-care soap maker.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/example.jpg',
      rating: 8.4,
      releaseYear: '1999',
      genre: 'Drama',
    );

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
                home: MovieSectionScreen(title: 'Now Playing', movies: [movie]),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(movie.title), findsOneWidget);
    expect(movie.isPremium, isTrue);
    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Free'), findsNothing);
  });
}