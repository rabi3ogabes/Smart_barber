import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/customer_account.dart';
import 'package:sb_api/src/models/home.dart';
import 'package:sb_core/sb_core.dart';

/// Home screen data and the account settings that are not sign-in.
class CustomerHomeRepository {
  const new(this._api);

  final Dio _api;

  Future<Result<CustomerHome>> home(String salon, {String? branch}) => Result.guard(() async {
    return CustomerHome.fromJson(envelopeData(await _api.get<dynamic>('/customer/home', queryParameters: {'salon': salon, 'branch': ?branch})));
  });

  /// Uploads a new photo; the server resizes it in the background.
  Future<Result<CustomerAccount>> uploadAvatar(Uint8List bytes, String filename) => Result.guard(() async {
    final form = FormData.fromMap({'avatar': MultipartFile.fromBytes(bytes, filename: filename)});
    return CustomerAccount.fromJson(envelopeData(await _api.post<dynamic>('/customer/me/avatar', data: form)));
  });

  Future<Result<NotificationPreferences>> notificationPreferences() => Result.guard(() async {
    return NotificationPreferences.fromJson(envelopeData(await _api.get<dynamic>('/customer/me/notification-preferences')));
  });

  Future<Result<NotificationPreferences>> saveNotificationPreferences(NotificationPreferences prefs) => Result.guard(() async {
    return NotificationPreferences.fromJson(envelopeData(await _api.put<dynamic>('/customer/me/notification-preferences', data: prefs.toJson())));
  });

  /// Store-compliant account deletion. The server signs the account out everywhere.
  Future<Result<void>> requestDeletion({required String idempotencyKey, String? reason}) => Result.guard(() async {
    await _api.post<dynamic>('/customer/me/deletion-request', data: {'reason': ?reason}, options: Idempotency.options(idempotencyKey));
  });
}
