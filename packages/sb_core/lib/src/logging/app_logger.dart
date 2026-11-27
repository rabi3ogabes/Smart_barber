import 'package:flutter/foundation.dart';

/// Minimal logger that never prints tokens, codes or phone numbers.
abstract final class AppLogger {
  static final _secrets = RegExp(r'(Bearer\s+)\S+|("?(?:access_token|refresh_token|code|challenge_token|selection_token)"?\s*[:=]\s*"?)[^",\s}]+');

  static void info(String message) {
    if (kDebugMode) debugPrint('[sb] ${redact(message)}');
  }

  static void error(String message, [Object? error]) {
    if (kDebugMode) debugPrint('[sb][error] ${redact(message)} ${error == null ? '' : redact('$error')}');
  }

  /// Removes secrets from a string.
  static String redact(String input) => input.replaceAllMapped(_secrets, (m) => '${m[1] ?? m[2]}***');
}
