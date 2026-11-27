import 'package:dio/dio.dart';
import 'package:sb_core/src/auth/token_store.dart';
import 'package:sb_core/src/env/app_env.dart';
import 'package:sb_core/src/network/auth_interceptor.dart';
import 'package:sb_core/src/network/idempotency.dart';
import 'package:sb_core/src/network/locale_interceptor.dart';
import 'package:sb_core/src/network/retry_interceptor.dart';

/// Builds the app's Dio with every interceptor in a fixed order (flutter.md, Networking).
abstract final class ApiClient {
  /// The authenticated client used by repositories.
  static Dio create({
    required AppEnv env,
    required TokenStore tokenStore,
    required TokenRefresher refresher,
    required String Function() languageCode,
    required void Function() onSessionExpired,
    HttpClientAdapter? adapter,
    List<Duration>? retryDelays,
  }) {
    final dio = bare(env: env, languageCode: languageCode, adapter: adapter);
    // Replays after a refresh go through a separate client: replaying through the queued
    // AuthInterceptor itself could deadlock if the replay fails again.
    final replay = bare(env: env, languageCode: languageCode, adapter: adapter);
    dio.interceptors.addAll([
      IdempotencyInterceptor(),
      AuthInterceptor(store: tokenStore, refresher: refresher, dio: replay, onSessionExpired: onSessionExpired),
      if (retryDelays == null) RetryInterceptor(dio) else RetryInterceptor(dio, delays: retryDelays),
    ]);
    return dio;
  }

  /// A client without auth, used for sign-in and token refresh.
  static Dio bare({required AppEnv env, required String Function() languageCode, HttpClientAdapter? adapter}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );
    if (adapter != null) dio.httpClientAdapter = adapter;
    dio.interceptors.add(LocaleInterceptor(languageCode));
    return dio;
  }
}
