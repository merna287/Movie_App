import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/features/details/presentation/views/movie_details_screen.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';
import 'package:movie_app/features/search/domain/entities/search_home_data.dart';
import 'package:movie_app/features/search/domain/entities/search_results.dart';
import 'package:movie_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movie_app/features/search/presentation/views/search_screen.dart';
import 'package:movie_app/features/search/presentation/widgets/search_movie_card.dart';
import 'package:movie_app/features/search/presentation/widgets/search_no_results_view.dart';
import 'package:movie_app/features/search/presentation/widgets/search_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _InMemoryAssetLoader extends AssetLoader {
  final Map<String, dynamic> _data;

  _InMemoryAssetLoader(this._data);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) =>
      Future.value(_data);
}

late Map<String, dynamic> _translations;

class _FakeSearchRepository implements SearchRepository {
  List<Movie> results = const [];
  List<Actor> actors = const [];
  bool topIsActor = false;
  Failure? failure;
  Completer<void>? gate;
  SearchHomeData homeData = const SearchHomeData(
    todayMovies: [
      Movie(
        id: 501,
        title: 'Today Movie',
        overview: '',
        imageUrl: 'https://image.tmdb.org/t/p/w500/today.jpg',
        rating: 8,
        releaseYear: '2024',
      ),
    ],
    recommended: [
      Movie(
        id: 502,
        title: 'Pick for You',
        overview: '',
        imageUrl: 'https://image.tmdb.org/t/p/w500/pick.jpg',
        rating: 7,
        releaseYear: '2023',
      ),
    ],
  );

  @override
  Future<AppResult<List<Movie>>> searchMovies(String query) async {
    final currentGate = gate;
    if (currentGate != null) await currentGate.future;
    if (failure != null) return Left(failure!);
    return Right(results);
  }

  @override
  Future<AppResult<SearchResults>> searchAll(String query) async {
    final currentGate = gate;
    if (currentGate != null) await currentGate.future;
    if (failure != null) return Left(failure!);
    return Right(
      SearchResults(
        movies: results,
        actors: actors,
        topIsActor: topIsActor,
      ),
    );
  }

  @override
  Future<AppResult<SearchHomeData>> getSearchHomeData() async {
    if (failure != null) return Left(failure!);
    return Right(homeData);
  }
}

Movie _movie(int id, String title) => Movie(
  id: id,
  title: title,
  overview: '',
  imageUrl: 'https://image.tmdb.org/t/p/w500/example.jpg',
  rating: 7,
  releaseYear: '2024',
);

Actor _actor(int id, String name) => Actor(
  id: id,
  name: name,
  imageUrl: '',
  knownFor: [_movie(300 + id, '$name Movie')],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late _FakeSearchRepository repository;
  late SearchCubit cubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    final json = await rootBundle.loadString('assets/translations/en.json');
    _translations = jsonDecode(json) as Map<String, dynamic>;
    setupServiceLocator();
  });
  Future<void> pumpSearch(
    WidgetTester tester, {
    SearchCubit? customCubit,
  }) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        assetLoader: _InMemoryAssetLoader(_translations),
        child: AppScreenUtilScope(
          child: Builder(
            builder: (context) {
              return GetMaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: BlocProvider.value(
                  value: customCubit ?? cubit,
                  child: const SearchScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void setWideSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1600, 3200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
  }

  setUp(() {
    Get.reset();
    repository = _FakeSearchRepository();
    cubit = SearchCubit(repository);
    repository.gate = null;
  });

  tearDown(() async {
    await cubit.close();
  });

  group('Search shell', () {
    testWidgets('renders the initial screen before typing', (tester) async {
      setWideSurface(tester);

      await pumpSearch(tester);

      expect(tester.takeException(), isNull);
      expect(find.text(LocaleKeys.today.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.recommendForYou.tr()), findsOneWidget);
      expect(find.text('Today Movie'), findsOneWidget);
      expect(find.byType(SearchMovieCard), findsWidgets);
    });

    testWidgets('typing a query shows the shimmer then the results', (
      tester,
    ) async {
      setWideSurface(tester);

      repository.results = [_movie(1, 'Fight Club'), _movie(2, 'Drive')];
      final gate = Completer<void>();
      repository.gate = gate;

      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'fight');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(SearchShimmer), findsOneWidget);
      expect(tester.takeException(), isNull);

      gate.complete();
      repository.gate = null;
      await tester.pump();

      expect(find.byType(SearchShimmer), findsNothing);
      expect(find.text('Fight Club'), findsOneWidget);
      expect(find.text('Drive'), findsOneWidget);
      expect(find.byType(SearchMovieCard), findsNWidgets(2));
    });

    testWidgets('actor query shows the Actors + Movie Related view', (
      tester,
    ) async {
      setWideSurface(tester);

      repository.actors = [_actor(1, 'John Wick')];
      repository.topIsActor = true;

      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'john');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();

      expect(find.text(LocaleKeys.actors.tr()), findsOneWidget);
      expect(find.text('John Wick'), findsOneWidget);
      expect(find.text(LocaleKeys.movieRelated.tr()), findsOneWidget);
      expect(find.text('John Wick Movie'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('clear button resets to the initial screen', (tester) async {
      setWideSurface(tester);

      repository.results = [_movie(1, 'Fight Club')];

      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'fight');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      expect(find.byType(SearchMovieCard), findsOneWidget);

      await tester.tap(find.text(LocaleKeys.cancel.tr()));
      await tester.pump();

      expect(find.text(LocaleKeys.today.tr()), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    });

    testWidgets('empty results show the no-results state', (tester) async {
      setWideSurface(tester);

      repository.results = const [];
      repository.actors = const [];

      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();

      expect(
        find.text(LocaleKeys.weAreSorryCannotFindMovie.tr()),
        findsOneWidget,
      );
      expect(find.text(LocaleKeys.findYourMovie.tr()), findsOneWidget);
      expect(find.byType(SearchNoResultsView), findsOneWidget);
    });

    testWidgets('error state shows the message and retry re-runs the search', (
      tester,
    ) async {
      setWideSurface(tester);

      repository.failure = const UnknownFailure();

      await pumpSearch(tester);

      await tester.enterText(find.byType(TextField), 'fight');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();

      expect(
        find.text(LocaleKeys.unexpectedError.tr()),
        findsOneWidget,
      );

      repository.failure = null;
      repository.results = [_movie(1, 'Fight Club')];

      await tester.tap(find.text(LocaleKeys.retry.tr()));
      await tester.pump();
      await tester.pump();

      expect(find.byType(SearchMovieCard), findsOneWidget);
      expect(find.text('Fight Club'), findsOneWidget);
    });
  });

  group('Search navigation', () {
    testWidgets('tapping a search result opens Movie Details', (tester) async {
      setWideSurface(tester);

      repository.results = [_movie(550, 'Fight Club')];
      final navigatorCubit = SearchCubit(repository);

      await pumpSearch(tester, customCubit: navigatorCubit);

      await tester.enterText(find.byType(TextField), 'fight');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();

      await tester.tap(find.text('Fight Club'));
      await tester.pumpAndSettle();

      expect(find.byType(MovieDetailsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);

      await navigatorCubit.close();
    });
  });
}