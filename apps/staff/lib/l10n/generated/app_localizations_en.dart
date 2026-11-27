// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Barber Staff';

  @override
  String get loginTitle => 'Staff sign in';

  @override
  String get loginSubtitle =>
      'Use the email and password from your salon invitation.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get twoFactorTitle => 'Two-factor authentication';

  @override
  String get twoFactorSubtitle =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get recoverySubtitle => 'Enter one of your saved recovery codes.';

  @override
  String get code => 'Authentication code';

  @override
  String get recoveryCode => 'Recovery code';

  @override
  String get verify => 'Verify';

  @override
  String get useRecovery => 'Use a recovery code instead';

  @override
  String get useAuthenticator => 'Use the authenticator app';

  @override
  String get codeRequired => 'Enter the code.';

  @override
  String get salonPickerTitle => 'Choose a salon';

  @override
  String get salonPickerSubtitle =>
      'You work in more than one salon. You can switch later by signing in again.';

  @override
  String get sessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get startOver => 'Start over';

  @override
  String get tabToday => 'Today';

  @override
  String get tabQueue => 'Queue';

  @override
  String get tabCustomers => 'Customers';

  @override
  String get tabPos => 'POS';

  @override
  String get tabMe => 'Me';

  @override
  String get todaySoonTitle => 'Your chair, live';

  @override
  String get todaySoonBody =>
      'Today’s bookings, the next customer and your takings will appear here.';

  @override
  String get queueSoonTitle => 'Walk-in queue';

  @override
  String get queueSoonBody => 'Call the next customer and see live wait times.';

  @override
  String get customersSoonTitle => 'Customer cards';

  @override
  String get customersSoonBody =>
      'Visit history, favourite styles and notes for every client.';

  @override
  String get posSoonTitle => 'Checkout';

  @override
  String get posSoonBody => 'Take payments and tips right from your phone.';

  @override
  String get meTitle => 'Me';

  @override
  String get meSalon => 'Salon';

  @override
  String get meRoles => 'Role';

  @override
  String get meLanguage => 'Language';

  @override
  String get meTheme => 'Appearance';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleGeneralManager => 'General manager';

  @override
  String get roleBranchManager => 'Branch manager';

  @override
  String get roleReceptionist => 'Receptionist';

  @override
  String get roleBarber => 'Barber';

  @override
  String get roleAccountant => 'Accountant';

  @override
  String get roleMarketingManager => 'Marketing manager';

  @override
  String get roleInventoryManager => 'Inventory manager';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody =>
      'You’ll need your password to sign in again.';
}
