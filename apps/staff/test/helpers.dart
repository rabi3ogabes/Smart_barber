import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbarber_staff/app/app.dart';
import 'package:smartbarber_staff/app/providers.dart';
import 'package:smartbarber_staff/app/router.dart';
import 'package:smartbarber_staff/app/session.dart';

final testTokens = AuthTokens(accessToken: '1|a', refreshToken: 'r', accessExpiresAt: DateTime(2100));

const testMe = StaffMe(
  user: StaffUser(id: 'U1', name: 'Yousef', locale: 'ar', twoFactorEnabled: true, email: 'yousef@salon.qa'),
  salon: SalonSummary(id: 'S1', slug: 'salon-a', name: {'ar': 'صالون النخبة', 'en': 'Elite Barbers'}, currency: 'QAR', timezone: 'Asia/Qatar'),
  roles: ['barber'],
  permissions: ['dashboard.view'],
  branches: [],
  features: [],
);

/// Scripted repository for the sign-in steps.
class FakeStaffAuthRepository implements StaffAuthRepository {
  Result<StaffLoginStep> loginResult = const Ok(StaffTwoFactorRequired('ch'));
  Result<StaffLoginStep> twoFactorResult = const Ok(
    StaffSalonSelectionRequired(
      selectionToken: 'sel',
      memberships: [
        MembershipOption(salon: 'S1', slug: 'salon-a', name: {'ar': 'صالون النخبة', 'en': 'Elite Barbers'}),
        MembershipOption(salon: 'S2', slug: 'salon-b', name: {'ar': 'صالون اللؤلؤة', 'en': 'Pearl Grooming'}),
      ],
    ),
  );
  final List<String> calls = [];

  @override
  Future<Result<StaffLoginStep>> login({required String email, required String password, required String deviceName}) async {
    calls.add('login:$email');
    return loginResult;
  }

  @override
  Future<Result<StaffLoginStep>> verifyTwoFactor({required String challengeToken, required String code}) async {
    calls.add('2fa:$challengeToken:$code');
    return twoFactorResult;
  }

  @override
  Future<Result<StaffLoginStep>> selectSalon({required String selectionToken, required String salonId}) async {
    calls.add('select:$salonId');
    return Ok(StaffSignedIn(tokens: testTokens, salonId: salonId));
  }

  @override
  Future<Result<StaffMe>> me() async => const Ok(testMe);

  @override
  Future<Result<void>> logout() async => const Ok(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SignedInStaffSession extends StaffSession {
  @override
  Future<StaffSessionState> build() async => const StaffSignedInState(testMe);
}

Future<List<Override>> baseOverrides({StaffAuthRepository? repo, String locale = 'ar'}) async {
  SharedPreferences.setMockInitialValues({'sb.locale': locale});
  return [
    preferencesProvider.overrideWithValue(await AppPreferences.load()),
    envProvider.overrideWithValue(const AppEnv(flavor: Flavor.dev, apiBaseUrl: 'http://api.test/api/v1')),
    tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
    onlineProvider.overrideWithValue(const AsyncData(true)),
    if (repo != null) staffAuthRepositoryProvider.overrideWithValue(repo),
  ];
}

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

/// The real app router and redirects inside one provider scope.
Widget routedApp({required List<Override> overrides, Locale locale = const Locale('ar')}) => ProviderScope(
  overrides: overrides,
  child: Consumer(
    builder: (context, ref, _) => MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      theme: SbTheme.build(Brightness.light, languageCode: locale.languageCode),
      debugShowCheckedModeBanner: false,
    ),
  ),
);
