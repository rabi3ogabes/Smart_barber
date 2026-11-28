import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/router.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/push/push_service.dart';

part 'push_registration.g.dart';

/// Overridden in tests; Firebase when the build is configured, otherwise disabled.
@Riverpod(keepAlive: true)
PushService pushService(Ref ref) => FirebasePushService.fromDefines() ?? const DisabledPushService();

/// While signed in: registers the device token (and its refreshes) with the API, and opens the
/// booking a tapped notification points to. Kept alive by the app widget.
@Riverpod(keepAlive: true)
class PushRegistration extends _$PushRegistration {
  final List<StreamSubscription<String>> _subs = [];

  @override
  bool build() {
    ref
      ..listen(customerSessionProvider, (_, next) {
        if (next.value is SignedIn) unawaited(_start());
      }, fireImmediately: true)
      ..onDispose(() {
        for (final s in _subs) {
          unawaited(s.cancel());
        }
      });
    return false;
  }

  Future<void> _start() async {
    if (state) return;
    final push = ref.read(pushServiceProvider);
    state = true;
    // Listen first: the first token can arrive while start() is still running.
    _subs.add(push.tokens.listen(_register));
    if (!await push.start()) {
      state = false;
      return;
    }
    _subs.add(push.openedLinks.listen(_open));
    final initial = await push.initialLink();
    if (initial != null) _open(initial);
  }

  Future<void> _register(String token) async {
    await ref.read(devicesRepositoryProvider).register(
      fcmToken: token,
      platform: defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
      locale: ref.read(appLocaleProvider)?.languageCode ?? 'ar',
    );
  }

  /// `smartbarber://booking/{id}` → `/booking/{id}`; the router's guards still apply.
  void _open(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null || uri.scheme != 'smartbarber') return;
    ref.read(routerProvider).go('/${uri.host}${uri.path}');
  }
}
