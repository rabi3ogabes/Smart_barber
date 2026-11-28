// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سمارت باربر';

  @override
  String get languageTitle => 'اختر لغتك';

  @override
  String get languageSubtitle => 'Choose your language';

  @override
  String get languageChangeLater => 'يمكنك تغييرها لاحقاً من ملفك الشخصي.';

  @override
  String get phoneTitle => 'سجّل الدخول برقم جوالك';

  @override
  String get phoneSubtitle => 'سنرسل إليك رمزاً من 6 أرقام.';

  @override
  String get phoneLabel => 'رقم الجوال';

  @override
  String get phoneHint => '5512 3456';

  @override
  String get phoneInvalid => 'أدخل رقم جوال صحيحاً.';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get otpTitle => 'أدخل الرمز';

  @override
  String otpSubtitle(String phone) {
    return 'أرسلناه إلى $phone';
  }

  @override
  String get otpLabel => 'الرمز المكوّن من 6 أرقام';

  @override
  String get otpInvalidFormat => 'أدخل الأرقام الستة من الرسالة.';

  @override
  String get verify => 'تحقق';

  @override
  String resendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get resend => 'إعادة إرسال الرمز';

  @override
  String get codeResent => 'رمز جديد في الطريق إليك.';

  @override
  String get changeNumber => 'تغيير الرقم';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabBook => 'احجز';

  @override
  String get tabAiStudio => 'الاستوديو';

  @override
  String get tabAppointments => 'مواعيدي';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String get homeSoonTitle => 'صالونك بلمسة واحدة';

  @override
  String get homeSoonBody => 'سيظهر هنا موعدك القادم وخدماتك المفضلة ومكافآتك.';

  @override
  String get bookSoonTitle => 'الحجز يُفتح قريباً';

  @override
  String get bookSoonBody => 'اختر الخدمة والحلاق والوقت — ببضع لمسات.';

  @override
  String get aiSoonTitle => 'جرّب القصة على صورتك';

  @override
  String get aiSoonBody =>
      'استوديو الشعر الذكي قادم قريباً. شاهد القصة قبل أن تحجزها.';

  @override
  String get appointmentsSoonTitle => 'لا توجد مواعيد بعد';

  @override
  String get appointmentsSoonBody => 'ستظهر هنا زياراتك القادمة والسابقة.';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get profileGuestName => 'أهلاً بك';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileTheme => 'المظهر';

  @override
  String profileVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get signOutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get signOutConfirmBody =>
      'ستحتاج إلى رمز جديد لتسجيل الدخول مرة أخرى.';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting، $name';
  }

  @override
  String get accountDeleted =>
      'تم حذف حسابك. تحتفظ صالوناتك بسجلات مجهولة الهوية فقط.';

  @override
  String get addToCalendar => 'أضف إلى التقويم';

  @override
  String get anyBarber => 'أي حلاق متاح';

  @override
  String get anyBarberHint => 'سنحجز لك مع أول حلاق متاح.';

  @override
  String bookAgain(String services) {
    return 'احجز مجددًا: $services';
  }

  @override
  String get bookAnother => 'احجز موعدًا آخر';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get bookingCancelled => 'تم إلغاء الحجز.';

  @override
  String get bookingConfirmedTitle => 'تم حجزك';

  @override
  String get bookingDetailTitle => 'الموعد';

  @override
  String get bookingPendingBody => 'سيؤكد الصالون قريبًا وسنخبرك.';

  @override
  String get bookingPendingTitle => 'تم إرسال الطلب';

  @override
  String get branchPickerTitle => 'اختر الفرع';

  @override
  String get bundlesTitle => 'الباقات';

  @override
  String get callSalon => 'اتصال';

  @override
  String get cameraPermissionBody =>
      'اسمح بالوصول إلى الكاميرا من الإعدادات، أو اكتب رمز الصالون.';

  @override
  String get cameraPermissionTitle => 'الوصول إلى الكاميرا مغلق';

  @override
  String get cameraUnavailable => 'الكاميرا غير متاحة';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get cancelBookingBody => 'سيصبح هذا الوقت متاحًا لغيرك.';

  @override
  String get cancelBookingTitle => 'إلغاء هذا الموعد؟';

  @override
  String cancelPolicy(String day, String time) {
    return 'التعديل مجاني حتى $day، $time. بعد ذلك يُرجى الاتصال بالصالون.';
  }

  @override
  String get cancelPolicyAnytime => 'يمكنك التعديل أو الإلغاء حتى وقت الموعد.';

  @override
  String get cannotRescheduleBody =>
      'لم يعد ممكنًا تعديل هذا الموعد من التطبيق. يُرجى الاتصال بالصالون.';

  @override
  String get cannotRescheduleTitle => 'لا يمكن تعديل هذا الموعد';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get closedToday => 'مغلق اليوم';

  @override
  String get confirm => 'تأكيد';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get confirmNewTime => 'تأكيد الوقت الجديد';

  @override
  String get currentSalon => 'صالونك';

  @override
  String get deleteAccount => 'حذف حسابي';

  @override
  String get deleteAccountBody =>
      'سيتم تسجيل خروجك من كل الأجهزة. يُحذف اسمك ورقمك من كل الصالونات التي زرتها، وتبقى الإيصالات سجلات مجهولة الهوية. لا يمكن التراجع عن ذلك.';

  @override
  String get deleteAccountConfirm => 'حذف';

  @override
  String get deleteAccountHint => 'يحذف ملفك وصورتك وملاحظات زياراتك.';

  @override
  String get deleteAccountTitle => 'حذف حسابك؟';

  @override
  String get directions => 'الاتجاهات';

  @override
  String get discount => 'الخصم';

  @override
  String durationHours(int hours) {
    return '$hours س';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get keepBooking => 'إبقاء الموعد';

  @override
  String get loyaltySoonBody =>
      'اكسب مكافآت مع كل زيارة. قريبًا في هذا الصالون.';

  @override
  String get loyaltySoonTitle => 'المكافآت';

  @override
  String get nameLabel => 'اسمك';

  @override
  String get nextAppointment => 'موعدك القادم';

  @override
  String get noBranchesBody => 'لا يوجد فرع مفتوح لهذا الصالون حاليًا.';

  @override
  String get noBranchesTitle => 'لا يوجد فرع متاح';

  @override
  String get noNextAppointment => 'ليس لديك موعد قادم.';

  @override
  String get noPastBody => 'تظهر هنا الزيارات المكتملة والملغاة.';

  @override
  String get noPastTitle => 'لا توجد زيارات سابقة';

  @override
  String get noServicesBody =>
      'لا توجد خدمات متاحة للحجز عبر الإنترنت في هذا الفرع بعد.';

  @override
  String get noServicesTitle => 'لا توجد خدمات متاحة';

  @override
  String get noSlotsBody => 'جرّب يومًا آخر أو حلاقًا آخر.';

  @override
  String get noSlotsTitle => 'لا توجد أوقات متاحة في هذا اليوم';

  @override
  String get noUpcomingBody => 'احجز زيارتك القادمة بخطوات قليلة.';

  @override
  String get noUpcomingTitle => 'لا توجد زيارات قادمة';

  @override
  String get notesHint => 'أي شيء يجب أن يعرفه الحلاق';

  @override
  String get notesLabel => 'ملاحظة (اختيارية)';

  @override
  String get notificationSettings => 'الإشعارات';

  @override
  String get notifyBookingUpdates => 'تحديثات الحجز';

  @override
  String get notifyBookingUpdatesHint => 'التأكيدات والتعديلات والإلغاءات.';

  @override
  String get notifyOffers => 'العروض';

  @override
  String get notifyOffersHint => 'عروض من الصالونات التي تزورها.';

  @override
  String get notifyReminders => 'التذكيرات';

  @override
  String get notifyRemindersHint => 'قبل يوم وقبل ساعتين من موعدك.';

  @override
  String get notifySystemHint =>
      'يمكنك أيضًا إيقاف الإشعارات من إعدادات هاتفك.';

  @override
  String openToday(String hours) {
    return 'مفتوح اليوم $hours';
  }

  @override
  String get past => 'السابقة';

  @override
  String get payAtSalon => 'الدفع في الصالون.';

  @override
  String get photoUpdated => 'تم تحديث الصورة.';

  @override
  String get popularServices => 'الخدمات الأكثر طلبًا';

  @override
  String get rateLastVisit => 'كيف كانت زيارتك الأخيرة؟';

  @override
  String rateLastVisitWith(String barber) {
    return 'كيف كانت زيارتك مع $barber؟';
  }

  @override
  String get rateVisit => 'قيّم زيارتك';

  @override
  String get rateVisitBody => 'تقييمك يساعد الصالون والعملاء الآخرين.';

  @override
  String get rateVisitTitle => 'قيّم زيارتك';

  @override
  String get ratingCommentHint => 'ما الذي أعجبك؟ وما الذي يمكن تحسينه؟';

  @override
  String get ratingCommentLabel => 'تعليق (اختياري)';

  @override
  String get ratingRequired => 'اختر من نجمة إلى خمس نجوم.';

  @override
  String get ratingSubmit => 'إرسال التقييم';

  @override
  String get ratingThanks => 'شكرًا لتقييمك.';

  @override
  String get reschedule => 'تغيير الموعد';

  @override
  String rescheduleCurrent(String day, String time) {
    return 'الموعد الحالي $day الساعة $time';
  }

  @override
  String get rescheduled => 'تم نقل الموعد.';

  @override
  String salonBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فرع',
      few: '$count فروع',
      two: 'فرعان',
      one: 'فرع واحد',
    );
    return '$_temp0';
  }

  @override
  String get salonChooseAnother => 'اختر صالونًا آخر';

  @override
  String get salonCodeHint => 'مثال: elite-barbers';

  @override
  String get salonCodeLabel => 'رمز الصالون أو رابطه';

  @override
  String get salonCodeNotFound => 'لم نجد هذا الصالون.';

  @override
  String get salonCodeRequired => 'أدخل رمز الصالون أو رابطه.';

  @override
  String get salonEntrySubtitle =>
      'امسح رمز QR في الصالون، أو استخدم رابطه، أو أدخل رمزه.';

  @override
  String get salonEntryTitle => 'ابحث عن صالونك';

  @override
  String get salonLinkNotFoundBody =>
      'قد يكون الرابط قديمًا أو أن الصالون مغلق.';

  @override
  String get salonOpen => 'فتح الصالون';

  @override
  String get salonScanHint => 'وجّه الكاميرا إلى رمز QR الخاص بالصالون.';

  @override
  String get salonScanQr => 'مسح رمز QR';

  @override
  String get salonSearchEmpty => 'لم نجد صالونات';

  @override
  String get salonSearchEmptyBody =>
      'تظهر فقط الصالونات التي اختارت الظهور في البحث. اطلب رمز QR من صالونك.';

  @override
  String get salonSearchHelper => 'حرفان على الأقل';

  @override
  String get salonSearchLabel => 'اسم الصالون';

  @override
  String get salonSearchTitle => 'البحث';

  @override
  String get salonYours => 'صالوناتك';

  @override
  String get salonYoursEmpty => 'ستظهر هنا الصالونات التي تحجز لديها.';

  @override
  String get save => 'حفظ';

  @override
  String get servicesTitle => 'الخدمات';

  @override
  String get slotTakenAlternatives => 'الأوقات المتاحة التالية';

  @override
  String get slotTakenMessage =>
      'حجز شخص آخر هذا الوقت للتو. يُرجى اختيار وقت آخر.';

  @override
  String get specialtyBeard => 'اللحية';

  @override
  String get specialtyClassicCut => 'قصة كلاسيكية';

  @override
  String get specialtyColoring => 'صبغ';

  @override
  String get specialtyFacial => 'عناية بالوجه';

  @override
  String get specialtyFade => 'تدريج';

  @override
  String get specialtyKids => 'أطفال';

  @override
  String get specialtyLongHair => 'شعر طويل';

  @override
  String get specialtyShave => 'حلاقة';

  @override
  String get specialtyStyling => 'تصفيف';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نجمة',
      few: '$count نجوم',
      two: 'نجمتان',
      one: 'نجمة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get statusArrived => 'وصل';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusInService => 'على الكرسي';

  @override
  String get statusNoShow => 'لم يحضر';

  @override
  String get statusPending => 'بانتظار التأكيد';

  @override
  String get statusUnknown => 'محدّث';

  @override
  String get stepBarber => 'اختر حلاقك';

  @override
  String stepOf(int current, int total) {
    return '$current من $total';
  }

  @override
  String get stepServices => 'اختر الخدمات';

  @override
  String get stepSummary => 'المراجعة والتأكيد';

  @override
  String get stepTime => 'اختر الوقت';

  @override
  String get switchSalon => 'تغيير الصالون';

  @override
  String get tax => 'ضريبة القيمة المضافة';

  @override
  String get timelineRescheduled => 'تم تغيير الموعد';

  @override
  String get timelineTitle => 'السجل';

  @override
  String get today => 'اليوم';

  @override
  String get total => 'الإجمالي';

  @override
  String get upcoming => 'القادمة';

  @override
  String get viewBooking => 'عرض الموعد';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get cannotOpenLink => 'تعذّر فتح هذا على هاتفك.';
}
