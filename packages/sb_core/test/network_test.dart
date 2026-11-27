import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_core/sb_core.dart';

import 'support/fake_adapter.dart';

const env = AppEnv(flavor: Flavor.dev, apiBaseUrl: 'http://api.test/api/v1');

AuthTokens tokens(String access, {Duration ttl = const Duration(minutes: 60)}) =>
    AuthTokens(accessToken: access, refreshToken: 'refresh-$access', accessExpiresAt: DateTime.now().add(ttl));

void main() {
  group('LocaleInterceptor', () {
    test('sends the current language', () async {
      final adapter = FakeAdapter((_) async => json(200, ok()));
      var lang = 'ar';
      final dio = ApiClient.bare(env: env, languageCode: () => lang, adapter: adapter);

      await dio.get<dynamic>('/a');
      lang = 'en';
      await dio.get<dynamic>('/a');

      expect(adapter.requests.map((r) => r.headers['Accept-Language']), ['ar', 'en']);
    });
  });

  group('Idempotency', () {
    test('creates RFC 4122 v4 keys', () {
      final key = Idempotency.newKey();
      expect(key, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
      expect(Idempotency.newKey(), isNot(key));
    });

    test('sends the same key on a retry of the same intent', () async {
      var calls = 0;
      final adapter = FakeAdapter((_) async => ++calls == 1 ? json(503, apiError('SERVICE_UNAVAILABLE')) : json(201, ok()));
      final dio = ApiClient.create(
        env: env,
        tokenStore: MemoryTokenStore(tokens('a')),
        refresher: (_) async => throw StateError('no refresh'),
        languageCode: () => 'en',
        onSessionExpired: () {},
        adapter: adapter,
        retryDelays: const [Duration.zero],
      );
      final key = Idempotency.newKey();

      // POST is never retried automatically; the user taps "Try again" with the same key.
      await expectLater(dio.post<dynamic>('/bookings', options: Idempotency.options(key)), throwsA(isA<DioException>()));
      await dio.post<dynamic>('/bookings', options: Idempotency.options(key));

      expect(adapter.requests, hasLength(2));
      expect(adapter.requests.map((r) => r.headers['Idempotency-Key']), [key, key]);
    });
  });

  group('RetryInterceptor', () {
    test('retries GET on 503 with backoff and succeeds', () async {
      var calls = 0;
      final adapter = FakeAdapter((_) async => ++calls < 3 ? json(503, apiError('SERVICE_UNAVAILABLE')) : json(200, ok({'n': calls})));
      final dio = ApiClient.bare(env: env, languageCode: () => 'en', adapter: adapter);
      dio.interceptors.add(RetryInterceptor(dio, delays: const [Duration.zero, Duration.zero]));

      final res = await dio.get<Map<String, dynamic>>('/x');
      expect(res.data!['data'], {'n': 3});
    });

    test('gives up after the configured attempts and never retries POST or 4xx', () async {
      final adapter = FakeAdapter((o) async => o.path == '/bad' ? json(422, apiError('VALIDATION_FAILED')) : json(503, apiError('SERVICE_UNAVAILABLE')));
      final dio = ApiClient.bare(env: env, languageCode: () => 'en', adapter: adapter);
      dio.interceptors.add(RetryInterceptor(dio, delays: const [Duration.zero, Duration.zero]));

      await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
      expect(adapter.requests, hasLength(3));

      adapter.requests.clear();
      await expectLater(dio.post<dynamic>('/x'), throwsA(isA<DioException>()));
      await expectLater(dio.get<dynamic>('/bad'), throwsA(isA<DioException>()));
      expect(adapter.requests, hasLength(2));
    });
  });

  group('AuthInterceptor', () {
    late MemoryTokenStore store;
    late int refreshCalls;
    late int expiredCalls;

    Dio client(FakeAdapter adapter, {Future<AuthTokens> Function(String)? refresher}) => ApiClient.create(
      env: env,
      tokenStore: store,
      refresher: refresher ??
          (refresh) async {
            refreshCalls++;
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return tokens('new');
          },
      languageCode: () => 'en',
      onSessionExpired: () => expiredCalls++,
      adapter: adapter,
      retryDelays: const [],
    );

    setUp(() {
      store = MemoryTokenStore(tokens('old'));
      refreshCalls = 0;
      expiredCalls = 0;
    });

    test('attaches the bearer token', () async {
      final adapter = FakeAdapter((_) async => json(200, ok()));
      await client(adapter).get<dynamic>('/me');
      expect(adapter.requests.single.headers['Authorization'], 'Bearer old');
    });

    test('skips the token when asked', () async {
      final adapter = FakeAdapter((_) async => json(200, ok()));
      await client(adapter).post<dynamic>('/login', options: Options(extra: {AuthInterceptor.authExtra: false}));
      expect(adapter.requests.single.headers.containsKey('Authorization'), isFalse);
    });

    test('refreshes once for concurrent 401s and replays every request', () async {
      final adapter = FakeAdapter(
        (o) async => o.headers['Authorization'] == 'Bearer new' ? json(200, ok({'path': o.path})) : json(401, apiError('UNAUTHENTICATED')),
      );
      final dio = client(adapter);

      final results = await Future.wait([dio.get<Map<String, dynamic>>('/a'), dio.get<Map<String, dynamic>>('/b')]);

      expect(results.map((r) => r.data!['data']), [
        {'path': '/a'},
        {'path': '/b'},
      ]);
      expect(refreshCalls, 1);
      expect((await store.read())!.accessToken, 'new');
    });

    test('refreshes an expired access token before sending', () async {
      store = MemoryTokenStore(tokens('old', ttl: Duration.zero));
      final adapter = FakeAdapter((_) async => json(200, ok()));
      await client(adapter).get<dynamic>('/me');

      expect(refreshCalls, 1);
      expect(adapter.requests.single.headers['Authorization'], 'Bearer new');
    });

    test('ends the session when the refresh token was reused', () async {
      final adapter = FakeAdapter((_) async => json(401, apiError('UNAUTHENTICATED')));
      final refreshAdapter = FakeAdapter((_) async => json(401, apiError('REFRESH_TOKEN_REUSED')));
      final refreshDio = ApiClient.bare(env: env, languageCode: () => 'en', adapter: refreshAdapter);
      final dio = client(
        adapter,
        refresher: (refresh) async {
          await refreshDio.post<dynamic>('/customer/auth/refresh', data: {'refresh_token': refresh});
          return tokens('never');
        },
      );

      final error = await dio.get<dynamic>('/me').then<Object?>((_) => null, onError: (Object e) => e);
      expect(AppFailure.from(error!), isA<ApiFailure>().having((f) => f.code, 'code', 'UNAUTHENTICATED'));
      expect(await store.read(), isNull);
      expect(expiredCalls, 1);
    });

    test('keeps the session when refresh fails because the phone is offline', () async {
      final adapter = FakeAdapter((_) async => json(401, apiError('UNAUTHENTICATED')));
      final dio = client(
        adapter,
        refresher: (_) async => throw DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
      );

      await expectLater(dio.get<dynamic>('/me'), throwsA(isA<DioException>()));
      expect(await store.read(), isNotNull);
      expect(expiredCalls, 0);
    });
  });

  group('AppFailure mapping', () {
    Future<AppFailure> failureFor(Future<ResponseBody> Function(RequestOptions) handler) async {
      final dio = ApiClient.bare(env: env, languageCode: () => 'en', adapter: FakeAdapter(handler));
      final result = await Result.guard(() => dio.get<dynamic>('/x'));
      return result.failureOrNull!;
    }

    test('reads the error envelope', () async {
      final f = await failureFor(
        (_) async => json(422, apiError('VALIDATION_FAILED', errors: {'phone': ['bad']}, data: {'retry_after': 30})),
      );
      expect(f, isA<ApiFailure>());
      f as ApiFailure;
      expect(f.code, 'VALIDATION_FAILED');
      expect(f.status, 422);
      expect(f.message, 'msg VALIDATION_FAILED');
      expect(f.fieldError('phone'), 'bad');
      expect(f.data['retry_after'], 30);
    });

    test('maps non-envelope errors to SERVER_ERROR and connection errors to NetworkFailure', () async {
      final server = await failureFor((_) async => ResponseBody.fromString('<html>oops</html>', 500));
      expect((server as ApiFailure).code, ApiErrorCode.serverError);

      final offline = await failureFor((o) async => throw DioException.connectionError(requestOptions: o, reason: 'down'));
      expect(offline, isA<NetworkFailure>().having((f) => f.issue, 'issue', NetworkIssue.offline));
    });

    test('flags session-ending codes', () {
      expect(const ApiFailure(code: 'REFRESH_TOKEN_REUSED', status: 401).endsSession, isTrue);
      expect(const ApiFailure(code: 'OTP_INVALID', status: 422).endsSession, isFalse);
    });
  });

  group('AppEnv', () {
    test('rejects non-https or foreign hosts for production builds', () {
      expect(() => const AppEnv(flavor: Flavor.prod, apiBaseUrl: 'http://api.smartbarber.app/api/v1').validate(), throwsStateError);
      expect(() => const AppEnv(flavor: Flavor.prod, apiBaseUrl: 'https://staging.smartbarber.app/api/v1').validate(), throwsStateError);
      const AppEnv(flavor: Flavor.prod, apiBaseUrl: 'https://api.smartbarber.app/api/v1').validate();
      const AppEnv(flavor: Flavor.dev, apiBaseUrl: 'http://10.0.2.2:8000/api/v1').validate();
    });
  });

  group('AuthTokens', () {
    test('parses the API shape and treats tokens as expired 30 s early', () {
      final now = DateTime(2026);
      final t = AuthTokens.fromJson(const {'access_token': 'a', 'refresh_token': 'r', 'expires_in': 3600}, now: now);
      expect(t.isAccessExpired(now.add(const Duration(minutes: 59))), isFalse);
      expect(t.isAccessExpired(now.add(const Duration(minutes: 59, seconds: 40))), isTrue);
      expect(AuthTokens.fromStorage(t.toStorage()).refreshToken, 'r');
    });

    test('logger redacts secrets', () {
      expect(AppLogger.redact('Authorization: Bearer abc.def'), 'Authorization: Bearer ***');
      expect(AppLogger.redact('{"refresh_token":"xyz","code":"123456"}'), '{"refresh_token":"***","code":"***"}');
    });
  });
}
