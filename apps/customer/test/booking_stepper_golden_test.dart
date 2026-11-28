import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

import 'fixtures.dart';

/// Booking stepper goldens in AR-RTL and EN-LTR: the services step and the summary with the
/// server quote. Regenerate with `flutter test --update-goldens test/booking_stepper_golden_test.dart`.
void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    final l = lookupAppLocalizations(locale);
    final sb = lookupSbLocalizations(locale);
    final ar = locale.languageCode == 'ar';

    testWidgets('booking stepper ${locale.languageCode}', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(await appWith(salonApi(), locale: locale));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.tabBook));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ar ? 'قص الشعر' : 'Haircut'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ar ? 'تدريج · +QAR 15.00' : 'Skin fade · +QAR 15.00'));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/booking_services_${locale.languageCode}.png'));

      await tester.tap(find.text(sb.continueLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ar ? 'يوسف' : 'Yousef'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(sb.continueLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text('14:30'));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/booking_time_${locale.languageCode}.png'));

      await tester.tap(find.text(sb.continueLabel));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/booking_summary_${locale.languageCode}.png'));
    });
  }
}
