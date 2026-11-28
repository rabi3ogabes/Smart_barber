import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/salon.dart';
import 'package:sb_core/sb_core.dart';

/// Finding and reading salons (public endpoints, plus "my salons").
class SalonRepository {
  const new(this._api);

  final Dio _api;

  /// QR code, deep link or typed code → salon. Unknown codes fail with `INVALID_SALON_CODE`.
  Future<Result<SalonCard>> resolve(String code) => Result.guard(() async {
    return SalonCard.fromJson(envelopeData(await _api.get<dynamic>('/salons/resolve', queryParameters: {'code': code})));
  });

  /// Name search; only salons that opted into the listing are returned.
  Future<Result<List<SalonCard>>> search(String query) => Result.guard(() async {
    return envelopeList(await _api.get<dynamic>('/salons/search', queryParameters: {'q': query})).map(SalonCard.fromJson).toList();
  });

  /// Salons this account has booked with, most recent first.
  Future<Result<List<SalonCard>>> mine() => Result.guard(() async {
    return envelopeList(await _api.get<dynamic>('/customer/salons')).map(SalonCard.fromJson).toList();
  });

  Future<Result<List<SalonBranch>>> branches(String salon) => Result.guard(() async {
    return envelopeList(await _api.get<dynamic>('/salons/${Uri.encodeComponent(salon)}/branches')).map(SalonBranch.fromJson).toList();
  });

  /// Branch with weekly hours and upcoming closures.
  Future<Result<SalonBranch>> branch(String id) => Result.guard(() async {
    return SalonBranch.fromJson(envelopeData(await _api.get<dynamic>('/branches/${Uri.encodeComponent(id)}')));
  });
}
