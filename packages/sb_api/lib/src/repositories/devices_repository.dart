import 'package:dio/dio.dart';
import 'package:sb_core/sb_core.dart';

/// Push token registration. Staff devices go under /staff so they carry the token's salon.
class DevicesRepository {
  const new(this._dio, {required this.isStaffApp});

  final Dio _dio;
  final bool isStaffApp;

  String get _base => isStaffApp ? '/staff/devices' : '/devices';

  Future<Result<void>> register({required String fcmToken, required String platform, required String locale, String? appVersion}) =>
      Result.guard(() async {
        await _dio.post<dynamic>(
          _base,
          data: {
            'fcm_token': fcmToken,
            'platform': platform,
            'app': isStaffApp ? 'staff' : 'customer',
            'locale': locale,
            'app_version': ?appVersion,
          },
        );
      });

  Future<Result<void>> unregister(String fcmToken) => Result.guard(() async {
    await _dio.delete<dynamic>('$_base/${Uri.encodeComponent(fcmToken)}');
  });
}
