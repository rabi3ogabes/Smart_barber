import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smartbarber_customer/features/auth/otp_screen.dart';
import 'package:smartbarber_customer/features/auth/phone_screen.dart';
import 'package:smartbarber_customer/features/onboarding/language_screen.dart';
import 'package:smartbarber_customer/features/profile/profile_screen.dart';
import 'package:smartbarber_customer/features/shell/customer_shell.dart';
import 'package:smartbarber_customer/features/shell/placeholder_tabs.dart';
import 'package:smartbarber_customer/features/splash/splash_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashScreen();
}

@TypedGoRoute<LanguageRoute>(path: '/language')
class LanguageRoute extends GoRouteData with $LanguageRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LanguageScreen();
}

@TypedGoRoute<PhoneRoute>(path: '/login', routes: [TypedGoRoute<OtpRoute>(path: 'code')])
class PhoneRoute extends GoRouteData with $PhoneRoute {
  const new({this.from});

  /// Where to return after sign-in (session expiry keeps the intended route).
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) => PhoneScreen(from: from);
}

class OtpRoute extends GoRouteData with $OtpRoute {
  const new({required this.phone, this.retryAfter = 60, this.from});

  final String phone;
  final int retryAfter;
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) => OtpScreen(phone: phone, retryAfter: retryAfter, from: from);
}

/// smartbarber://booking/{id}. Booking details arrive in Phase 5; until then open Appointments.
@TypedGoRoute<BookingLinkRoute>(path: '/booking/:id')
class BookingLinkRoute extends GoRouteData with $BookingLinkRoute {
  const new({required this.id});

  final String id;

  @override
  String? redirect(BuildContext context, GoRouterState state) => const AppointmentsRoute().location;
}

@TypedStatefulShellRoute<CustomerShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(routes: [TypedGoRoute<HomeRoute>(path: '/home')]),
    TypedStatefulShellBranch<BookBranch>(routes: [TypedGoRoute<BookRoute>(path: '/book')]),
    TypedStatefulShellBranch<AiStudioBranch>(routes: [TypedGoRoute<AiStudioRoute>(path: '/ai-studio')]),
    TypedStatefulShellBranch<AppointmentsBranch>(routes: [TypedGoRoute<AppointmentsRoute>(path: '/appointments')]),
    TypedStatefulShellBranch<ProfileBranch>(routes: [TypedGoRoute<ProfileRoute>(path: '/profile')]),
  ],
)
class CustomerShellRoute extends StatefulShellRouteData {
  const new();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) => CustomerShell(
    currentIndex: navigationShell.currentIndex,
    onSelect: (i) => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
    child: navigationShell,
  );
}

class HomeBranch extends StatefulShellBranchData {
  const new();
}

class BookBranch extends StatefulShellBranchData {
  const new();
}

class AiStudioBranch extends StatefulShellBranchData {
  const new();
}

class AppointmentsBranch extends StatefulShellBranchData {
  const new();
}

class ProfileBranch extends StatefulShellBranchData {
  const new();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeTab();
}

class BookRoute extends GoRouteData with $BookRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BookTab();
}

class AiStudioRoute extends GoRouteData with $AiStudioRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AiStudioTab();
}

class AppointmentsRoute extends GoRouteData with $AppointmentsRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AppointmentsTab();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileScreen();
}
