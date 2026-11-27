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
}
