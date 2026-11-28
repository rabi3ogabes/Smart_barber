import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fixtures.dart';

/// Goldens for the Phase 5 screens (also the report's screenshots). Regenerate with
/// `flutter test --update-goldens test/screens_golden_test.dart`.
void main() {
  Future<void> capture(WidgetTester tester, String name, {required Locale locale, String? location, bool salonChosen = true, Brightness? dark}) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final api = salonApi()
      ..json('GET /customer/home', homeJson(next: bookingJson(), reviewPrompt: true))
      ..json('GET /customer/bookings/$bookingId', bookingJson(status: 'completed', canChange: false, canReview: true))
      ..json('GET /customer/me/notification-preferences', {'booking_updates': true, 'reminders': true, 'offers': false});
    await tester.pumpWidget(await appWith(api, locale: locale, salonChosen: salonChosen));
    await tester.pumpAndSettle();
    if (location != null) {
      routerOf(tester).go(location);
      await tester.pumpAndSettle();
    }
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
  }

  testWidgets('home ar', (t) => capture(t, 'home_ar', locale: const Locale('ar')));
  testWidgets('home en', (t) => capture(t, 'home_en', locale: const Locale('en')));
  testWidgets('salon entry ar', (t) => capture(t, 'salon_entry_ar', locale: const Locale('ar'), salonChosen: false));
  testWidgets('booking detail en', (t) => capture(t, 'booking_detail_en', locale: const Locale('en'), location: '/booking/$bookingId'));
  testWidgets('booking detail ar', (t) => capture(t, 'booking_detail_ar', locale: const Locale('ar'), location: '/booking/$bookingId'));
  testWidgets('profile en', (t) => capture(t, 'profile_en', locale: const Locale('en'), location: '/profile'));
}
