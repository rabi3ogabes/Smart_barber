import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smartbarber_staff/features/auth/login_screen.dart';
import 'package:smartbarber_staff/features/auth/salon_picker_screen.dart';
import 'package:smartbarber_staff/features/auth/two_factor_screen.dart';
import 'package:smartbarber_staff/features/me/me_screen.dart';
import 'package:smartbarber_staff/features/shell/placeholder_tabs.dart';
import 'package:smartbarber_staff/features/shell/staff_shell.dart';
import 'package:smartbarber_staff/features/splash/splash_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashScreen();
}

@TypedGoRoute<LoginRoute>(
  path: '/login',
  routes: [TypedGoRoute<TwoFactorRoute>(path: '2fa'), TypedGoRoute<SalonPickerRoute>(path: 'salon')],
)
class LoginRoute extends GoRouteData with $LoginRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginScreen();
}

class TwoFactorRoute extends GoRouteData with $TwoFactorRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TwoFactorScreen();
}

class SalonPickerRoute extends GoRouteData with $SalonPickerRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SalonPickerScreen();
}

@TypedStatefulShellRoute<StaffShellRoute>(
  branches: [
    TypedStatefulShellBranch<TodayBranch>(routes: [TypedGoRoute<TodayRoute>(path: '/today')]),
    TypedStatefulShellBranch<QueueBranch>(routes: [TypedGoRoute<QueueRoute>(path: '/queue')]),
    TypedStatefulShellBranch<CustomersBranch>(routes: [TypedGoRoute<CustomersRoute>(path: '/customers')]),
    TypedStatefulShellBranch<PosBranch>(routes: [TypedGoRoute<PosRoute>(path: '/pos')]),
    TypedStatefulShellBranch<MeBranch>(routes: [TypedGoRoute<MeRoute>(path: '/me')]),
  ],
)
class StaffShellRoute extends StatefulShellRouteData {
  const new();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) => StaffShell(
    currentIndex: navigationShell.currentIndex,
    onSelect: (i) => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
    child: navigationShell,
  );
}

class TodayBranch extends StatefulShellBranchData {
  const new();
}

class QueueBranch extends StatefulShellBranchData {
  const new();
}

class CustomersBranch extends StatefulShellBranchData {
  const new();
}

class PosBranch extends StatefulShellBranchData {
  const new();
}

class MeBranch extends StatefulShellBranchData {
  const new();
}

class TodayRoute extends GoRouteData with $TodayRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TodayTab();
}

class QueueRoute extends GoRouteData with $QueueRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const QueueTab();
}

class CustomersRoute extends GoRouteData with $CustomersRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CustomersTab();
}

class PosRoute extends GoRouteData with $PosRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const PosTab();
}

class MeRoute extends GoRouteData with $MeRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MeScreen();
}
