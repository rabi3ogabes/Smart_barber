import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Barber'**
  String get appTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'اختر لغتك'**
  String get languageSubtitle;

  /// No description provided for @languageChangeLater.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in your profile.'**
  String get languageChangeLater;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your mobile'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We’ll send you a 6-digit code.'**
  String get phoneSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'5512 3456'**
  String get phoneHint;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number.'**
  String get phoneInvalid;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent it to {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpLabel;

  /// No description provided for @otpInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 digits from the message.'**
  String get otpInvalidFormat;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get codeResent;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get tabBook;

  /// No description provided for @tabAiStudio.
  ///
  /// In en, this message translates to:
  /// **'AI Studio'**
  String get tabAiStudio;

  /// No description provided for @tabAppointments.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get tabAppointments;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @homeSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Your salon, one tap away'**
  String get homeSoonTitle;

  /// No description provided for @homeSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Your next appointment, favourite services and rewards will appear here.'**
  String get homeSoonBody;

  /// No description provided for @bookSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking opens soon'**
  String get bookSoonTitle;

  /// No description provided for @bookSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a service, your barber and a time — all in a few taps.'**
  String get bookSoonBody;

  /// No description provided for @aiSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Try a style on your own photo'**
  String get aiSoonTitle;

  /// No description provided for @aiSoonBody.
  ///
  /// In en, this message translates to:
  /// **'AI Hair Studio is coming soon. Preview a cut before you book it.'**
  String get aiSoonBody;

  /// No description provided for @appointmentsSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get appointmentsSoonTitle;

  /// No description provided for @appointmentsSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Upcoming and past visits will be listed here.'**
  String get appointmentsSoonBody;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileGuestName.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get profileGuestName;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileTheme;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String profileVersion(String version);

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You’ll need a new code to sign in again.'**
  String get signOutConfirmBody;

  /// No description provided for @greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(String greeting, String name);

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account was deleted. Your salons keep only anonymous records.'**
  String get accountDeleted;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get addToCalendar;

  /// No description provided for @anyBarber.
  ///
  /// In en, this message translates to:
  /// **'Any available barber'**
  String get anyBarber;

  /// No description provided for @anyBarberHint.
  ///
  /// In en, this message translates to:
  /// **'We’ll seat you with the first free barber.'**
  String get anyBarberHint;

  /// No description provided for @bookAgain.
  ///
  /// In en, this message translates to:
  /// **'Book again: {services}'**
  String bookAgain(String services);

  /// No description provided for @bookAnother.
  ///
  /// In en, this message translates to:
  /// **'Book another'**
  String get bookAnother;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingCancelled;

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re booked'**
  String get bookingConfirmedTitle;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get bookingDetailTitle;

  /// No description provided for @bookingPendingBody.
  ///
  /// In en, this message translates to:
  /// **'The salon will confirm shortly. We’ll let you know.'**
  String get bookingPendingBody;

  /// No description provided for @bookingPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get bookingPendingTitle;

  /// No description provided for @branchPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a branch'**
  String get branchPickerTitle;

  /// No description provided for @bundlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get bundlesTitle;

  /// No description provided for @callSalon.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callSalon;

  /// No description provided for @cameraPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access in Settings, or type the salon code instead.'**
  String get cameraPermissionBody;

  /// No description provided for @cameraPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off'**
  String get cameraPermissionTitle;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The camera isn’t available'**
  String get cameraUnavailable;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingBody.
  ///
  /// In en, this message translates to:
  /// **'This frees the time for someone else.'**
  String get cancelBookingBody;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this appointment?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelPolicy.
  ///
  /// In en, this message translates to:
  /// **'Free changes until {day}, {time}. After that, please call the salon.'**
  String cancelPolicy(String day, String time);

  /// No description provided for @cancelPolicyAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can change or cancel up to the start time.'**
  String get cancelPolicyAnytime;

  /// No description provided for @cannotRescheduleBody.
  ///
  /// In en, this message translates to:
  /// **'This appointment can no longer be changed in the app. Please call the salon.'**
  String get cannotRescheduleBody;

  /// No description provided for @cannotRescheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Can’t change this appointment'**
  String get cannotRescheduleTitle;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @closedToday.
  ///
  /// In en, this message translates to:
  /// **'Closed today'**
  String get closedToday;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @confirmNewTime.
  ///
  /// In en, this message translates to:
  /// **'Confirm new time'**
  String get confirmNewTime;

  /// No description provided for @currentSalon.
  ///
  /// In en, this message translates to:
  /// **'Your salon'**
  String get currentSalon;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'You’ll be signed out on every device. Your name and number are removed from every salon you visited; receipts stay as anonymous records. This can’t be undone.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Removes your profile, photo and visit notes.'**
  String get deleteAccountHint;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String durationHours(int hours);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepBooking;

  /// No description provided for @loyaltySoonBody.
  ///
  /// In en, this message translates to:
  /// **'Earn rewards on every visit. Coming to this salon soon.'**
  String get loyaltySoonBody;

  /// No description provided for @loyaltySoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get loyaltySoonTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameLabel;

  /// No description provided for @nextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next appointment'**
  String get nextAppointment;

  /// No description provided for @noBranchesBody.
  ///
  /// In en, this message translates to:
  /// **'This salon has no open branch right now.'**
  String get noBranchesBody;

  /// No description provided for @noBranchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No branch available'**
  String get noBranchesTitle;

  /// No description provided for @noNextAppointment.
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming appointment.'**
  String get noNextAppointment;

  /// No description provided for @noPastBody.
  ///
  /// In en, this message translates to:
  /// **'Completed and cancelled visits appear here.'**
  String get noPastBody;

  /// No description provided for @noPastTitle.
  ///
  /// In en, this message translates to:
  /// **'No past visits'**
  String get noPastTitle;

  /// No description provided for @noServicesBody.
  ///
  /// In en, this message translates to:
  /// **'This branch has no services you can book online yet.'**
  String get noServicesBody;

  /// No description provided for @noServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No services online'**
  String get noServicesTitle;

  /// No description provided for @noSlotsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another day or another barber.'**
  String get noSlotsBody;

  /// No description provided for @noSlotsTitle.
  ///
  /// In en, this message translates to:
  /// **'No free times this day'**
  String get noSlotsTitle;

  /// No description provided for @noUpcomingBody.
  ///
  /// In en, this message translates to:
  /// **'Book your next visit in a few taps.'**
  String get noUpcomingBody;

  /// No description provided for @noUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming visits'**
  String get noUpcomingTitle;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything the barber should know'**
  String get notesHint;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get notesLabel;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettings;

  /// No description provided for @notifyBookingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Booking updates'**
  String get notifyBookingUpdates;

  /// No description provided for @notifyBookingUpdatesHint.
  ///
  /// In en, this message translates to:
  /// **'Confirmations, changes and cancellations.'**
  String get notifyBookingUpdatesHint;

  /// No description provided for @notifyOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get notifyOffers;

  /// No description provided for @notifyOffersHint.
  ///
  /// In en, this message translates to:
  /// **'Promotions from salons you visit.'**
  String get notifyOffersHint;

  /// No description provided for @notifyReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notifyReminders;

  /// No description provided for @notifyRemindersHint.
  ///
  /// In en, this message translates to:
  /// **'A day before and two hours before your appointment.'**
  String get notifyRemindersHint;

  /// No description provided for @notifySystemHint.
  ///
  /// In en, this message translates to:
  /// **'You can also turn notifications off in your phone’s settings.'**
  String get notifySystemHint;

  /// No description provided for @openToday.
  ///
  /// In en, this message translates to:
  /// **'Open today {hours}'**
  String openToday(String hours);

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @payAtSalon.
  ///
  /// In en, this message translates to:
  /// **'You pay at the salon.'**
  String get payAtSalon;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated.'**
  String get photoUpdated;

  /// No description provided for @popularServices.
  ///
  /// In en, this message translates to:
  /// **'Popular services'**
  String get popularServices;

  /// No description provided for @rateLastVisit.
  ///
  /// In en, this message translates to:
  /// **'How was your last visit?'**
  String get rateLastVisit;

  /// No description provided for @rateLastVisitWith.
  ///
  /// In en, this message translates to:
  /// **'How was your visit with {barber}?'**
  String rateLastVisitWith(String barber);

  /// No description provided for @rateVisit.
  ///
  /// In en, this message translates to:
  /// **'Rate your visit'**
  String get rateVisit;

  /// No description provided for @rateVisitBody.
  ///
  /// In en, this message translates to:
  /// **'Your rating helps the salon and other customers.'**
  String get rateVisitBody;

  /// No description provided for @rateVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate your visit'**
  String get rateVisitTitle;

  /// No description provided for @ratingCommentHint.
  ///
  /// In en, this message translates to:
  /// **'What did you like? What could be better?'**
  String get ratingCommentHint;

  /// No description provided for @ratingCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get ratingCommentLabel;

  /// No description provided for @ratingRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose 1 to 5 stars.'**
  String get ratingRequired;

  /// No description provided for @ratingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send rating'**
  String get ratingSubmit;

  /// No description provided for @ratingThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your rating.'**
  String get ratingThanks;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @rescheduleCurrent.
  ///
  /// In en, this message translates to:
  /// **'Currently {day} at {time}'**
  String rescheduleCurrent(String day, String time);

  /// No description provided for @rescheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment moved.'**
  String get rescheduled;

  /// No description provided for @salonBranches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 branch} other{{count} branches}}'**
  String salonBranches(int count);

  /// No description provided for @salonChooseAnother.
  ///
  /// In en, this message translates to:
  /// **'Choose another salon'**
  String get salonChooseAnother;

  /// No description provided for @salonCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. elite-barbers'**
  String get salonCodeHint;

  /// No description provided for @salonCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Salon code or link'**
  String get salonCodeLabel;

  /// No description provided for @salonCodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find this salon.'**
  String get salonCodeNotFound;

  /// No description provided for @salonCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the salon code or link.'**
  String get salonCodeRequired;

  /// No description provided for @salonEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code at the salon, use its link, or enter its code.'**
  String get salonEntrySubtitle;

  /// No description provided for @salonEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your salon'**
  String get salonEntryTitle;

  /// No description provided for @salonLinkNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'The link may be old or the salon may be closed.'**
  String get salonLinkNotFoundBody;

  /// No description provided for @salonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open salon'**
  String get salonOpen;

  /// No description provided for @salonScanHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the salon’s QR code.'**
  String get salonScanHint;

  /// No description provided for @salonScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get salonScanQr;

  /// No description provided for @salonSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No salons found'**
  String get salonSearchEmpty;

  /// No description provided for @salonSearchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Only salons that chose to appear in search are listed. Ask your salon for its QR code.'**
  String get salonSearchEmptyBody;

  /// No description provided for @salonSearchHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 2 letters'**
  String get salonSearchHelper;

  /// No description provided for @salonSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Salon name'**
  String get salonSearchLabel;

  /// No description provided for @salonSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get salonSearchTitle;

  /// No description provided for @salonYours.
  ///
  /// In en, this message translates to:
  /// **'Your salons'**
  String get salonYours;

  /// No description provided for @salonYoursEmpty.
  ///
  /// In en, this message translates to:
  /// **'Salons you book with will appear here.'**
  String get salonYoursEmpty;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @slotTakenAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Next free times'**
  String get slotTakenAlternatives;

  /// No description provided for @slotTakenMessage.
  ///
  /// In en, this message translates to:
  /// **'Someone just booked that time. Please pick another one.'**
  String get slotTakenMessage;

  /// No description provided for @specialtyBeard.
  ///
  /// In en, this message translates to:
  /// **'Beard'**
  String get specialtyBeard;

  /// No description provided for @specialtyClassicCut.
  ///
  /// In en, this message translates to:
  /// **'Classic cut'**
  String get specialtyClassicCut;

  /// No description provided for @specialtyColoring.
  ///
  /// In en, this message translates to:
  /// **'Colouring'**
  String get specialtyColoring;

  /// No description provided for @specialtyFacial.
  ///
  /// In en, this message translates to:
  /// **'Facial'**
  String get specialtyFacial;

  /// No description provided for @specialtyFade.
  ///
  /// In en, this message translates to:
  /// **'Fade'**
  String get specialtyFade;

  /// No description provided for @specialtyKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get specialtyKids;

  /// No description provided for @specialtyLongHair.
  ///
  /// In en, this message translates to:
  /// **'Long hair'**
  String get specialtyLongHair;

  /// No description provided for @specialtyShave.
  ///
  /// In en, this message translates to:
  /// **'Shave'**
  String get specialtyShave;

  /// No description provided for @specialtyStyling.
  ///
  /// In en, this message translates to:
  /// **'Styling'**
  String get specialtyStyling;

  /// No description provided for @starsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String starsLabel(int count);

  /// No description provided for @statusArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get statusArrived;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusInService.
  ///
  /// In en, this message translates to:
  /// **'In the chair'**
  String get statusInService;

  /// No description provided for @statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusNoShow;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting confirmation'**
  String get statusPending;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get statusUnknown;

  /// No description provided for @stepBarber.
  ///
  /// In en, this message translates to:
  /// **'Choose your barber'**
  String get stepBarber;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @stepServices.
  ///
  /// In en, this message translates to:
  /// **'Choose services'**
  String get stepServices;

  /// No description provided for @stepSummary.
  ///
  /// In en, this message translates to:
  /// **'Review and confirm'**
  String get stepSummary;

  /// No description provided for @stepTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get stepTime;

  /// No description provided for @switchSalon.
  ///
  /// In en, this message translates to:
  /// **'Change salon'**
  String get switchSalon;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get tax;

  /// No description provided for @timelineRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get timelineRescheduled;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get timelineTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @viewBooking.
  ///
  /// In en, this message translates to:
  /// **'View appointment'**
  String get viewBooking;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRating;

  /// No description provided for @cannotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t open this on your phone.'**
  String get cannotOpenLink;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
