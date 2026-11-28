import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

import '../fake_api.dart';
import '../fixtures.dart';

/// The full booking journey, shared by the widget test (here) and the on-device integration test:
/// Home → Book → service → barber → time → summary → confirm, including a 409 on the first try.
Future<void> runBookingFlow(WidgetTester tester, Locale locale) async {
  final l = lookupAppLocalizations(locale);
  final sb = lookupSbLocalizations(locale);
  final ar = locale.languageCode == 'ar';
  final api = salonApi();

  var attempts = 0;
  api
    ..on('GET /branches/$branchId/slots', (_) => FakeResponse.ok(attempts == 0 ? slotsJson() : slotsJson(times: ['14:30', '15:00'])))
    ..on('POST /customer/bookings', (req) {
      attempts++;
      if (attempts == 1) {
        return FakeResponse.error(409, 'BOOKING_SLOT_TAKEN', data: {'alternatives': ['2026-11-27T11:30:00Z']});
      }
      return FakeResponse(201, {'success': true, 'message': null, 'data': bookingJson(startsAt: '2026-11-27T11:30:00Z'), 'meta': <String, Object?>{}});
    });

  await tester.pumpWidget(await appWith(api, locale: locale));
  await tester.pumpAndSettle();

  // Home for the remembered salon.
  expect(find.text(ar ? 'صالون النخبة' : 'Elite Barbers'), findsOneWidget);
  expect(find.text(l.popularServices), findsOneWidget);

  // Step 1 — services.
  await tester.tap(find.text(l.tabBook));
  await tester.pumpAndSettle();
  expect(find.text(l.stepServices), findsOneWidget);
  await tester.tap(find.text(ar ? 'قص الشعر' : 'Haircut'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel));
  await tester.pumpAndSettle();

  // Step 2 — barber.
  expect(find.text(l.stepBarber), findsOneWidget);
  expect(find.text(l.anyBarber), findsOneWidget);
  await tester.tap(find.text(ar ? 'يوسف' : 'Yousef'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel));
  await tester.pumpAndSettle();

  // Step 3 — time from the API.
  expect(find.text(l.stepTime), findsOneWidget);
  await tester.tap(find.text('14:00'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel));
  await tester.pumpAndSettle();

  // Step 4 — the server's quote, then confirm: someone took the slot (409).
  expect(find.text(l.stepSummary), findsOneWidget);
  expect(find.text('QAR 60.00'), findsWidgets);
  await tester.tap(find.text(l.confirmBooking));
  await tester.pumpAndSettle();
  expect(find.text(l.stepTime), findsOneWidget);
  expect(find.text(l.slotTakenMessage), findsOneWidget); // inline, not a snackbar over the button
  expect(find.text(l.slotTakenAlternatives), findsOneWidget);
  expect(find.text('14:00'), findsNothing); // refreshed times

  // Pick the suggested time and confirm again.
  await tester.tap(find.text('14:30'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel));
  await tester.pumpAndSettle();
  await tester.tap(find.text(l.confirmBooking));
  await tester.pumpAndSettle();
  expect(find.text(l.bookingConfirmedTitle), findsOneWidget);

  // What reached the server: two intents, each with its own Idempotency-Key; ids only, no prices.
  final posts = api.sent('POST', '/customer/bookings').toList();
  expect(posts, hasLength(2));
  expect(posts.map((r) => r.idempotencyKey), everyElement(isNotNull));
  expect(posts[0].idempotencyKey, isNot(posts[1].idempotencyKey));
  final body = posts[1].body! as Map;
  expect(body['branch'], branchId);
  expect(body['services'], [haircutId]);
  expect(body['barber'], barberAId);
  expect(body['starts_at'], '2026-11-27T11:30:00.000Z');
  expect(body.containsKey('price'), isFalse);
  expect(api.unmatched, isEmpty);
}

/// A network error on Confirm keeps the same Idempotency-Key for the retry (rule 6).
Future<void> runRetryKeepsKey(WidgetTester tester) async {
  const locale = Locale('en');
  final l = lookupAppLocalizations(locale);
  final sb = lookupSbLocalizations(locale);
  final api = salonApi();
  var attempts = 0;
  api.on('POST /customer/bookings', (_) {
    attempts++;
    if (attempts == 1) throw DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline');
    return FakeResponse(201, {'success': true, 'message': null, 'data': bookingJson(), 'meta': <String, Object?>{}});
  });

  await tester.pumpWidget(await appWith(api, locale: locale));
  await tester.pumpAndSettle();
  await tester.tap(find.text(l.tabBook));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Haircut'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel)); // any barber
  await tester.pumpAndSettle();
  await tester.tap(find.text('14:00'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(sb.continueLabel));
  await tester.pumpAndSettle();

  await tester.tap(find.text(l.confirmBooking));
  await tester.pumpAndSettle();
  expect(find.text(sb.errorNetworkOffline), findsOneWidget);
  await tester.tap(find.text(l.confirmBooking));
  await tester.pumpAndSettle();
  expect(find.text(l.bookingConfirmedTitle), findsOneWidget);

  final posts = api.sent('POST', '/customer/bookings').toList();
  expect(posts, hasLength(2));
  expect(posts[0].idempotencyKey, isNotNull);
  expect(posts[1].idempotencyKey, posts[0].idempotencyKey);
  expect((posts[1].body! as Map)['barber'], 'any');
}
