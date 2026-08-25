import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movie_app/main.dart';

void main() {
  testWidgets('Onboarding screen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.runAsync(() => EasyLocalization.ensureInitialized());

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify onboarding screen is displayed
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify the first onboarding title is present
    expect(
      find.text('Lorem ipsum dolor sit amet consecteur esplicit'),
      findsOneWidget,
    );

    // Verify next button (arrow icon) is present
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });
}
