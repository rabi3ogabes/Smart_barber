import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_staff/app/session.dart';

import 'helpers.dart';

Future<void> pumpApp(WidgetTester tester, FakeStaffAuthRepository repo, {Locale locale = const Locale('ar')}) async {
  await tester.pumpWidget(routedApp(overrides: await baseOverrides(repo: repo, locale: locale.languageCode), locale: locale));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('password → 2FA → salon picker → signed in to the chosen salon', (tester) async {
    final repo = FakeStaffAuthRepository();
    await pumpApp(tester, repo, locale: const Locale('en'));

    expect(find.text('Staff sign in'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Yousef@Salon.qa ');
    await tester.enterText(find.byType(TextField).at(1), 'secret');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(repo.calls, ['login:yousef@salon.qa']);
    expect(find.text('Two-factor authentication'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123456');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a salon'), findsOneWidget);
    expect(find.text('Pearl Grooming'), findsOneWidget);

    await tester.tap(find.text('Pearl Grooming'));
    await tester.pumpAndSettle();
    expect(repo.calls.last, 'select:S2');
    expect(find.text('Your chair, live'), findsOneWidget);
    expect(find.text('Elite Barbers'), findsOneWidget); // salon from /staff/me in the app bar
  });

  testWidgets('shows translated errors from the server', (tester) async {
    final repo = FakeStaffAuthRepository()..loginResult = const Err(ApiFailure(code: 'TWO_FACTOR_ENROLLMENT_REQUIRED', status: 403));
    await pumpApp(tester, repo);

    await tester.enterText(find.byType(TextField).at(0), 'owner@salon.qa');
    await tester.enterText(find.byType(TextField).at(1), 'secret');
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.text('فعّل المصادقة الثنائية من لوحة التحكم قبل تسجيل الدخول هنا.'), findsOneWidget);
  });

  testWidgets('a wrong 2FA code keeps the user on the step with an error', (tester) async {
    final repo = FakeStaffAuthRepository()..twoFactorResult = const Err(ApiFailure(code: 'TWO_FACTOR_INVALID', status: 422));
    await pumpApp(tester, repo, locale: const Locale('en'));

    await tester.enterText(find.byType(TextField).at(0), 'a@b.qa');
    await tester.enterText(find.byType(TextField).at(1), 'x');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '000000');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('The authentication code is incorrect.'), findsOneWidget);
    expect(find.text('Two-factor authentication'), findsOneWidget);
  });

  test('session survives only while the server accepts it', () async {
    final container = ProviderContainer(overrides: [...await baseOverrides(repo: FakeStaffAuthRepository())]);
    addTearDown(container.dispose);
    expect(await container.read(staffSessionProvider.future), isA<StaffSignedOut>());

    await container.read(staffSessionProvider.notifier).signedIn(testTokens);
    expect(container.read(staffSessionProvider).value, isA<StaffSignedInState>());

    container.read(staffSessionProvider.notifier).expired();
    expect(container.read(staffSessionProvider).value, isA<StaffSignedOut>().having((s) => s.expired, 'expired', true));
  });
}
