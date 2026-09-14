import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/common/widgets/profile_avatar.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/features/profile/presentation/widgets/profile_card.dart';

Future<void> _pumpCard(WidgetTester tester, ProfileCard card) async {
  await tester.pumpWidget(
    AppScreenUtilScope(
      child: MaterialApp(
        home: Scaffold(
          body: Center(child: card),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows real values and an initial-based avatar without an image',
      (tester) async {
    await _pumpCard(
      tester,
      ProfileCard(
        name: 'Merna Bahgat',
        email: 'merna@example.com',
        avatarUrl: '',
        onEdit: () {},
      ),
    );

    expect(find.text('Merna Bahgat'), findsOneWidget);
    expect(find.text('merna@example.com'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
    expect(find.byType(ProfileAvatar), findsOneWidget);
  });

  testWidgets('shows the profile image instead of the initial when one exists',
      (tester) async {
    await _pumpCard(
      tester,
      ProfileCard(
        name: 'Merna Bahgat',
        email: 'merna@example.com',
        avatarUrl: 'https://example.com/avatar.png',
        onEdit: () {},
      ),
    );

    expect(find.text('Merna Bahgat'), findsOneWidget);
    expect(find.text('M'), findsNothing);
    final circle =
        tester.widget<CircleAvatar>(find.descendant(
          of: find.byType(ProfileAvatar),
          matching: find.byType(CircleAvatar),
        ));
    expect(circle.foregroundImage, isA<NetworkImage>());
  });

  testWidgets('avatar letter matches the profile name', (tester) async {
    await _pumpCard(
      tester,
      ProfileCard(
        name: 'Ahmed Hassan',
        email: 'ahmed@example.com',
        avatarUrl: '',
        onEdit: () {},
      ),
    );

    expect(find.text('Ahmed Hassan'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
  });
}