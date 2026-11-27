// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'sb_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SbLocalizationsEn extends SbLocalizations {
  SbLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get signOut => 'Sign out';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get loading => 'Loading…';

  @override
  String get offlineBanner =>
      'You’re offline. Showing saved information; changes need a connection.';

  @override
  String get offlineAction =>
      'You’re offline. Connect to the internet and try again.';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorBody =>
      'We couldn’t load this. Check your connection and try again.';

  @override
  String get noPermissionTitle => 'You don’t have access';

  @override
  String get noPermissionBody =>
      'Ask the salon owner to give your role access to this screen.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get errorNetworkOffline =>
      'No internet connection. Check your connection and try again.';

  @override
  String get errorNetworkTimeout =>
      'The server took too long to answer. Please try again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorValidation => 'Please check the highlighted fields.';

  @override
  String get errorUnauthenticated =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorForbidden => 'You don’t have permission to do this.';

  @override
  String get errorNotFound => 'We couldn’t find what you were looking for.';

  @override
  String get errorRateLimited =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get errorServiceUnavailable =>
      'The service is temporarily unavailable. Please try again shortly.';

  @override
  String get errorOtpInvalid => 'The code is incorrect.';

  @override
  String get errorOtpExpired => 'The code has expired. Request a new one.';

  @override
  String get errorOtpTooManyAttempts =>
      'Too many incorrect codes. Request a new one.';

  @override
  String get errorInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get errorTwoFactorInvalid => 'The authentication code is incorrect.';

  @override
  String get errorTwoFactorEnrollment =>
      'Set up two-factor authentication in the dashboard before signing in here.';

  @override
  String get errorNoActiveMembership =>
      'Your account isn’t active in any salon.';

  @override
  String get errorMembershipInactive => 'Your access to this salon has ended.';

  @override
  String get errorSalonSuspended => 'This salon is temporarily unavailable.';

  @override
  String get errorFeatureNotAvailable =>
      'This feature isn’t available for this salon.';

  @override
  String get errorSessionEnded => 'For your security, please sign in again.';

  @override
  String get errorChallengeExpired =>
      'This step has expired. Please start again.';

  @override
  String get errorRequestInProgress =>
      'This request is already being processed.';
}
