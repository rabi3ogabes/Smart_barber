import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

import 'fake_api.dart';
import 'fixtures.dart';

const en = Locale('en');
final AppLocalizations l = lookupAppLocalizations(en);
final SbLocalizations sb = lookupSbLocalizations(en);

Future<FakeApi> pumpApp(WidgetTester tester, {FakeApi? api, bool salonChosen = true, Locale locale = en, String? location}) async {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fake = api ?? salonApi();
  await tester.pumpWidget(await appWith(fake, locale: locale, salonChosen: salonChosen));
  await tester.pumpAndSettle();
  if (location != null) {
    routerOf(tester).go(location);
    await tester.pumpAndSettle();
  }
  return fake;
}

void main() {
  group('salon entry', () {
    testWidgets('without a salon, Home sends you to salon entry; a code opens and remembers the salon', (tester) async {
      final api = salonApi()..on('GET /salons/resolve', (r) => r.query['code'] == 'elite' ? FakeResponse.ok(salonCard) : FakeResponse.error(404, 'INVALID_SALON_CODE'));
      await pumpApp(tester, api: api, salonChosen: false);
      expect(find.text(l.salonEntryTitle), findsOneWidget);
      expect(find.text('Elite Barbers'), findsOneWidget); // "your salons"

      await tester.enterText(find.byType(TextField).first, 'nope');
      await tester.tap(find.text(l.salonOpen));
      await tester.pumpAndSettle();
      expect(find.text(l.salonCodeNotFound), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'elite');
      await tester.tap(find.text(l.salonOpen));
      await tester.pumpAndSettle();
      expect(find.text(l.nextAppointment), findsOneWidget);
    });

    testWidgets('search says plainly when no listed salon matches', (tester) async {
      final api = salonApi()
        ..json('GET /customer/salons', <Object?>[])
        ..json('GET /salons/search', <Object?>[]);
      await pumpApp(tester, api: api, salonChosen: false);
      expect(find.text(l.salonYoursEmpty), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'zz');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(l.salonSearchEmpty), 200, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.salonSearchEmpty), findsOneWidget);
    });

    testWidgets('a smartbarber://salon link resolves the salon and opens Home', (tester) async {
      final api = salonApi()..json('GET /salons/resolve', salonCard);
      await pumpApp(tester, api: api, salonChosen: false, location: '/salon/elite');
      expect(find.text(l.nextAppointment), findsOneWidget);
      expect(api.sent('GET', '/salons/resolve').single.query['code'], 'elite');
    });
  });

  group('home', () {
    testWidgets('shows the next appointment with actions, book again, popular services and only enabled features', (tester) async {
      final api = salonApi()..json('GET /customer/home', homeJson(next: bookingJson(), aiStudio: true, reviewPrompt: true));
      await pumpApp(tester, api: api);

      expect(find.textContaining('Good morning, Rashid'), findsOneWidget);
      expect(find.text(l.rateLastVisitWith('Yousef')), findsOneWidget);
      expect(find.text(l.reschedule), findsOneWidget);
      expect(find.text(l.bookAgain('Haircut')), findsOneWidget);
      await tester.scrollUntilVisible(find.text(l.aiSoonTitle), 200, scrollable: find.byType(Scrollable).first);
      expect(find.text(l.popularServices), findsOneWidget);
      expect(find.text(l.loyaltySoonTitle), findsNothing);
    });

    testWidgets('shows an error with retry, never a raw exception', (tester) async {
      var calls = 0;
      final api = salonApi()
        ..on('GET /customer/home', (_) {
          calls++;
          return calls == 1 ? FakeResponse.error(500, 'SERVER_ERROR', message: 'SQLSTATE[42S02]') : FakeResponse.ok(homeJson());
        });
      await pumpApp(tester, api: api);
      expect(find.textContaining('SQLSTATE'), findsNothing);
      expect(find.text(sb.retry), findsOneWidget);

      await tester.tap(find.text(sb.retry));
      await tester.pumpAndSettle();
      expect(find.text(l.noNextAppointment), findsOneWidget);
    });

    testWidgets('"Book again" pre-fills the stepper and skips to the barber step', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text(l.bookAgain('Haircut')));
      await tester.pumpAndSettle();
      expect(find.text(l.stepBarber), findsOneWidget);
    });
  });

  group('appointments', () {
    testWidgets('upcoming and past tabs have friendly empty states', (tester) async {
      await pumpApp(tester, location: '/appointments');
      expect(find.text(l.noUpcomingTitle), findsOneWidget);
      await tester.tap(find.text(l.past));
      await tester.pumpAndSettle();
      expect(find.text(l.noPastTitle), findsOneWidget);
    });

    testWidgets('a booking notification deep link opens the detail with timeline and policy; cancel sends a key', (tester) async {
      final api = salonApi()
        ..json('GET /customer/bookings/$bookingId', bookingJson())
        ..json('POST /customer/bookings/$bookingId/cancel', bookingJson(status: 'cancelled', canChange: false));
      await pumpApp(tester, api: api, location: '/booking/$bookingId');

      expect(find.text(l.bookingDetailTitle), findsOneWidget);
      expect(find.text(l.statusConfirmed), findsWidgets);
      expect(find.text(l.timelineTitle), findsOneWidget);
      expect(find.text(l.addToCalendar), findsOneWidget);
      expect(find.text(l.directions), findsOneWidget);
      await tester.scrollUntilVisible(find.text(l.cancelBooking), 200, scrollable: find.byType(Scrollable).first);
      expect(find.textContaining('Free changes until'), findsOneWidget);

      await tester.tap(find.text(l.cancelBooking));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.confirm));
      await tester.pumpAndSettle();
      expect(api.sent('POST', '/customer/bookings/$bookingId/cancel').single.idempotencyKey, isNotNull);
    });

    testWidgets('someone else’s booking reads as not found', (tester) async {
      final api = salonApi()..on('GET /customer/bookings/$bookingId', (_) => FakeResponse.error(404, 'NOT_FOUND'));
      await pumpApp(tester, api: api, location: '/booking/$bookingId');
      expect(find.text(sb.errorNotFound), findsOneWidget);
    });

    testWidgets('rate your visit: requires stars, then sends rating and comment once', (tester) async {
      final api = salonApi()
        ..json('GET /customer/bookings/$bookingId', bookingJson(status: 'completed', canChange: false, canReview: true))
        ..on('POST /customer/bookings/$bookingId/review', (_) => const FakeResponse(201, {'success': true, 'message': 'ok', 'data': {'id': 'R1', 'rating': 4, 'comment': 'Great'}, 'meta': <String, Object?>{}}));
      await pumpApp(tester, api: api, location: '/booking/$bookingId');

      await tester.scrollUntilVisible(find.text(l.rateVisit), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(l.rateVisit));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.ratingSubmit));
      await tester.pumpAndSettle();
      expect(find.text(l.ratingRequired), findsOneWidget);

      await tester.tap(find.byTooltip(l.starsLabel(4)));
      await tester.enterText(find.byType(TextField), 'Great');
      await tester.tap(find.text(l.ratingSubmit));
      await tester.pumpAndSettle();
      final sent = api.sent('POST', '/customer/bookings/$bookingId/review').single;
      expect(sent.body, {'rating': 4, 'comment': 'Great'});
      expect(sent.idempotencyKey, isNotNull);
    });
  });

  group('profile', () {
    testWidgets('notification switches save, and revert when the server refuses', (tester) async {
      var fail = false;
      final api = salonApi()
        ..json('GET /customer/me/notification-preferences', {'booking_updates': true, 'reminders': true, 'offers': false})
        ..on('PUT /customer/me/notification-preferences', (r) => fail ? FakeResponse.error(503, 'SERVICE_UNAVAILABLE') : FakeResponse.ok(r.body));
      await pumpApp(tester, api: api, location: '/profile/notifications');

      await tester.tap(find.text(l.notifyOffers));
      await tester.pumpAndSettle();
      expect((api.sent('PUT', '/customer/me/notification-preferences').last.body! as Map)['offers'], true);

      fail = true;
      await tester.tap(find.text(l.notifyReminders));
      await tester.pumpAndSettle();
      final reminders = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, l.notifyReminders));
      expect(reminders.value, isTrue); // reverted
      expect(find.text(sb.errorServiceUnavailable), findsOneWidget);
    });

    testWidgets('deleting the account asks first, then signs out to the login screen', (tester) async {
      final api = salonApi()..on('POST /customer/me/deletion-request', (_) => const FakeResponse(202, {'success': true, 'message': 'ok', 'data': null, 'meta': <String, Object?>{}}));
      await pumpApp(tester, api: api, location: '/profile');

      await tester.scrollUntilVisible(find.text(l.deleteAccount), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(l.deleteAccount));
      await tester.pumpAndSettle();
      expect(find.text(l.deleteAccountTitle), findsOneWidget);
      await tester.tap(find.text(l.deleteAccountConfirm));
      await tester.pumpAndSettle();

      expect(api.sent('POST', '/customer/me/deletion-request').single.idempotencyKey, isNotNull);
      expect(find.byType(TextField), findsOneWidget); // phone sign-in
    });
  });

  testWidgets('offline: a timeout on the slots call shows a retry, and retry recovers', (tester) async {
    var calls = 0;
    final api = salonApi()
      ..on('GET /branches/$branchId/slots', (_) {
        calls++;
        if (calls == 1) throw DioException.connectionTimeout(timeout: const Duration(seconds: 10), requestOptions: RequestOptions());
        return FakeResponse.ok(slotsJson());
      });
    await pumpApp(tester, api: api);
    await tester.tap(find.text(l.tabBook));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Haircut'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(sb.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(sb.continueLabel));
    await tester.pumpAndSettle();

    expect(find.text(sb.errorNetworkTimeout), findsOneWidget);
    await tester.tap(find.text(sb.retry));
    await tester.pumpAndSettle();
    expect(find.text('14:00'), findsOneWidget);
  });
}
