import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/common/widgets/profile_avatar.dart';
import 'package:movie_app/core/responsive/app_screen_util_scope.dart';
import 'package:movie_app/core/theme/app_colors.dart';

Future<void> _pumpAvatar(WidgetTester tester, ProfileAvatar avatar) async {
  await tester.pumpWidget(
    AppScreenUtilScope(
      child: MaterialApp(
        home: Scaffold(
          body: Center(child: avatar),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('same name always resolves to the same color', () {
    expect(ProfileAvatar.colorFor('Merna'), ProfileAvatar.colorFor('Merna'));
    expect(ProfileAvatar.colorFor('Ahmed'), ProfileAvatar.colorFor('Ahmed'));
  });

  test('different names resolve to different colors', () {
    const names = ['Merna', 'Ahmed', 'Sara', 'Omar', 'John'];
    final distinct = names.map(ProfileAvatar.colorFor).toSet();
    expect(distinct.length, greaterThan(1));
  });

  test('empty name uses the neutral placeholder color', () {
    expect(ProfileAvatar.colorFor(''), AppColors.headerButtonColor);
    expect(ProfileAvatar.colorFor('   '), AppColors.headerButtonColor);
  });

  testWidgets('shows uppercase first letter when there is no image',
      (tester) async {
    await _pumpAvatar(
      tester,
      const ProfileAvatar(name: 'Merna', radius: 32),
    );

    expect(find.text('M'), findsOneWidget);
    expect(find.byType(NetworkImage), findsNothing);
  });

  testWidgets('letter is centered inside a circular avatar', (tester) async {
    await _pumpAvatar(
      tester,
      const ProfileAvatar(name: 'Merna', radius: 32),
    );

    final circle = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(circle.backgroundColor, ProfileAvatar.colorFor('Merna'));

    final letterCenter = tester.getCenter(find.text('M'));
    final circleCenter = tester.getCenter(find.byType(CircleAvatar));
    expect((letterCenter - circleCenter).distance, lessThan(0.1));
  });

  testWidgets('displays the profile image when imageUrl is provided',
      (tester) async {
    await _pumpAvatar(
      tester,
      const ProfileAvatar(
        name: 'Merna',
        imageUrl: 'https://example.com/avatar.png',
        radius: 32,
      ),
    );

    expect(find.text('M'), findsNothing);
    final circle = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(circle.foregroundImage, isA<NetworkImage>());
  });

  testWidgets('avatar letter and color update when the name changes',
      (tester) async {
    await _pumpAvatar(
      tester,
      const ProfileAvatar(name: 'Merna', radius: 32),
    );
    expect(find.text('M'), findsOneWidget);
    final colorBefore =
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundColor;

    await _pumpAvatar(
      tester,
      const ProfileAvatar(name: 'Ahmed', radius: 32),
    );

    expect(find.text('M'), findsNothing);
    expect(find.text('A'), findsOneWidget);
    final colorAfter =
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundColor;
    expect(colorAfter, ProfileAvatar.colorFor('Ahmed'));
    expect(colorAfter, isNot(colorBefore));
  });

  testWidgets('falls back to neutral placeholder when name and image are empty',
      (tester) async {
    await _pumpAvatar(tester, const ProfileAvatar(radius: 32));

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(Text), findsNothing);
    expect(find.byType(NetworkImage), findsNothing);
  });
}