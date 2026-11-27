import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smartbarber_customer/app/providers.dart';

part 'preferences_controllers.g.dart';

/// App language; null until the user picks one on first launch.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale? build() {
    final code = ref.watch(preferencesProvider).localeCode;
    return code == null ? null : Locale(code);
  }

  Future<void> set(Locale locale) async {
    state = locale;
    await ref.read(preferencesProvider).setLocaleCode(locale.languageCode);
  }
}

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() => ThemeMode.values.firstWhere(
    (m) => m.name == ref.watch(preferencesProvider).themeMode,
    orElse: () => ThemeMode.system,
  );

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(preferencesProvider).setThemeMode(mode.name);
  }
}
