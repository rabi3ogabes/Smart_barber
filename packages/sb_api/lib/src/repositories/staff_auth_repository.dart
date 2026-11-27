import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/staff.dart';
import 'package:sb_core/sb_core.dart';

/// Staff sign-in: password → 2FA → salon selection → salon-bound tokens (ADR-002).
class StaffAuthRepository {
  const new({required this._api, required this._bare});

  final Dio _api;
  final Dio _bare;

  Future<Result<StaffLoginStep>> login({required String email, required String password, required String deviceName}) =>
      _step(() => _bare.post<dynamic>('/staff/auth/login', data: {'email': email, 'password': password, 'device_name': deviceName}));

  Future<Result<StaffLoginStep>> verifyTwoFactor({required String challengeToken, required String code}) =>
      _step(() => _bare.post<dynamic>('/staff/auth/2fa', data: {'challenge_token': challengeToken, 'code': code}));

  Future<Result<StaffLoginStep>> selectSalon({required String selectionToken, required String salonId}) =>
      _step(() => _bare.post<dynamic>('/staff/auth/select-salon', data: {'selection_token': selectionToken, 'salon': salonId}));

  /// Used by the auth interceptor; throws on failure.
  Future<AuthTokens> refresh(String refreshToken) async {
    final res = await _bare.post<dynamic>('/staff/auth/refresh', data: {'refresh_token': refreshToken});
    return AuthTokens.fromJson((envelopeData(res)['tokens']! as Map).cast<String, Object?>());
  }

  Future<Result<StaffMe>> me() => Result.guard(() async => StaffMe.fromJson(envelopeData(await _api.get<dynamic>('/staff/me'))));

  Future<Result<List<MembershipOption>>> salons() => Result.guard(() async {
    return envelopeList(await _api.get<dynamic>('/staff/me/salons')).map(MembershipOption.fromJson).toList();
  });

  Future<Result<void>> logout() => Result.guard(() async {
    await _api.post<dynamic>('/staff/auth/logout');
  });

  /// The API answers the 2FA and salon-selection steps with 409 envelopes; they are steps, not errors.
  Future<Result<StaffLoginStep>> _step(Future<Response<dynamic>> Function() call) async {
    final result = await Result.guard(() async {
      final data = envelopeData(await call());
      return StaffSignedIn(
        tokens: AuthTokens.fromJson((data['tokens']! as Map).cast<String, Object?>()),
        salonId: data['salon']! as String,
      );
    });

    final failure = result.failureOrNull;
    if (failure is ApiFailure) {
      if (failure.code == ApiErrorCode.twoFactorRequired && failure.data['challenge_token'] is String) {
        return Ok(StaffTwoFactorRequired(failure.data['challenge_token']! as String));
      }
      if (failure.code == ApiErrorCode.salonSelectionRequired && failure.data['selection_token'] is String) {
        final options = (failure.data['memberships'] as List? ?? const [])
            .whereType<Map<dynamic, dynamic>>()
            .map((m) => MembershipOption.fromJson(m.cast<String, Object?>()))
            .toList();
        return Ok(StaffSalonSelectionRequired(selectionToken: failure.data['selection_token']! as String, memberships: options));
      }
    }

    return switch (result) {
      Ok(:final value) => Ok(value),
      Err(:final failure) => Err(failure),
    };
  }
}
