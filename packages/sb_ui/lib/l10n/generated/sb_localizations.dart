import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'sb_localizations_ar.dart';
import 'sb_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SbLocalizations
/// returned by `SbLocalizations.of(context)`.
///
/// Applications need to include `SbLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/sb_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SbLocalizations.localizationsDelegates,
///   supportedLocales: SbLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SbLocalizations.supportedLocales
/// property.
abstract class SbLocalizations {
  SbLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SbLocalizations of(BuildContext context) {
    return Localizations.of<SbLocalizations>(context, SbLocalizations)!;
  }

  static const LocalizationsDelegate<SbLocalizations> delegate =
      _SbLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You’re offline. Showing saved information; changes need a connection.'**
  String get offlineBanner;

  /// No description provided for @offlineAction.
  ///
  /// In en, this message translates to:
  /// **'You’re offline. Connect to the internet and try again.'**
  String get offlineAction;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load this. Check your connection and try again.'**
  String get errorBody;

  /// No description provided for @noPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'You don’t have access'**
  String get noPermissionTitle;

  /// No description provided for @noPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Ask the salon owner to give your role access to this screen.'**
  String get noPermissionBody;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @errorNetworkOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your connection and try again.'**
  String get errorNetworkOffline;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to answer. Please try again.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields.'**
  String get errorValidation;

  /// No description provided for @errorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorUnauthenticated;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don’t have permission to do this.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find what you were looking for.'**
  String get errorNotFound;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again shortly.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect.'**
  String get errorOtpInvalid;

  /// No description provided for @errorOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'The code has expired. Request a new one.'**
  String get errorOtpExpired;

  /// No description provided for @errorOtpTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many incorrect codes. Request a new one.'**
  String get errorOtpTooManyAttempts;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorTwoFactorInvalid.
  ///
  /// In en, this message translates to:
  /// **'The authentication code is incorrect.'**
  String get errorTwoFactorInvalid;

  /// No description provided for @errorTwoFactorEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Set up two-factor authentication in the dashboard before signing in here.'**
  String get errorTwoFactorEnrollment;

  /// No description provided for @errorNoActiveMembership.
  ///
  /// In en, this message translates to:
  /// **'Your account isn’t active in any salon.'**
  String get errorNoActiveMembership;

  /// No description provided for @errorMembershipInactive.
  ///
  /// In en, this message translates to:
  /// **'Your access to this salon has ended.'**
  String get errorMembershipInactive;

  /// No description provided for @errorSalonSuspended.
  ///
  /// In en, this message translates to:
  /// **'This salon is temporarily unavailable.'**
  String get errorSalonSuspended;

  /// No description provided for @errorFeatureNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This feature isn’t available for this salon.'**
  String get errorFeatureNotAvailable;

  /// No description provided for @errorSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'For your security, please sign in again.'**
  String get errorSessionEnded;

  /// No description provided for @errorChallengeExpired.
  ///
  /// In en, this message translates to:
  /// **'This step has expired. Please start again.'**
  String get errorChallengeExpired;

  /// No description provided for @errorRequestInProgress.
  ///
  /// In en, this message translates to:
  /// **'This request is already being processed.'**
  String get errorRequestInProgress;
}

class _SbLocalizationsDelegate extends LocalizationsDelegate<SbLocalizations> {
  const _SbLocalizationsDelegate();

  @override
  Future<SbLocalizations> load(Locale locale) {
    return SynchronousFuture<SbLocalizations>(lookupSbLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SbLocalizationsDelegate old) => false;
}

SbLocalizations lookupSbLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SbLocalizationsAr();
    case 'en':
      return SbLocalizationsEn();
  }

  throw FlutterError(
    'SbLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
