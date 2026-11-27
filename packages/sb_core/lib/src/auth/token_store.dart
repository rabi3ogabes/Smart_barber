import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sb_core/src/auth/auth_tokens.dart';

/// Where tokens live. Tokens are only ever kept in secure storage (flutter.md, Storage).
abstract interface class TokenStore {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

/// Keychain / Keystore backed store.
class SecureTokenStore implements TokenStore {
  new({FlutterSecureStorage? storage, this.key = 'sb.auth.tokens'})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Storage key (each app uses its own).
  final String key;

  AuthTokens? _cache;

  @override
  Future<AuthTokens?> read() async {
    if (_cache != null) return _cache;
    final raw = await _storage.read(key: key);
    if (raw == null) return null;
    try {
      return _cache = AuthTokens.fromStorage((jsonDecode(raw) as Map).cast<String, Object?>());
    } on Object {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    _cache = tokens;
    await _storage.write(key: key, value: jsonEncode(tokens.toStorage()));
  }

  @override
  Future<void> clear() async {
    _cache = null;
    await _storage.delete(key: key);
  }
}

/// In-memory store for tests.
class MemoryTokenStore implements TokenStore {
  new([this._tokens]);

  AuthTokens? _tokens;

  @override
  Future<AuthTokens?> read() async => _tokens;

  @override
  Future<void> write(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
