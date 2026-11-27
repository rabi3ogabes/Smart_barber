import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sb_core/src/auth/auth_tokens.dart';
import 'package:sb_core/src/auth/token_store.dart';
import 'package:sb_core/src/failures/app_failure.dart';

/// Exchanges a refresh token for new tokens. Implemented per app (customer vs staff endpoint)
/// with a bare Dio that does not run this interceptor.
typedef TokenRefresher = Future<AuthTokens> Function(String refreshToken);

/// Attaches the access token, refreshes it when expired or rejected, and ends the session
/// when the server says the refresh token is no longer valid (ADR-002).
///
/// Concurrent requests share one refresh (single flight), so a rotated refresh token is never
/// sent twice — sending it twice would revoke the whole login.
class AuthInterceptor extends QueuedInterceptor {
  new({
    required this.store,
    required this.refresher,
    required this.dio,
    required this.onSessionExpired,
  });

  /// `Options.extra` flag: set to false for requests that must not carry a token.
  static const authExtra = 'sb.auth';

  static const _retriedExtra = 'sb.auth_retried';

  final TokenStore store;
  final TokenRefresher refresher;

  /// Client used to replay a request after a refresh. Must not contain this interceptor.
  final Dio dio;

  /// Called once the session can no longer be refreshed.
  final void Function() onSessionExpired;

  Future<AuthTokens?>? _refreshing;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[authExtra] == false) return handler.next(options);

    var tokens = await store.read();
    if (tokens != null && tokens.isAccessExpired()) {
      tokens = await _refresh(tokens);
    }
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isAuthError = err.response?.statusCode == 401;

    if (!isAuthError || options.extra[authExtra] == false || options.extra[_retriedExtra] == true) {
      return handler.next(err);
    }

    final current = await store.read();
    if (current == null) return handler.next(err);

    // Another request may already have refreshed while this one was in flight.
    final sent = options.headers['Authorization'];
    final tokens = sent == 'Bearer ${current.accessToken}' ? await _refresh(current) : current;
    if (tokens == null) return handler.next(err);

    options
      ..headers['Authorization'] = 'Bearer ${tokens.accessToken}'
      ..extra[_retriedExtra] = true;

    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<AuthTokens?> _refresh(AuthTokens tokens) {
    return _refreshing ??= _doRefresh(tokens).whenComplete(() => _refreshing = null);
  }

  Future<AuthTokens?> _doRefresh(AuthTokens tokens) async {
    try {
      final fresh = await refresher(tokens.refreshToken);
      await store.write(fresh);
      return fresh;
    } on Object catch (error) {
      final failure = AppFailure.from(error);
      // Offline or server hiccup: keep the session; the request fails and can be retried.
      if (failure is ApiFailure && (failure.endsSession || failure.status == 401)) {
        await store.clear();
        onSessionExpired();
      }
      return null;
    }
  }
}
