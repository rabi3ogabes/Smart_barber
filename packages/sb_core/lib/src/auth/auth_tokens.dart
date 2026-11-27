import 'package:meta/meta.dart';

/// Access + refresh token pair returned by every sign-in and refresh (ADR-002).
@immutable
class AuthTokens {
  const new({required this.accessToken, required this.refreshToken, required this.accessExpiresAt});

  /// Parses the API `tokens` object.
  factory fromJson(Map<String, Object?> json, {DateTime? now}) {
    final issued = now ?? DateTime.now();
    return AuthTokens(
      accessToken: json['access_token']! as String,
      refreshToken: json['refresh_token']! as String,
      accessExpiresAt: issued.add(Duration(seconds: (json['expires_in']! as num).toInt())),
    );
  }

  /// Parses the stored form.
  factory fromStorage(Map<String, Object?> json) => AuthTokens(
    accessToken: json['access']! as String,
    refreshToken: json['refresh']! as String,
    accessExpiresAt: DateTime.parse(json['expires_at']! as String),
  );

  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiresAt;

  /// True a little before expiry so the request does not race the deadline.
  bool isAccessExpired([DateTime? now]) =>
      (now ?? DateTime.now()).isAfter(accessExpiresAt.subtract(const Duration(seconds: 30)));

  /// Storage form.
  Map<String, Object?> toStorage() => {
    'access': accessToken,
    'refresh': refreshToken,
    'expires_at': accessExpiresAt.toIso8601String(),
  };
}
