import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/responsive/app_screen_util_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/view/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: AppScreenUtilScope(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'CINEMAX',
              theme: AppTheme.theme,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const OnboardingScreen(),
            );
          },
        ),
      ),
    );
  }
}
