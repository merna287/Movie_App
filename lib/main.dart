import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/common/views/main_layout.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'core/service/deep_link_service.dart';
import 'core/service/service_locator.dart';
import 'core/responsive/app_screen_util_scope.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'features/onboarding/presentation/view/onboarding_screen.dart';

final deepLinkService = DeepLinkService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();
  final isAuthenticated =
      await FirebaseAuth.instance.authStateChanges().first != null;
  debugPrint(
    '[AUTH-GATE] resolved at startup -> currentUser==null: '
    '${FirebaseAuth.instance.currentUser == null} | uid: '
    '${FirebaseAuth.instance.currentUser?.uid ?? 'none'} | email: '
    '${FirebaseAuth.instance.currentUser?.email ?? 'none'} | branch: '
    '${isAuthenticated ? 'MainLayout' : 'Onboarding'}',
  );
  runApp(MyApp(startAuthenticated: isAuthenticated));
}

class MyApp extends StatefulWidget {
  final bool startAuthenticated;

  const MyApp({super.key, required this.startAuthenticated});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isAuthenticated;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = widget.startAuthenticated;
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      _onAuthStateChanged,
    );
    deepLinkService.attach();
  }

  void _onAuthStateChanged(User? user) {
    final authenticated = user != null;
    debugPrint(
      '[AUTH-GATE] listenevent -> currentUser==null: '
      '${FirebaseAuth.instance.currentUser == null} | uid: '
      '${FirebaseAuth.instance.currentUser?.uid ?? 'none'} | email: '
      '${FirebaseAuth.instance.currentUser?.email ?? 'none'} | branch: '
      '${authenticated ? 'MainLayout' : 'Onboarding'}',
    );
    if (authenticated != _isAuthenticated) {
      setState(() => _isAuthenticated = authenticated);
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
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
              home: _isAuthenticated
                  ? const MainLayout()
                  : const OnboardingScreen(),
            );
          },
        ),
      ),
    );
  }
}
