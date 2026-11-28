import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/shell/customer_shell.dart';
import 'package:smartbarber_customer/features/shell/placeholder_tabs.dart';

import 'helpers.dart';

/// Shell goldens in AR-RTL and EN-LTR, light and dark (flutter.md, Quality).
/// Regenerate with `flutter test --update-goldens test/shell_golden_test.dart` (on Linux, like CI).
void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final brightness in Brightness.values) {
      final name = '${locale.languageCode}_${brightness.name}';
      testWidgets('customer shell $name', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final overrides = [...await baseOverrides(), customerSessionProvider.overrideWith(SignedInSession.new)];
        final router = GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => CustomerShell(currentIndex: 0, onSelect: (_) {}, child: const AiStudioTab()))],
        );

        await tester.pumpWidget(testApp(overrides: overrides, router: router, locale: locale, brightness: brightness));
        await tester.pumpAndSettle();

        await expectLater(find.byType(CustomerShell), matchesGoldenFile('goldens/customer_shell_$name.png'));
      });
    }
  }
}
