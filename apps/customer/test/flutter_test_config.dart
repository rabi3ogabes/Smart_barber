import 'dart:async';

import 'package:sb_ui/testing.dart';

/// Loads real fonts so goldens show Arabic and Latin glyphs, not boxes.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadSbTestFonts();
  await testMain();
}
