import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_details_shimmer.dart';

void main() {
  testWidgets('Movie Details shimmer renders without overflow or badges', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      AppScreenUtilScope(
        child: const MaterialApp(
          home: Scaffold(body: MovieDetailsShimmer()),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(MovieDetailsShimmer), findsOneWidget);
    expect(find.text('Premium'), findsNothing);
    expect(find.text('Free'), findsNothing);
  });
}