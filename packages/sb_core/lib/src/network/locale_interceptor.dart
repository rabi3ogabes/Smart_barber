import 'package:dio/dio.dart';

/// Sends the app language so server messages come back translated (API conventions).
class LocaleInterceptor extends Interceptor {
  new(this.languageCode);

  /// Current language code (`ar` or `en`).
  final String Function() languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = languageCode();
    handler.next(options);
  }
}
