// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Barber';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle => 'اختر لغتك';

  @override
  String get languageChangeLater =>
      'You can change this later in your profile.';

  @override
  String get phoneTitle => 'Sign in with your mobile';

  @override
  String get phoneSubtitle => 'We’ll send you a 6-digit code.';

  @override
  String get phoneLabel => 'Mobile number';

  @override
  String get phoneHint => '5512 3456';

  @override
  String get phoneInvalid => 'Enter a valid mobile number.';

  @override
  String get sendCode => 'Send code';

  @override
  String get sessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSubtitle(String phone) {
    return 'We sent it to $phone';
  }

  @override
  String get otpLabel => '6-digit code';

  @override
  String get otpInvalidFormat => 'Enter the 6 digits from the message.';

  @override
  String get verify => 'Verify';

  @override
  String resendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resend => 'Resend code';

  @override
  String get codeResent => 'A new code is on its way.';

  @override
  String get changeNumber => 'Change number';

  @override
  String get tabHome => 'Home';

  @override
  String get tabBook => 'Book';

  @override
  String get tabAiStudio => 'AI Studio';

  @override
  String get tabAppointments => 'Visits';

  @override
  String get tabProfile => 'Profile';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeSoonTitle => 'Your salon, one tap away';

  @override
  String get homeSoonBody =>
      'Your next appointment, favourite services and rewards will appear here.';

  @override
  String get bookSoonTitle => 'Booking opens soon';

  @override
  String get bookSoonBody =>
      'Choose a service, your barber and a time — all in a few taps.';

  @override
  String get aiSoonTitle => 'Try a style on your own photo';

  @override
  String get aiSoonBody =>
      'AI Hair Studio is coming soon. Preview a cut before you book it.';

  @override
  String get appointmentsSoonTitle => 'No appointments yet';

  @override
  String get appointmentsSoonBody =>
      'Upcoming and past visits will be listed here.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGuestName => 'Welcome';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileTheme => 'Appearance';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody => 'You’ll need a new code to sign in again.';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }
}
