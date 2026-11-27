import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';

class _Adapter implements HttpClientAdapter {
  new(this.handler);

  final ResponseBody Function(RequestOptions o) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? _, Future<void>? _) async {
    requests.add(o);
    return handler(o);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Object body) => ResponseBody.fromString(jsonEncode(body), status, headers: {
  Headers.contentTypeHeader: [Headers.jsonContentType],
});

const Map<String, Object> _tokens = {'token_type': 'Bearer', 'access_token': '1|abc', 'expires_in': 3600, 'refresh_token': 'r', 'refresh_expires_in': 5184000};
const env = AppEnv(flavor: Flavor.dev, apiBaseUrl: 'http://api.test/api/v1');

Dio _dio(_Adapter a) => ApiClient.bare(env: env, languageCode: () => 'ar', adapter: a);

void main() {
  group('StaffAuthRepository', () {
    test('turns 409 envelopes into the next sign-in step', () async {
      final adapter = _Adapter((o) => switch (o.path) {
        '/staff/auth/login' => _json(409, {
          'success': false, 'message': '', 'code': 'TWO_FACTOR_REQUIRED', 'errors': <String, Object?>{},
          'data': {'challenge_token': 'ch'},
        }),
        '/staff/auth/2fa' => _json(409, {
          'success': false, 'message': '', 'code': 'SALON_SELECTION_REQUIRED', 'errors': <String, Object?>{},
          'data': {
            'selection_token': 'sel',
            'memberships': [
              {'salon': 'S1', 'slug': 'salon-a', 'name': {'ar': 'صالون النخبة', 'en': 'Elite Barbers'}},
              {'salon': 'S2', 'slug': 'salon-b', 'name': {'ar': 'صالون اللؤلؤة', 'en': 'Pearl Grooming'}},
            ],
          },
        }),
        _ => _json(200, {'success': true, 'message': '', 'data': {'tokens': _tokens, 'salon': 'S2'}, 'meta': <String, Object?>{}}),
      });
      final repo = StaffAuthRepository(api: _dio(adapter), bare: _dio(adapter));

      final login = (await repo.login(email: 'a@b.c', password: 'x', deviceName: 'd')).valueOrNull;
      expect(login, isA<StaffTwoFactorRequired>().having((s) => s.challengeToken, 'token', 'ch'));

      final twoFactor = (await repo.verifyTwoFactor(challengeToken: 'ch', code: '123456')).valueOrNull;
      expect(twoFactor, isA<StaffSalonSelectionRequired>());
      final selection = twoFactor! as StaffSalonSelectionRequired;
      expect(selection.memberships.map((m) => localize(m.name, 'en')), ['Elite Barbers', 'Pearl Grooming']);

      final signedIn = (await repo.selectSalon(selectionToken: 'sel', salonId: 'S2')).valueOrNull;
      expect(signedIn, isA<StaffSignedIn>().having((s) => s.salonId, 'salon', 'S2'));
      expect((signedIn! as StaffSignedIn).tokens.accessToken, '1|abc');
      expect(adapter.requests.every((r) => !r.headers.containsKey('Authorization')), isTrue);
    });

    test('keeps real errors as failures', () async {
      final adapter = _Adapter((_) => _json(422, {'success': false, 'message': 'x', 'code': 'INVALID_CREDENTIALS', 'errors': <String, Object?>{}}));
      final repo = StaffAuthRepository(api: _dio(adapter), bare: _dio(adapter));

      final failure = (await repo.login(email: 'a@b.c', password: 'x', deviceName: 'd')).failureOrNull;
      expect(failure, isA<ApiFailure>().having((f) => f.code, 'code', 'INVALID_CREDENTIALS'));
    });

    test('parses /staff/me as the backend sends it', () async {
      final adapter = _Adapter((_) => _json(200, {
        'success': true, 'message': '', 'meta': <String, Object?>{},
        'data': {
          'user': {'id': 'U1', 'name': 'Barber', 'email': 'b@x.qa', 'phone': null, 'locale': 'ar', 'two_factor_enabled': false},
          'salon': {'id': 'S1', 'slug': 'salon-a', 'name': {'ar': 'صالون', 'en': 'Salon'}, 'currency': 'QAR', 'timezone': 'Asia/Qatar'},
          'roles': ['barber'],
          'permissions': ['dashboard.view', 'booking.view'],
          'branches': [{'id': 'B1', 'name': {'ar': 'فرع', 'en': 'West Bay'}}],
          'features': <String>[],
        },
      }));
      final me = (await StaffAuthRepository(api: _dio(adapter), bare: _dio(adapter)).me()).valueOrNull!;

      expect(me.salon!.currency, 'QAR');
      expect(me.can('booking.view'), isTrue);
      expect(me.can('payment.refund'), isFalse);
      expect(localize(me.branches.single.name, 'ar'), 'فرع');
    });
  });

  group('CustomerAuthRepository', () {
    test('requests and verifies a code', () async {
      final adapter = _Adapter((o) => o.path.endsWith('/otp')
          ? _json(200, {'success': true, 'message': '', 'data': {'expires_in': 300, 'retry_after': 60}, 'meta': <String, Object?>{}})
          : _json(200, {
              'success': true, 'message': '', 'meta': <String, Object?>{},
              'data': {
                'tokens': _tokens,
                'account': {'id': 'C1', 'phone': '+97455123456', 'name': null, 'email': null, 'locale': 'ar', 'profile_complete': false},
                'is_new': true,
              },
            }));
      final repo = CustomerAuthRepository(api: _dio(adapter), bare: _dio(adapter));

      expect((await repo.requestOtp('+97455123456')).valueOrNull, const OtpSent(expiresIn: 300, retryAfter: 60));
      final signIn = (await repo.verifyOtp(phone: '+97455123456', code: '123456', deviceName: 'Pixel')).valueOrNull!;
      expect(signIn.isNew, isTrue);
      expect(signIn.account.profileComplete, isFalse);
      expect(adapter.requests.last.data, {'phone': '+97455123456', 'code': '123456', 'device_name': 'Pixel'});
    });
  });

  test('localize falls back to the other language', () {
    expect(localize({'en': 'Only English'}, 'ar'), 'Only English');
    expect(localize(null, 'ar'), '');
  });
}
