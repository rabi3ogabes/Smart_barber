import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/flows/booking_flow.dart';

/// The full booking on a device or emulator, in Arabic and English, against the scripted API used
/// by the widget tests (no network, deterministic clock):
///   `flutter test integration_test/booking_flow_test.dart -d <device>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in const [Locale('ar'), Locale('en')]) {
    testWidgets('books end to end in ${locale.languageCode}', (tester) async {
      await runBookingFlow(tester, locale);
    });
  }

  testWidgets('a network error on confirm retries with the same idempotency key', runRetryKeepsKey);
}
