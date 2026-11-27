import 'package:dio/dio.dart';
import 'package:sb_core/sb_core.dart';

/// Reads `data` from the success envelope `{success, message, data, meta}`.
Map<String, Object?> envelopeData(Response<dynamic> response) {
  final body = response.data;
  if (body is! Map || body['success'] != true) {
    throw const UnknownFailure('Unexpected response shape');
  }
  final data = body['data'];
  return data is Map ? data.cast<String, Object?>() : <String, Object?>{};
}

/// Reads `data` when it is a list.
List<Map<String, Object?>> envelopeList(Response<dynamic> response) {
  final body = response.data;
  final data = body is Map ? body['data'] : null;
  if (data is! List) throw const UnknownFailure('Unexpected response shape');
  return data.whereType<Map<dynamic, dynamic>>().map((m) => m.cast<String, Object?>()).toList();
}

/// Options for sign-in style calls that must not carry an access token.
final Options noAuth = Options(extra: {AuthInterceptor.authExtra: false});
