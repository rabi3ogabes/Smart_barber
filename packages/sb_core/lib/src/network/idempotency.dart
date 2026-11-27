import 'dart:math';

import 'package:dio/dio.dart';

/// Idempotency keys (rule 6, ADR-006).
///
/// A key is created once per user intent — when the user taps Confirm — and passed with
/// every retry of that intent, so a retried booking or payment is never applied twice.
abstract final class Idempotency {
  /// `Options.extra` key read by [IdempotencyInterceptor].
  static const extraKey = 'sb.idempotency_key';

  static final Random _random = Random.secure();

  /// A random UUID v4.
  static String newKey() {
    final b = List<int>.generate(16, (_) => _random.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }

  /// Request options carrying [key].
  static Options options(String key, [Options? base]) =>
      (base ?? Options()).copyWith(extra: {...?base?.extra, extraKey: key});
}

/// Adds the `Idempotency-Key` header when the request carries a key.
class IdempotencyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = options.extra[Idempotency.extraKey];
    if (key is String && key.isNotEmpty) {
      options.headers['Idempotency-Key'] = key;
    }
    handler.next(options);
  }
}
