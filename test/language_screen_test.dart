import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/features/profile/presentation/views/language_screen.dart';

class _InMemoryAssetLoader extends AssetLoader {
  final Map<String, dynamic> _data;

  _InMemoryAssetLoader(this._data);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) =>
      Future.value(_data);
}

const _translations = <String, dynamic>{
  'settingsLanguage': 'Language',
  'english': 'English',
  'arabic': 'Arabic',
};

late _InMemoryAssetLoader _loader;

Future<void> _pump(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: _loader,
      child: AppScreenUtilScope(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const LanguageScreen(),
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    _loader = _InMemoryAssetLoader(_translations);
  });

  Locale currentLocale(WidgetTester tester) {
    final element = tester.element(find.byType(LanguageScreen));
    return Localizations.localeOf(element);
  }

  testWidgets('offers only English and Arabic', (tester) async {
    await _pump(tester);

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(currentLocale(tester).languageCode, 'en');
  });

  testWidgets('selecting Arabic switches the app to Arabic', (tester) async {
    await _pump(tester);

    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();

    expect(currentLocale(tester).languageCode, 'ar');
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('selecting English switches the app back to English',
      (tester) async {
    await _pump(tester);

    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();
    expect(currentLocale(tester).languageCode, 'ar');

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(currentLocale(tester).languageCode, 'en');
  });

  testWidgets('selected language is preserved when reopening the screen',
      (tester) async {
    await _pump(tester);

    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();
    expect(currentLocale(tester).languageCode, 'ar');

    // Reopen the screen (same EasyLocalization session keeps the locale).
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: _loader,
        child: AppScreenUtilScope(
          child: Builder(
            builder: (context) {
              return MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const LanguageScreen(),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(currentLocale(tester).languageCode, 'ar');
    expect(find.text('Arabic'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });
}
