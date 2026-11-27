// Contract test: the typed client against a running backend (not part of the unit suite).
//
//   cd backend && QUEUE_CONNECTION=sync php artisan serve      (seeded dev DB)
//   cd packages/sb_api && flutter test test_e2e \
//       --dart-define=E2E_API=http://127.0.0.1:8000/api/v1 --dart-define=E2E_LOG=../../backend/storage/logs/laravel.log
@Tags(['e2e'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';

const api = String.fromEnvironment('E2E_API');
const logPath = String.fromEnvironment('E2E_LOG');

void main() {
  const env = AppEnv(flavor: Flavor.dev, apiBaseUrl: api);
  final skip = api.isEmpty ? 'Set --dart-define=E2E_API to run against a backend' : null;

  ({CustomerAuthRepository customer, StaffAuthRepository staff, MemoryTokenStore store}) clients(String lang) {
    final store = MemoryTokenStore();
    final bare = ApiClient.bare(env: env, languageCode: () => lang);
    late CustomerAuthRepository customer;
    final dio = ApiClient.create(env: env, tokenStore: store, refresher: (r) => customer.refresh(r), languageCode: () => lang, onSessionExpired: () {});
    customer = CustomerAuthRepository(api: dio, bare: bare);
    return (customer: customer, staff: StaffAuthRepository(api: dio, bare: bare), store: store);
  }

  test('meta/app-config parses', () async {
    final config = (await MetaRepository(ApiClient.bare(env: env, languageCode: () => 'ar')).appConfig()).valueOrNull!;
    expect(config.locales, containsAll(['ar', 'en']));
  }, skip: skip);

  test('customer: OTP sign-in, me, refresh through the interceptor, logout', () async {
    final c = clients('ar');
    final phone = '+9745${DateTime.now().millisecondsSinceEpoch % 10000000}'.padRight(12, '0');

    final sent = (await c.customer.requestOtp(phone)).valueOrNull!;
    expect(sent.expiresIn, 300);

    final code = RegExp('"phone":"${RegExp.escape(phone)}","code":"(\\d{6})"')
        .allMatches(File(logPath).readAsStringSync())
        .last
        .group(1)!;

    final wrong = await c.customer.verifyOtp(phone: phone, code: code == '000000' ? '111111' : '000000', deviceName: 'e2e');
    expect(wrong.failureOrNull, isA<ApiFailure>().having((f) => f.code, 'code', ApiErrorCode.otpInvalid));

    final signIn = (await c.customer.verifyOtp(phone: phone, code: code, deviceName: 'e2e')).valueOrNull!;
    expect(signIn.isNew, isTrue);
    expect(signIn.account.phone, phone);

    // Force an expired access token: the interceptor must refresh and replay transparently.
    await c.store.write(AuthTokens(accessToken: signIn.tokens.accessToken, refreshToken: signIn.tokens.refreshToken, accessExpiresAt: DateTime(2000)));
    final me = (await c.customer.me()).valueOrNull!;
    expect(me.phone, phone);
    expect((await c.store.read())!.accessToken, isNot(signIn.tokens.accessToken));

    // The original refresh token was rotated: reusing it ends the session on the server.
    final reuse = await Result.guard(() => c.customer.refresh(signIn.tokens.refreshToken));
    expect(reuse.failureOrNull, isA<ApiFailure>().having((f) => f.code, 'code', ApiErrorCode.refreshTokenReused));
  }, skip: skip);

  test('staff: barber signs straight in; owner without 2FA is told to enrol; errors arrive translated', () async {
    final c = clients('en');

    final step = (await c.staff.login(email: 'barber.a@smartbarber.test', password: 'Password123!', deviceName: 'e2e')).valueOrNull;
    expect(step, isA<StaffSignedIn>());
    await c.store.write((step! as StaffSignedIn).tokens);

    final me = (await c.staff.me()).valueOrNull!;
    expect(me.roles, ['barber']);
    expect(localize(me.salon!.name, 'en'), 'Elite Barbers');
    expect(me.can('booking.view'), isTrue);
    expect(me.can('payment.refund'), isFalse);

    final owner = await c.staff.login(email: 'owner.a@smartbarber.test', password: 'Password123!', deviceName: 'e2e');
    expect(owner.failureOrNull, isA<ApiFailure>().having((f) => f.code, 'code', ApiErrorCode.twoFactorEnrollmentRequired));

    final arabic = await clients('ar').staff.login(email: 'barber.a@smartbarber.test', password: 'wrong', deviceName: 'e2e');
    expect((arabic.failureOrNull! as ApiFailure).message, 'البريد الإلكتروني أو كلمة المرور غير صحيحة.');

    expect((await c.staff.logout()).failureOrNull, isNull);
  }, skip: skip);
}
