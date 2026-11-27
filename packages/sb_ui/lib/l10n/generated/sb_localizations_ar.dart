// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'sb_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SbLocalizationsAr extends SbLocalizations {
  SbLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get retry => 'حاول مرة أخرى';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get back => 'رجوع';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get offlineBanner =>
      'أنت غير متصل. نعرض المعلومات المحفوظة؛ التغييرات تحتاج إلى اتصال.';

  @override
  String get offlineAction => 'أنت غير متصل. اتصل بالإنترنت وحاول مرة أخرى.';

  @override
  String get emptyTitle => 'لا يوجد شيء بعد';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get errorBody => 'تعذّر التحميل. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get noPermissionTitle => 'ليست لديك صلاحية';

  @override
  String get noPermissionBody =>
      'اطلب من مالك الصالون منح دورك صلاحية الوصول إلى هذه الشاشة.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get errorNetworkOffline =>
      'لا يوجد اتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get errorNetworkTimeout =>
      'تأخر الخادم في الرد. يرجى المحاولة مرة أخرى.';

  @override
  String get errorGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get errorValidation => 'يرجى مراجعة الحقول المحددة.';

  @override
  String get errorUnauthenticated => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorForbidden => 'ليست لديك صلاحية للقيام بذلك.';

  @override
  String get errorNotFound => 'لم نتمكن من العثور على ما تبحث عنه.';

  @override
  String get errorRateLimited =>
      'محاولات كثيرة. يرجى الانتظار قليلاً ثم المحاولة مرة أخرى.';

  @override
  String get errorServiceUnavailable =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة بعد قليل.';

  @override
  String get errorOtpInvalid => 'الرمز غير صحيح.';

  @override
  String get errorOtpExpired => 'انتهت صلاحية الرمز. اطلب رمزاً جديداً.';

  @override
  String get errorOtpTooManyAttempts => 'رموز خاطئة كثيرة. اطلب رمزاً جديداً.';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorTwoFactorInvalid => 'رمز المصادقة غير صحيح.';

  @override
  String get errorTwoFactorEnrollment =>
      'فعّل المصادقة الثنائية من لوحة التحكم قبل تسجيل الدخول هنا.';

  @override
  String get errorNoActiveMembership => 'حسابك غير مفعّل في أي صالون.';

  @override
  String get errorMembershipInactive => 'انتهت صلاحية وصولك إلى هذا الصالون.';

  @override
  String get errorSalonSuspended => 'هذا الصالون غير متاح مؤقتاً.';

  @override
  String get errorFeatureNotAvailable => 'هذه الميزة غير متاحة لهذا الصالون.';

  @override
  String get errorSessionEnded =>
      'حفاظاً على أمانك، يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorChallengeExpired =>
      'انتهت صلاحية هذه الخطوة. يرجى البدء من جديد.';

  @override
  String get errorRequestInProgress => 'هذا الطلب قيد المعالجة بالفعل.';
}
