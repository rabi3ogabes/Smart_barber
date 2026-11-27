import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:smartbarber_staff/app/session.dart';
import 'package:smartbarber_staff/features/shell/placeholder_tabs.dart';
import 'package:smartbarber_staff/features/shell/staff_shell.dart';

import 'helpers.dart';

/// Shell goldens in AR-RTL and EN-LTR, light and dark. Regenerate on Linux with --update-goldens.
void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final brightness in Brightness.values) {
      final name = '${locale.languageCode}_${brightness.name}';
      testWidgets('staff shell $name', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final overrides = [...await baseOverrides(locale: locale.languageCode), staffSessionProvider.overrideWith(SignedInStaffSession.new)];
        final router = GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => StaffShell(currentIndex: 0, onSelect: (_) {}, child: const TodayTab()))],
        );
        await tester.pumpWidget(testApp(overrides: overrides, router: router, locale: locale, brightness: brightness));
        await tester.pumpAndSettle();

        await expectLater(find.byType(StaffShell), matchesGoldenFile('goldens/staff_shell_$name.png'));
      });
    }
  }
}
