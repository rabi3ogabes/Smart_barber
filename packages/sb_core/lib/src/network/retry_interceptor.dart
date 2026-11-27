import 'package:dio/dio.dart';

/// Retries idempotent reads (GET/HEAD) on network errors and 502/503/504 with backoff.
/// Writes are never retried automatically; the user retries with the same idempotency key.
class RetryInterceptor extends Interceptor {
  new(this._dio, {this.delays = const [Duration(milliseconds: 300), Duration(milliseconds: 900)]});

  final Dio _dio;

  /// Delay before each retry; its length is the maximum number of retries.
  final List<Duration> delays;

  static const _attemptKey = 'sb.retry_attempt';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;

    if (!_isRetryable(err) || attempt >= delays.length) {
      return handler.next(err);
    }

    await Future<void>.delayed(delays[attempt]);
    options.extra[_attemptKey] = attempt + 1;

    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isRetryable(DioException err) {
    final method = err.requestOptions.method.toUpperCase();
    if (method != 'GET' && method != 'HEAD') return false;

    return switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.badResponse => const {502, 503, 504}.contains(err.response?.statusCode),
      _ => false,
    };
  }
}
