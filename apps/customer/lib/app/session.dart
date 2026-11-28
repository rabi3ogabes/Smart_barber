import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_customer/app/providers.dart';

part 'session.g.dart';

sealed class CustomerSessionState {
  const new();
}

final class SignedOut extends CustomerSessionState {
  const new({this.expired = false});

  /// True when the server ended the session (shown as a message on the sign-in screen).
  final bool expired;
}

final class SignedIn extends CustomerSessionState {
  const new(this.account);

  final CustomerAccount account;
}

/// Restores the session at start-up and tracks sign-in / sign-out.
///
/// The last profile is cached so the app opens offline with the "offline" banner (flutter.md, Offline).
@Riverpod(keepAlive: true)
class CustomerSession extends _$CustomerSession {
  static const _cacheKey = 'sb.customer.account';

  @override
  Future<CustomerSessionState> build() async {
    final tokens = await ref.read(tokenStoreProvider).read();
    if (tokens == null) return const SignedOut();

    final result = await ref.read(customerAuthRepositoryProvider).me();
    switch (result) {
      case Ok(:final value):
        await _cache(value);
        return SignedIn(value);
      case Err(:final failure):
        if (failure is ApiFailure && (failure.endsSession || failure.status == 401)) {
          await ref.read(tokenStoreProvider).clear();
          return const SignedOut(expired: true);
        }
        final cached = _cached();
        return cached == null ? const SignedOut() : SignedIn(cached);
    }
  }

  Future<void> signedIn(CustomerSignIn signIn) async {
    await ref.read(tokenStoreProvider).write(signIn.tokens);
    await _cache(signIn.account);
    state = AsyncData(SignedIn(signIn.account));
  }

  Future<void> logout() async {
    await ref.read(customerAuthRepositoryProvider).logout(); // best effort; local sign-out always happens
    await ref.read(tokenStoreProvider).clear();
    state = const AsyncData(SignedOut());
  }

  /// Replaces the cached profile after an edit (name, photo).
  Future<void> updated(CustomerAccount account) async {
    await _cache(account);
    state = AsyncData(SignedIn(account));
  }

  /// After the server deleted the account: tokens are already revoked there, so only clear locally.
  Future<void> accountDeleted() async {
    await ref.read(tokenStoreProvider).clear();
    await ref.read(preferencesProvider).remove(_cacheKey);
    state = const AsyncData(SignedOut());
  }

  /// Called by the auth interceptor when the refresh token is no longer valid.
  void expired() => state = const AsyncData(SignedOut(expired: true));

  Future<void> _cache(CustomerAccount account) =>
      ref.read(preferencesProvider).setString(_cacheKey, jsonEncode(account.toJson()));

  CustomerAccount? _cached() {
    final raw = ref.read(preferencesProvider).getString(_cacheKey);
    if (raw == null) return null;
    try {
      return CustomerAccount.fromJson((jsonDecode(raw) as Map).cast<String, Object?>());
    } on Object {
      return null;
    }
  }
}
