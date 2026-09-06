import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/features/favorite/presentation/widgets/favorite_loading_shimmer.dart';

void main() {
  testWidgets('Favorite loading shimmer renders without overflow or badges', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppScreenUtilScope(
        child: const MaterialApp(
          home: Scaffold(body: FavoriteLoadingShimmer()),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(FavoriteLoadingShimmer), findsOneWidget);
    expect(find.text('Premium'), findsNothing);
    expect(find.text('Free'), findsNothing);
  });
}