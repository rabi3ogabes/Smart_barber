import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sb_core/sb_core.dart';

/// One recorded request.
class FakeRequest {
  const new(this.method, this.path, this.query, this.body, this.headers);

  final String method;
  final String path;
  final Map<String, dynamic> query;
  final Object? body;
  final Map<String, dynamic> headers;

  String? get idempotencyKey => headers['Idempotency-Key'] as String?;
}

/// A canned answer: status + body (`data` is wrapped in the success envelope when ok).
class FakeResponse {
  const new(this.status, this.body);

  factory ok(Object? data, {Map<String, Object?>? meta}) =>
      FakeResponse(200, {'success': true, 'message': null, 'data': data, 'meta': meta ?? <String, Object?>{}});

  factory error(int status, String code, {Map<String, Object?> data = const {}, String? message}) =>
      FakeResponse(status, {'success': false, 'code': code, 'message': message, 'errors': <String, Object?>{}, 'data': data});

  final int status;
  final Object? body;
}

typedef FakeHandler = FakeResponse Function(FakeRequest request);

/// Serves the API from a map of `"METHOD /path"` → handler, so tests run the real repositories and
/// JSON parsing. Unknown routes answer 404 and are listed in [unmatched].
class FakeApi implements HttpClientAdapter {
  final Map<String, FakeHandler> routes = {};
  final List<FakeRequest> requests = [];
  final List<String> unmatched = [];

  void on(String route, FakeHandler handler) => routes[route] = handler;

  void json(String route, Object? data, {Map<String, Object?>? meta}) => on(route, (_) => FakeResponse.ok(data, meta: meta));

  Iterable<FakeRequest> sent(String method, String path) => requests.where((r) => r.method == method && r.path == path);

  Dio dio() => Dio(BaseOptions(baseUrl: 'http://api.test/api/v1'))
    ..httpClientAdapter = this
    ..interceptors.add(IdempotencyInterceptor());

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final path = options.uri.path.replaceFirst('/api/v1', '');
    final request = FakeRequest(options.method, path, options.uri.queryParametersAll.map((k, v) => MapEntry(k, v.length == 1 ? v.first : v)), options.data, options.headers);
    requests.add(request);
    final handler = routes['${options.method} $path'];
    if (handler == null) unmatched.add('${options.method} $path');
    final response = handler?.call(request) ?? FakeResponse.error(404, 'NOT_FOUND');
    if (response.body is List<int>) {
      return ResponseBody.fromBytes(response.body! as List<int>, response.status, headers: {'content-type': ['text/calendar']});
    }
    return ResponseBody.fromString(jsonEncode(response.body), response.status, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
  }

  @override
  void close({bool force = false}) {}
}
