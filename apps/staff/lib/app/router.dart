import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:smartbarber_staff/app/routes.dart';
import 'package:smartbarber_staff/app/session.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(staffSessionProvider, (_, _) => refresh.value++)
    ..listen(loginFlowProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: const SplashRoute().location,
    refreshListenable: refresh,
    routes: $appRoutes,
    redirect: (context, state) => staffRedirect(
      path: state.uri.path,
      session: ref.read(staffSessionProvider),
      pendingStep: ref.read(loginFlowProvider),
    ),
  );
}

/// Pure redirect logic (unit-tested).
@visibleForTesting
String? staffRedirect({required String path, required AsyncValue<StaffSessionState> session, required StaffLoginStep? pendingStep}) {
  if (session.isLoading && !session.hasValue) return path == '/splash' ? null : '/splash';

  if (session.value is StaffSignedInState) {
    return (path.startsWith('/login') || path == '/splash') ? const TodayRoute().location : null;
  }

  // Signed out: only the sign-in steps are reachable, and only the step that is pending.
  return switch (pendingStep) {
    StaffTwoFactorRequired() => path == '/login/2fa' ? null : const TwoFactorRoute().location,
    StaffSalonSelectionRequired() => path == '/login/salon' ? null : const SalonPickerRoute().location,
    _ => path == '/login' ? null : const LoginRoute().location,
  };
}
