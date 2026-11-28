// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashRoute,
  $languageRoute,
  $phoneRoute,
  $salonEntryRoute,
  $qrScanRoute,
  $bookingDetailRoute,
  $customerShellRoute,
];

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

RouteBase get $languageRoute => GoRouteData.$route(
  path: '/language',
  hasOverriddenOnExit: false,
  factory: $LanguageRoute._fromState,
);

mixin $LanguageRoute on GoRouteData {
  static LanguageRoute _fromState(GoRouterState state) => const LanguageRoute();

  @override
  String get location => GoRouteData.$location('/language');

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

RouteBase get $phoneRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $PhoneRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'code',
      hasOverriddenOnExit: false,
      factory: $OtpRoute._fromState,
    ),
  ],
);

mixin $PhoneRoute on GoRouteData {
  static PhoneRoute _fromState(GoRouterState state) =>
      PhoneRoute(from: state.uri.queryParameters['from']);

  PhoneRoute get _self => this as PhoneRoute;

  @override
  String get location => GoRouteData.$location(
    '/login',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

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

mixin $OtpRoute on GoRouteData {
  static OtpRoute _fromState(GoRouterState state) => OtpRoute(
    phone: state.uri.queryParameters['phone']!,
    retryAfter:
        _$convertMapValue(
          'retry-after',
          state.uri.queryParameters,
          int.parse,
        ) ??
        60,
    from: state.uri.queryParameters['from'],
  );

  OtpRoute get _self => this as OtpRoute;

  @override
  String get location => GoRouteData.$location(
    '/login/code',
    queryParams: {
      'phone': _self.phone,
      if (_self.retryAfter != 60) 'retry-after': _self.retryAfter.toString(),
      if (_self.from != null) 'from': _self.from,
    },
  );

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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $salonEntryRoute => GoRouteData.$route(
  path: '/salon',
  hasOverriddenOnExit: false,
  factory: $SalonEntryRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: ':code',
      hasOverriddenOnExit: false,
      factory: $SalonLinkRoute._fromState,
    ),
  ],
);

mixin $SalonEntryRoute on GoRouteData {
  static SalonEntryRoute _fromState(GoRouterState state) =>
      const SalonEntryRoute();

  @override
  String get location => GoRouteData.$location('/salon');

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

mixin $SalonLinkRoute on GoRouteData {
  static SalonLinkRoute _fromState(GoRouterState state) =>
      SalonLinkRoute(code: state.pathParameters['code']!);

  SalonLinkRoute get _self => this as SalonLinkRoute;

  @override
  String get location =>
      GoRouteData.$location('/salon/${Uri.encodeComponent(_self.code)}');

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

RouteBase get $qrScanRoute => GoRouteData.$route(
  path: '/scan-salon',
  hasOverriddenOnExit: false,
  factory: $QrScanRoute._fromState,
);

mixin $QrScanRoute on GoRouteData {
  static QrScanRoute _fromState(GoRouterState state) => const QrScanRoute();

  @override
  String get location => GoRouteData.$location('/scan-salon');

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

RouteBase get $bookingDetailRoute => GoRouteData.$route(
  path: '/booking/:id',
  hasOverriddenOnExit: false,
  factory: $BookingDetailRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'reschedule',
      hasOverriddenOnExit: false,
      factory: $RescheduleRoute._fromState,
    ),
  ],
);

mixin $BookingDetailRoute on GoRouteData {
  static BookingDetailRoute _fromState(GoRouterState state) =>
      BookingDetailRoute(id: state.pathParameters['id']!);

  BookingDetailRoute get _self => this as BookingDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/booking/${Uri.encodeComponent(_self.id)}');

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

mixin $RescheduleRoute on GoRouteData {
  static RescheduleRoute _fromState(GoRouterState state) =>
      RescheduleRoute(id: state.pathParameters['id']!);

  RescheduleRoute get _self => this as RescheduleRoute;

  @override
  String get location => GoRouteData.$location(
    '/booking/${Uri.encodeComponent(_self.id)}/reschedule',
  );

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

RouteBase get $customerShellRoute => StatefulShellRouteData.$route(
  factory: $CustomerShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/book',
          hasOverriddenOnExit: false,
          factory: $BookRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/ai-studio',
          hasOverriddenOnExit: false,
          factory: $AiStudioRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/appointments',
          hasOverriddenOnExit: false,
          factory: $AppointmentsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          hasOverriddenOnExit: false,
          factory: $ProfileRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'notifications',
              hasOverriddenOnExit: false,
              factory: $NotificationSettingsRoute._fromState,
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $CustomerShellRouteExtension on CustomerShellRoute {
  static CustomerShellRoute _fromState(GoRouterState state) =>
      const CustomerShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

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

mixin $BookRoute on GoRouteData {
  static BookRoute _fromState(GoRouterState state) => const BookRoute();

  @override
  String get location => GoRouteData.$location('/book');

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

mixin $AiStudioRoute on GoRouteData {
  static AiStudioRoute _fromState(GoRouterState state) => const AiStudioRoute();

  @override
  String get location => GoRouteData.$location('/ai-studio');

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

mixin $AppointmentsRoute on GoRouteData {
  static AppointmentsRoute _fromState(GoRouterState state) =>
      const AppointmentsRoute();

  @override
  String get location => GoRouteData.$location('/appointments');

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

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

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

mixin $NotificationSettingsRoute on GoRouteData {
  static NotificationSettingsRoute _fromState(GoRouterState state) =>
      const NotificationSettingsRoute();

  @override
  String get location => GoRouteData.$location('/profile/notifications');

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
