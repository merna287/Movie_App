import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'core/service/deep_link_service.dart';
import 'core/service/service_locator.dart';
import 'core/responsive/app_screen_util_scope.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/onboarding/presentation/view/onboarding_screen.dart';

final deepLinkService = DeepLinkService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    deepLinkService.attach();
  }

  @override
  void dispose() {
    deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: AppScreenUtilScope(
        child: Builder(
          builder: (context) {
            return GetMaterialApp(
              title: LocaleKeys.appName.tr(),
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
