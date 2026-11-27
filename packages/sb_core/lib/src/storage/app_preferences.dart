import 'package:shared_preferences/shared_preferences.dart';

/// Non-secret preferences: language, theme, onboarding flags (flutter.md, Storage).
class AppPreferences {
  new(this._prefs);

  /// Loads the platform preferences.
  static Future<AppPreferences> load() async => AppPreferences(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  static const _locale = 'sb.locale';
  static const _theme = 'sb.theme';

  /// Saved language code, or null before the user picked one.
  String? get localeCode => _prefs.getString(_locale);

  Future<void> setLocaleCode(String code) => _prefs.setString(_locale, code);

  /// Saved theme mode name (`light`, `dark`, `system`).
  String? get themeMode => _prefs.getString(_theme);

  Future<void> setThemeMode(String mode) => _prefs.setString(_theme, mode);

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) => _prefs.setString(key, value);
}
