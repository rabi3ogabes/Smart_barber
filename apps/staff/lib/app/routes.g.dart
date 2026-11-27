// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$splashRoute, $loginRoute, $staffShellRoute];

RouteBase get $splashRoute => GoRouteData.$route(
  path: '/splash',
  hasOverriddenOnExit: false,
  factory: $SplashRoute._fromState,
);

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  @override
  String get location => GoRouteData.$location('/splash');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: '2fa',
      hasOverriddenOnExit: false,
      factory: $TwoFactorRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'salon',
      hasOverriddenOnExit: false,
      factory: $SalonPickerRoute._fromState,
    ),
  ],
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TwoFactorRoute on GoRouteData {
  static TwoFactorRoute _fromState(GoRouterState state) =>
      const TwoFactorRoute();

  @override
  String get location => GoRouteData.$location('/login/2fa');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SalonPickerRoute on GoRouteData {
  static SalonPickerRoute _fromState(GoRouterState state) =>
      const SalonPickerRoute();

  @override
  String get location => GoRouteData.$location('/login/salon');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $staffShellRoute => StatefulShellRouteData.$route(
  factory: $StaffShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/today',
          hasOverriddenOnExit: false,
          factory: $TodayRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/queue',
          hasOverriddenOnExit: false,
          factory: $QueueRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/customers',
          hasOverriddenOnExit: false,
          factory: $CustomersRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/pos',
          hasOverriddenOnExit: false,
          factory: $PosRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/me',
          hasOverriddenOnExit: false,
          factory: $MeRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $StaffShellRouteExtension on StaffShellRoute {
  static StaffShellRoute _fromState(GoRouterState state) =>
      const StaffShellRoute();
}

mixin $TodayRoute on GoRouteData {
  static TodayRoute _fromState(GoRouterState state) => const TodayRoute();

  @override
  String get location => GoRouteData.$location('/today');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $QueueRoute on GoRouteData {
  static QueueRoute _fromState(GoRouterState state) => const QueueRoute();

  @override
  String get location => GoRouteData.$location('/queue');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomersRoute on GoRouteData {
  static CustomersRoute _fromState(GoRouterState state) =>
      const CustomersRoute();

  @override
  String get location => GoRouteData.$location('/customers');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PosRoute on GoRouteData {
  static PosRoute _fromState(GoRouterState state) => const PosRoute();

  @override
  String get location => GoRouteData.$location('/pos');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MeRoute on GoRouteData {
  static MeRoute _fromState(GoRouterState state) => const MeRoute();

  @override
  String get location => GoRouteData.$location('/me');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
