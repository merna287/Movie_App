import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_app/core/constants/app_assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all AppAssets entries are registered and loadable', () async {
    final paths = <String>[
      AppAssets.onboarding1,
      AppAssets.onboarding2,
      AppAssets.onboarding3,
      AppAssets.googleIcon,
      AppAssets.facebookIcon,
      AppAssets.liveTvIcon,
    ];

    for (final path in paths) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0), reason: path);
    }
  });
}
