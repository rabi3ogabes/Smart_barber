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

  @override
  String get accountDeleted =>
      'Your account was deleted. Your salons keep only anonymous records.';

  @override
  String get addToCalendar => 'Add to calendar';

  @override
  String get anyBarber => 'Any available barber';

  @override
  String get anyBarberHint => 'We’ll seat you with the first free barber.';

  @override
  String bookAgain(String services) {
    return 'Book again: $services';
  }

  @override
  String get bookAnother => 'Book another';

  @override
  String get bookNow => 'Book now';

  @override
  String get bookingCancelled => 'Booking cancelled.';

  @override
  String get bookingConfirmedTitle => 'You’re booked';

  @override
  String get bookingDetailTitle => 'Appointment';

  @override
  String get bookingPendingBody =>
      'The salon will confirm shortly. We’ll let you know.';

  @override
  String get bookingPendingTitle => 'Request sent';

  @override
  String get branchPickerTitle => 'Choose a branch';

  @override
  String get bundlesTitle => 'Packages';

  @override
  String get callSalon => 'Call';

  @override
  String get cameraPermissionBody =>
      'Allow camera access in Settings, or type the salon code instead.';

  @override
  String get cameraPermissionTitle => 'Camera access is off';

  @override
  String get cameraUnavailable => 'The camera isn’t available';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelBookingBody => 'This frees the time for someone else.';

  @override
  String get cancelBookingTitle => 'Cancel this appointment?';

  @override
  String cancelPolicy(String day, String time) {
    return 'Free changes until $day, $time. After that, please call the salon.';
  }

  @override
  String get cancelPolicyAnytime =>
      'You can change or cancel up to the start time.';

  @override
  String get cannotRescheduleBody =>
      'This appointment can no longer be changed in the app. Please call the salon.';

  @override
  String get cannotRescheduleTitle => 'Can’t change this appointment';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get closedToday => 'Closed today';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get confirmNewTime => 'Confirm new time';

  @override
  String get currentSalon => 'Your salon';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountBody =>
      'You’ll be signed out on every device. Your name and number are removed from every salon you visited; receipts stay as anonymous records. This can’t be undone.';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get deleteAccountHint =>
      'Removes your profile, photo and visit notes.';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get directions => 'Directions';

  @override
  String get discount => 'Discount';

  @override
  String durationHours(int hours) {
    return '$hours h';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get editName => 'Edit name';

  @override
  String get keepBooking => 'Keep it';

  @override
  String get loyaltySoonBody =>
      'Earn rewards on every visit. Coming to this salon soon.';

  @override
  String get loyaltySoonTitle => 'Rewards';

  @override
  String get nameLabel => 'Your name';

  @override
  String get nextAppointment => 'Next appointment';

  @override
  String get noBranchesBody => 'This salon has no open branch right now.';

  @override
  String get noBranchesTitle => 'No branch available';

  @override
  String get noNextAppointment => 'You have no upcoming appointment.';

  @override
  String get noPastBody => 'Completed and cancelled visits appear here.';

  @override
  String get noPastTitle => 'No past visits';

  @override
  String get noServicesBody =>
      'This branch has no services you can book online yet.';

  @override
  String get noServicesTitle => 'No services online';

  @override
  String get noSlotsBody => 'Try another day or another barber.';

  @override
  String get noSlotsTitle => 'No free times this day';

  @override
  String get noUpcomingBody => 'Book your next visit in a few taps.';

  @override
  String get noUpcomingTitle => 'No upcoming visits';

  @override
  String get notesHint => 'Anything the barber should know';

  @override
  String get notesLabel => 'Note (optional)';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get notifyBookingUpdates => 'Booking updates';

  @override
  String get notifyBookingUpdatesHint =>
      'Confirmations, changes and cancellations.';

  @override
  String get notifyOffers => 'Offers';

  @override
  String get notifyOffersHint => 'Promotions from salons you visit.';

  @override
  String get notifyReminders => 'Reminders';

  @override
  String get notifyRemindersHint =>
      'A day before and two hours before your appointment.';

  @override
  String get notifySystemHint =>
      'You can also turn notifications off in your phone’s settings.';

  @override
  String openToday(String hours) {
    return 'Open today $hours';
  }

  @override
  String get past => 'Past';

  @override
  String get payAtSalon => 'You pay at the salon.';

  @override
  String get photoUpdated => 'Photo updated.';

  @override
  String get popularServices => 'Popular services';

  @override
  String get rateLastVisit => 'How was your last visit?';

  @override
  String rateLastVisitWith(String barber) {
    return 'How was your visit with $barber?';
  }

  @override
  String get rateVisit => 'Rate your visit';

  @override
  String get rateVisitBody =>
      'Your rating helps the salon and other customers.';

  @override
  String get rateVisitTitle => 'Rate your visit';

  @override
  String get ratingCommentHint => 'What did you like? What could be better?';

  @override
  String get ratingCommentLabel => 'Comment (optional)';

  @override
  String get ratingRequired => 'Choose 1 to 5 stars.';

  @override
  String get ratingSubmit => 'Send rating';

  @override
  String get ratingThanks => 'Thanks for your rating.';

  @override
  String get reschedule => 'Reschedule';

  @override
  String rescheduleCurrent(String day, String time) {
    return 'Currently $day at $time';
  }

  @override
  String get rescheduled => 'Appointment moved.';

  @override
  String salonBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count branches',
      one: '1 branch',
    );
    return '$_temp0';
  }

  @override
  String get salonChooseAnother => 'Choose another salon';

  @override
  String get salonCodeHint => 'e.g. elite-barbers';

  @override
  String get salonCodeLabel => 'Salon code or link';

  @override
  String get salonCodeNotFound => 'We couldn’t find this salon.';

  @override
  String get salonCodeRequired => 'Enter the salon code or link.';

  @override
  String get salonEntrySubtitle =>
      'Scan the QR code at the salon, use its link, or enter its code.';

  @override
  String get salonEntryTitle => 'Find your salon';

  @override
  String get salonLinkNotFoundBody =>
      'The link may be old or the salon may be closed.';

  @override
  String get salonOpen => 'Open salon';

  @override
  String get salonScanHint => 'Point the camera at the salon’s QR code.';

  @override
  String get salonScanQr => 'Scan QR code';

  @override
  String get salonSearchEmpty => 'No salons found';

  @override
  String get salonSearchEmptyBody =>
      'Only salons that chose to appear in search are listed. Ask your salon for its QR code.';

  @override
  String get salonSearchHelper => 'At least 2 letters';

  @override
  String get salonSearchLabel => 'Salon name';

  @override
  String get salonSearchTitle => 'Search';

  @override
  String get salonYours => 'Your salons';

  @override
  String get salonYoursEmpty => 'Salons you book with will appear here.';

  @override
  String get save => 'Save';

  @override
  String get servicesTitle => 'Services';

  @override
  String get slotTakenAlternatives => 'Next free times';

  @override
  String get slotTakenMessage =>
      'Someone just booked that time. Please pick another one.';

  @override
  String get specialtyBeard => 'Beard';

  @override
  String get specialtyClassicCut => 'Classic cut';

  @override
  String get specialtyColoring => 'Colouring';

  @override
  String get specialtyFacial => 'Facial';

  @override
  String get specialtyFade => 'Fade';

  @override
  String get specialtyKids => 'Kids';

  @override
  String get specialtyLongHair => 'Long hair';

  @override
  String get specialtyShave => 'Shave';

  @override
  String get specialtyStyling => 'Styling';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get statusArrived => 'Arrived';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusInService => 'In the chair';

  @override
  String get statusNoShow => 'Missed';

  @override
  String get statusPending => 'Awaiting confirmation';

  @override
  String get statusUnknown => 'Updated';

  @override
  String get stepBarber => 'Choose your barber';

  @override
  String stepOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get stepServices => 'Choose services';

  @override
  String get stepSummary => 'Review and confirm';

  @override
  String get stepTime => 'Pick a time';

  @override
  String get switchSalon => 'Change salon';

  @override
  String get tax => 'VAT';

  @override
  String get timelineRescheduled => 'Rescheduled';

  @override
  String get timelineTitle => 'History';

  @override
  String get today => 'Today';

  @override
  String get total => 'Total';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get viewBooking => 'View appointment';

  @override
  String get yourRating => 'Your rating';

  @override
  String get cannotOpenLink => 'We couldn’t open this on your phone.';
}
