/// Test helpers for golden and widget tests in the apps and packages.
library;

import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';

/// Loads the bundled brand fonts and Material Icons so goldens show real glyphs.
Future<void> loadSbTestFonts() async {
  const fonts = {
    'packages/sb_ui/${SbFonts.sansLatin}': ['Inter-Variable.ttf'],
    'packages/sb_ui/${SbFonts.displayLatin}': ['Fraunces-Variable.ttf'],
    'packages/sb_ui/${SbFonts.sansArabic}': [
      'IBMPlexSansArabic-Regular.ttf',
      'IBMPlexSansArabic-Medium.ttf',
      'IBMPlexSansArabic-SemiBold.ttf',
    ],
  };
  for (final MapEntry(key: family, value: files) in fonts.entries) {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(_bytes(['packages/sb_ui/assets/fonts/$file', 'assets/fonts/$file'], 'assets/fonts/$file'));
    }
    await loader.load();
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final icons = FontLoader('MaterialIcons')
    ..addFont(_bytes(['fonts/MaterialIcons-Regular.otf'], '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

Future<ByteData> _bytes(List<String> assetKeys, String filePath) async {
  for (final key in assetKeys) {
    try {
      return await rootBundle.load(key);
    } on Object {
      // Try the next location.
    }
  }
  for (final path in [filePath, '../../packages/sb_ui/$filePath']) {
    final file = File(path);
    if (file.existsSync()) return ByteData.sublistView(file.readAsBytesSync());
  }
  throw StateError('Font not found: $filePath');
}

/// Wraps [child] in a themed, localised app for widget tests.
Widget sbTestApp({
  required Widget child,
  Locale locale = const Locale('ar'),
  Brightness brightness = Brightness.light,
  List<LocalizationsDelegate<dynamic>> extraDelegates = const [],
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: locale,
    supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: [
      ...extraDelegates,
      SbLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: SbTheme.build(brightness, languageCode: locale.languageCode),
    home: child,
  );
}
