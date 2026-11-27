import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbarber_customer/app/app.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/session.dart';

/// Scripted repository: each call returns what the test set.
class FakeCustomerAuthRepository implements CustomerAuthRepository {
  Result<OtpSent> otpResult = const Ok(OtpSent(expiresIn: 300, retryAfter: 60));
  Result<CustomerSignIn>? verifyResult;
  final List<String> requested = [];

  @override
  Future<Result<OtpSent>> requestOtp(String phone) async {
    requested.add(phone);
    return otpResult;
  }

  @override
  Future<Result<CustomerSignIn>> verifyOtp({required String phone, required String code, required String deviceName}) async =>
      verifyResult ?? const Err(ApiFailure(code: 'OTP_INVALID', status: 422));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const testAccount = CustomerAccount(id: 'C1', phone: '+97455123456', locale: 'ar', profileComplete: true, name: 'Rashid');

class SignedInSession extends CustomerSession {
  @override
  Future<CustomerSessionState> build() async => const SignedIn(testAccount);
}

Future<List<Override>> baseOverrides({FakeCustomerAuthRepository? repo}) async {
  SharedPreferences.setMockInitialValues({'sb.locale': 'ar'});
  return [
    preferencesProvider.overrideWithValue(await AppPreferences.load()),
    envProvider.overrideWithValue(const AppEnv(flavor: Flavor.dev, apiBaseUrl: 'http://api.test/api/v1')),
    tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
    onlineProvider.overrideWithValue(const AsyncData(true)),
    clockProvider.overrideWithValue(() => DateTime(2026, 11, 27, 10)),
    if (repo != null) customerAuthRepositoryProvider.overrideWithValue(repo),
  ];
}

/// A routed test app with real localisations and theme.
Widget testApp({required List<Override> overrides, required GoRouter router, Locale locale = const Locale('ar'), Brightness brightness = Brightness.light}) =>
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: router,
        locale: locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        theme: SbTheme.build(brightness, languageCode: locale.languageCode),
        debugShowCheckedModeBanner: false,
      ),
    );
