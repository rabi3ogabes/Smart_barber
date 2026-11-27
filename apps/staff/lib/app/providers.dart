import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_staff/app/preferences_controllers.dart';
import 'package:smartbarber_staff/app/session.dart';

part 'providers.g.dart';

/// Overridden in bootstrap.
@Riverpod(keepAlive: true)
AppEnv env(Ref ref) => throw UnimplementedError('envProvider must be overridden');

/// Overridden in bootstrap.
@Riverpod(keepAlive: true)
AppPreferences preferences(Ref ref) => throw UnimplementedError('preferencesProvider must be overridden');

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureTokenStore(key: 'sb.staff.tokens');

String _language(Ref ref) => ref.read(appLocaleProvider)?.languageCode ?? 'ar';

@Riverpod(keepAlive: true)
Dio bareDio(Ref ref) => ApiClient.bare(env: ref.watch(envProvider), languageCode: () => _language(ref));

@Riverpod(keepAlive: true)
Dio apiDio(Ref ref) => ApiClient.create(
  env: ref.watch(envProvider),
  tokenStore: ref.watch(tokenStoreProvider),
  refresher: (refresh) => ref.read(staffAuthRepositoryProvider).refresh(refresh),
  languageCode: () => _language(ref),
  onSessionExpired: () => ref.read(staffSessionProvider.notifier).expired(),
);

@Riverpod(keepAlive: true)
StaffAuthRepository staffAuthRepository(Ref ref) =>
    StaffAuthRepository(api: ref.watch(apiDioProvider), bare: ref.watch(bareDioProvider));

@Riverpod(keepAlive: true)
DevicesRepository devicesRepository(Ref ref) => DevicesRepository(ref.watch(apiDioProvider), isStaffApp: true);

@Riverpod(keepAlive: true)
ConnectivityService connectivity(Ref ref) => ConnectivityService();

@Riverpod(keepAlive: true)
Stream<bool> online(Ref ref) async* {
  final service = ref.watch(connectivityProvider);
  yield await service.isOnline();
  yield* service.watch();
}
