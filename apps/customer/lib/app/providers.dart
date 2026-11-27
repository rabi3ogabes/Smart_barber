import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/app/session.dart';

part 'providers.g.dart';

/// Overridden in bootstrap.
@Riverpod(keepAlive: true)
AppEnv env(Ref ref) => throw UnimplementedError('envProvider must be overridden');

/// Overridden in bootstrap.
@Riverpod(keepAlive: true)
AppPreferences preferences(Ref ref) => throw UnimplementedError('preferencesProvider must be overridden');

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureTokenStore(key: 'sb.customer.tokens');

String _language(Ref ref) => ref.read(appLocaleProvider)?.languageCode ?? 'ar';

/// Client without auth for sign-in and refresh.
@Riverpod(keepAlive: true)
Dio bareDio(Ref ref) => ApiClient.bare(env: ref.watch(envProvider), languageCode: () => _language(ref));

/// Authenticated client used by repositories.
@Riverpod(keepAlive: true)
Dio apiDio(Ref ref) => ApiClient.create(
  env: ref.watch(envProvider),
  tokenStore: ref.watch(tokenStoreProvider),
  refresher: (refresh) => ref.read(customerAuthRepositoryProvider).refresh(refresh),
  languageCode: () => _language(ref),
  onSessionExpired: () => ref.read(customerSessionProvider.notifier).expired(),
);

@Riverpod(keepAlive: true)
CustomerAuthRepository customerAuthRepository(Ref ref) =>
    CustomerAuthRepository(api: ref.watch(apiDioProvider), bare: ref.watch(bareDioProvider));

@Riverpod(keepAlive: true)
DevicesRepository devicesRepository(Ref ref) => DevicesRepository(ref.watch(apiDioProvider), isStaffApp: false);

/// Current time, injectable so tests (and goldens) are deterministic.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
ConnectivityService connectivity(Ref ref) => ConnectivityService();

/// True while the device has a network connection (drives the offline banner).
@Riverpod(keepAlive: true)
Stream<bool> online(Ref ref) async* {
  final service = ref.watch(connectivityProvider);
  yield await service.isOnline();
  yield* service.watch();
}
