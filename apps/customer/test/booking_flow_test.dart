import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'flows/booking_flow.dart';

void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    testWidgets('books end to end in ${locale.languageCode}, recovering from a taken slot', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await runBookingFlow(tester, locale);
    });
  }

  testWidgets('a network error on confirm retries with the same idempotency key', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await runRetryKeepsKey(tester);
  });
}
