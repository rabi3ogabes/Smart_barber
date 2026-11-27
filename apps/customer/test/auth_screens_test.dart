import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_customer/features/auth/otp_screen.dart';
import 'package:smartbarber_customer/features/auth/phone_screen.dart';

import 'helpers.dart';

GoRouter _router() => GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, s) => const PhoneScreen(),
      routes: [GoRoute(path: 'code', builder: (_, s) => Text('OTP for ${s.uri.queryParameters['phone']}'))],
    ),
  ],
);

void main() {
  testWidgets('phone screen validates locally, then sends the normalised number', (tester) async {
    final repo = FakeCustomerAuthRepository();
    await tester.pumpWidget(testApp(overrides: await baseOverrides(repo: repo), router: _router()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '12');
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(find.text('أدخل رقم جوال صحيحاً.'), findsOneWidget);
    expect(repo.requested, isEmpty);

    await tester.enterText(find.byType(TextField), '٥٥١٢ ٣٤٥٦');
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(repo.requested, ['+97455123456']);
    expect(find.text('OTP for +97455123456'), findsOneWidget);
  });

  testWidgets('phone screen shows the translated server error, not a raw exception', (tester) async {
    final repo = FakeCustomerAuthRepository()..otpResult = const Err(ApiFailure(code: 'RATE_LIMITED', status: 429));
    await tester.pumpWidget(testApp(overrides: await baseOverrides(repo: repo), router: _router()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '55123456');
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();

    expect(find.text('محاولات كثيرة. يرجى الانتظار قليلاً ثم المحاولة مرة أخرى.'), findsOneWidget);
  });

  testWidgets('phone screen shows an offline message when there is no network', (tester) async {
    final repo = FakeCustomerAuthRepository()..otpResult = const Err(NetworkFailure(NetworkIssue.offline));
    await tester.pumpWidget(testApp(overrides: await baseOverrides(repo: repo), router: _router(), locale: const Locale('en')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '55123456');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection. Check your connection and try again.'), findsOneWidget);
  });

  testWidgets('OTP screen shows wrong-code errors and counts down before resend', (tester) async {
    final repo = FakeCustomerAuthRepository();
    final router = GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => const OtpScreen(phone: '+97455123456', retryAfter: 3))]);
    await tester.pumpWidget(testApp(overrides: await baseOverrides(repo: repo), router: router, locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Resend code in 3s'), findsOneWidget);
    expect(find.textContaining('+97455123456'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123');
    await tester.tap(find.text('Verify'));
    await tester.pump();
    expect(find.text('Enter the 6 digits from the message.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pumpAndSettle();
    expect(find.text('The code is incorrect.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Resend code'), findsOneWidget);
  });
}
