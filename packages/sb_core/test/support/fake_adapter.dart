import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Scripted HTTP adapter: each request is answered by [handler]; requests are recorded.
class FakeAdapter implements HttpClientAdapter {
  new(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

Map<String, Object?> ok([Object? data]) => {'success': true, 'message': 'OK', 'data': data ?? <String, Object?>{}, 'meta': <String, Object?>{}};

Map<String, Object?> apiError(String code, {Map<String, Object?> errors = const {}, Map<String, Object?>? data}) => {
  'success': false,
  'message': 'msg $code',
  'code': code,
  'errors': errors,
  'data': ?data,
};
