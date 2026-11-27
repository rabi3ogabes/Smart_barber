import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/customer_account.dart';
import 'package:sb_core/sb_core.dart';

/// Customer phone sign-in and profile (api-map.md, Phase 1).
class CustomerAuthRepository {
  /// [_api] is the authenticated client; [_bare] has no auth interceptor (sign-in, refresh).
  const new({required this._api, required this._bare});

  final Dio _api;
  final Dio _bare;

  Future<Result<OtpSent>> requestOtp(String phone) => Result.guard(() async {
    final res = await _bare.post<dynamic>('/customer/auth/otp', data: {'phone': phone});
    return OtpSent.fromJson(envelopeData(res));
  });

  Future<Result<CustomerSignIn>> verifyOtp({required String phone, required String code, required String deviceName}) =>
      Result.guard(() async {
        final res = await _bare.post<dynamic>(
          '/customer/auth/otp/verify',
          data: {'phone': phone, 'code': code, 'device_name': deviceName},
        );
        final data = envelopeData(res);
        return CustomerSignIn(
          tokens: AuthTokens.fromJson((data['tokens']! as Map).cast<String, Object?>()),
          account: CustomerAccount.fromJson((data['account']! as Map).cast<String, Object?>()),
          isNew: data['is_new'] == true,
        );
      });

  /// Used by the auth interceptor; throws on failure so the interceptor can decide.
  Future<AuthTokens> refresh(String refreshToken) async {
    final res = await _bare.post<dynamic>('/customer/auth/refresh', data: {'refresh_token': refreshToken});
    return AuthTokens.fromJson((envelopeData(res)['tokens']! as Map).cast<String, Object?>());
  }

  Future<Result<CustomerAccount>> me() => Result.guard(() async {
    return CustomerAccount.fromJson(envelopeData(await _api.get<dynamic>('/customer/me')));
  });

  Future<Result<CustomerAccount>> updateProfile({String? name, String? email, String? locale}) => Result.guard(() async {
    final res = await _api.patch<dynamic>(
      '/customer/me',
      data: {'name': ?name, 'email': ?email, 'locale': ?locale},
    );
    return CustomerAccount.fromJson(envelopeData(res));
  });

  Future<Result<void>> logout() => Result.guard(() async {
    await _api.post<dynamic>('/customer/auth/logout');
  });
}
