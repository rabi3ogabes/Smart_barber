// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سمارت باربر للفريق';

  @override
  String get loginTitle => 'دخول الفريق';

  @override
  String get loginSubtitle => 'استخدم البريد وكلمة المرور من دعوة صالونك.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً.';

  @override
  String get passwordRequired => 'أدخل كلمة المرور.';

  @override
  String get twoFactorTitle => 'المصادقة الثنائية';

  @override
  String get twoFactorSubtitle =>
      'أدخل الرمز المكوّن من 6 أرقام من تطبيق المصادقة.';

  @override
  String get recoverySubtitle => 'أدخل أحد رموز الاسترداد التي حفظتها.';

  @override
  String get code => 'رمز المصادقة';

  @override
  String get recoveryCode => 'رمز الاسترداد';

  @override
  String get verify => 'تحقق';

  @override
  String get useRecovery => 'استخدم رمز استرداد بدلاً من ذلك';

  @override
  String get useAuthenticator => 'استخدم تطبيق المصادقة';

  @override
  String get codeRequired => 'أدخل الرمز.';

  @override
  String get salonPickerTitle => 'اختر الصالون';

  @override
  String get salonPickerSubtitle =>
      'تعمل في أكثر من صالون. يمكنك التبديل لاحقاً بتسجيل الدخول مرة أخرى.';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get startOver => 'البدء من جديد';

  @override
  String get tabToday => 'اليوم';

  @override
  String get tabQueue => 'الطابور';

  @override
  String get tabCustomers => 'العملاء';

  @override
  String get tabPos => 'الدفع';

  @override
  String get tabMe => 'أنا';

  @override
  String get todaySoonTitle => 'كرسيك مباشرة';

  @override
  String get todaySoonBody => 'ستظهر هنا حجوزات اليوم والعميل التالي ودخلك.';

  @override
  String get queueSoonTitle => 'طابور الانتظار';

  @override
  String get queueSoonBody => 'نادِ العميل التالي وتابع أوقات الانتظار مباشرة.';

  @override
  String get customersSoonTitle => 'بطاقات العملاء';

  @override
  String get customersSoonBody =>
      'سجل الزيارات والقصات المفضلة والملاحظات لكل عميل.';

  @override
  String get posSoonTitle => 'الدفع';

  @override
  String get posSoonBody => 'استلم المدفوعات والإكراميات من جوالك مباشرة.';

  @override
  String get meTitle => 'أنا';

  @override
  String get meSalon => 'الصالون';

  @override
  String get meRoles => 'الدور';

  @override
  String get meLanguage => 'اللغة';

  @override
  String get meTheme => 'المظهر';

  @override
  String get roleOwner => 'المالك';

  @override
  String get roleGeneralManager => 'المدير العام';

  @override
  String get roleBranchManager => 'مدير الفرع';

  @override
  String get roleReceptionist => 'موظف الاستقبال';

  @override
  String get roleBarber => 'حلاق';

  @override
  String get roleAccountant => 'المحاسب';

  @override
  String get roleMarketingManager => 'مدير التسويق';

  @override
  String get roleInventoryManager => 'مدير المخزون';

  @override
  String get signOutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get signOutConfirmBody =>
      'ستحتاج إلى كلمة المرور لتسجيل الدخول مرة أخرى.';
}
