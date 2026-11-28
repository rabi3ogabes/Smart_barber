import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/app/session.dart';

part 'router.g.dart';

/// Routes with an auth + first-launch guard. Re-evaluated whenever the session or language changes.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(customerSessionProvider, (_, _) => refresh.value++)
    ..listen(appLocaleProvider, (_, _) => refresh.value++)
    ..listen(currentSalonProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: const SplashRoute().location,
    refreshListenable: refresh,
    routes: $appRoutes,
    redirect: (context, state) => customerRedirect(
      uri: state.uri,
      session: ref.read(customerSessionProvider),
      localeChosen: ref.read(appLocaleProvider) != null,
      salonChosen: ref.read(currentSalonProvider) != null,
    ),
  );
}

/// Pure redirect logic (unit-tested).
@visibleForTesting
String? customerRedirect({
  required Uri uri,
  required AsyncValue<CustomerSessionState> session,
  required bool localeChosen,
  bool salonChosen = true,
}) {
  // smartbarber://booking/{id} and smartbarber://salon/{slug} arrive with the host as the first segment.
  if (uri.scheme == 'smartbarber') return '/${uri.host}${uri.path}';

  final path = uri.path;
  final onAuth = path.startsWith('/login');

  if (session.isLoading && !session.hasValue) return path == '/splash' ? null : '/splash';
  if (!localeChosen) return path == '/language' ? null : '/language';

  final state = session.value;
  if (state is! SignedIn) {
    if (onAuth) return null;
    final from = (path == '/splash' || path == '/language') ? null : uri.toString();
    return PhoneRoute(from: from).location;
  }

  if (onAuth || path == '/splash' || path == '/language') {
    final from = uri.queryParameters['from'];
    if (from != null && from.startsWith('/') && !from.startsWith('/login')) return from;
    return salonChosen ? const HomeRoute().location : const SalonEntryRoute().location;
  }
  // Home and Book need a salon; everything else (bookings, profile) works across salons.
  if (!salonChosen && (path == '/home' || path == '/book')) return const SalonEntryRoute().location;
  return null;
}
