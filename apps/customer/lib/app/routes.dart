import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smartbarber_customer/features/appointments/appointments_screen.dart';
import 'package:smartbarber_customer/features/appointments/booking_detail_screen.dart';
import 'package:smartbarber_customer/features/appointments/reschedule_screen.dart';
import 'package:smartbarber_customer/features/auth/otp_screen.dart';
import 'package:smartbarber_customer/features/auth/phone_screen.dart';
import 'package:smartbarber_customer/features/booking/booking_stepper_screen.dart';
import 'package:smartbarber_customer/features/home/home_screen.dart';
import 'package:smartbarber_customer/features/onboarding/language_screen.dart';
import 'package:smartbarber_customer/features/profile/notification_settings_screen.dart';
import 'package:smartbarber_customer/features/profile/profile_screen.dart';
import 'package:smartbarber_customer/features/salon/qr_scan_screen.dart';
import 'package:smartbarber_customer/features/salon/salon_entry_screen.dart';
import 'package:smartbarber_customer/features/salon/salon_link_screen.dart';
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

/// Choose a salon: your salons, a code or link, QR, or search.
@TypedGoRoute<SalonEntryRoute>(path: '/salon', routes: [TypedGoRoute<SalonLinkRoute>(path: ':code')])
class SalonEntryRoute extends GoRouteData with $SalonEntryRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SalonEntryScreen();
}

/// smartbarber://salon/{slug} and typed links: resolve, remember, open Home.
class SalonLinkRoute extends GoRouteData with $SalonLinkRoute {
  const new({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) => SalonLinkScreen(code: code);
}

@TypedGoRoute<QrScanRoute>(path: '/scan-salon')
class QrScanRoute extends GoRouteData with $QrScanRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const QrScanScreen();
}

/// smartbarber://booking/{id} — also the target of booking notifications.
@TypedGoRoute<BookingDetailRoute>(path: '/booking/:id', routes: [TypedGoRoute<RescheduleRoute>(path: 'reschedule')])
class BookingDetailRoute extends GoRouteData with $BookingDetailRoute {
  const new({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) => BookingDetailScreen(id: id);
}

class RescheduleRoute extends GoRouteData with $RescheduleRoute {
  const new({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) => RescheduleScreen(id: id);
}

@TypedStatefulShellRoute<CustomerShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(routes: [TypedGoRoute<HomeRoute>(path: '/home')]),
    TypedStatefulShellBranch<BookBranch>(routes: [TypedGoRoute<BookRoute>(path: '/book')]),
    TypedStatefulShellBranch<AiStudioBranch>(routes: [TypedGoRoute<AiStudioRoute>(path: '/ai-studio')]),
    TypedStatefulShellBranch<AppointmentsBranch>(routes: [TypedGoRoute<AppointmentsRoute>(path: '/appointments')]),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(path: '/profile', routes: [TypedGoRoute<NotificationSettingsRoute>(path: 'notifications')]),
      ],
    ),
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
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class BookRoute extends GoRouteData with $BookRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BookingStepperScreen();
}

class AiStudioRoute extends GoRouteData with $AiStudioRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AiStudioTab();
}

class AppointmentsRoute extends GoRouteData with $AppointmentsRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AppointmentsScreen();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileScreen();
}

class NotificationSettingsRoute extends GoRouteData with $NotificationSettingsRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NotificationSettingsScreen();
}
