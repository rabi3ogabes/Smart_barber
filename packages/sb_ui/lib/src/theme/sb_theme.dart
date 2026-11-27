import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

/// Builds light and dark themes from the tokens. Screens read colours and text styles from
/// the theme only — never hard-coded values (rule 8).
abstract final class SbTheme {
  static const _package = 'sb_ui';

  /// Theme for [brightness] and the app language (Arabic uses IBM Plex Sans Arabic for UI and headings).
  static ThemeData build(Brightness brightness, {required String languageCode}) {
    final c = brightness == Brightness.dark ? SbColors.dark : SbColors.light;
    final arabic = languageCode == 'ar';
    final family = 'packages/$_package/${arabic ? SbFonts.sansArabic : SbFonts.sansLatin}';
    final fallback = ['packages/$_package/${arabic ? SbFonts.sansLatin : SbFonts.sansArabic}'];

    TextStyle style(SbTypeToken t, {Color? color, bool display = false}) => TextStyle(
      fontFamily: display && !arabic ? 'packages/$_package/${SbFonts.displayLatin}' : family,
      fontFamilyFallback: fallback,
      fontSize: t.size,
      height: t.lineHeight / t.size,
      fontWeight: FontWeight.values.firstWhere((w) => w.value == t.weight, orElse: () => FontWeight.w400),
      // Variable fonts (Inter, Fraunces) read the weight from the axis.
      fontVariations: [FontVariation.weight(t.weight.toDouble())],
      color: color ?? c.textPrimary,
    );

    final textTheme = TextTheme(
      displayLarge: style(SbType.display, display: true),
      headlineLarge: style(SbType.h1),
      headlineMedium: style(SbType.h2),
      headlineSmall: style(SbType.h3),
      titleLarge: style(SbType.h3),
      titleMedium: style(SbType.h4),
      titleSmall: style(SbType.label),
      bodyLarge: style(SbType.body),
      bodyMedium: style(SbType.body),
      bodySmall: style(SbType.caption, color: c.textSecondary),
      labelLarge: style(SbType.button),
      labelMedium: style(SbType.label),
      labelSmall: style(SbType.caption, color: c.textSecondary),
    );

    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.accent,
      onSecondary: c.onPrimary,
      error: c.error,
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      outline: c.border,
      outlineVariant: c.border,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surfaceElevated,
      surfaceContainerHighest: c.surfaceMuted,
      scrim: c.overlay,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(SbRadius.input),
      borderSide: BorderSide(color: c.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      fontFamily: family,
      fontFamilyFallback: fallback,
      textTheme: textTheme,
      extensions: [c],
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
        shape: Border(bottom: BorderSide(color: c.border)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.accentSoft,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => style(SbType.caption, color: s.contains(WidgetState.selected) ? c.textPrimary : c.textSecondary),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(color: s.contains(WidgetState.selected) ? c.accent : c.textSecondary, size: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 14),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: c.accent, width: 1.5)),
        errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: c.error)),
        focusedErrorBorder: inputBorder.copyWith(borderSide: BorderSide(color: c.error, width: 1.5)),
        hintStyle: style(SbType.body, color: c.textSecondary),
        errorStyle: style(SbType.caption, color: c.error),
        helperStyle: style(SbType.caption, color: c.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.primary,
        contentTextStyle: style(SbType.label, color: c.onPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SbRadius.card)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceElevated,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(SbRadius.sheet))),
        showDragHandle: true,
        dragHandleColor: c.border,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Token access from widgets.
extension SbThemeContext on BuildContext {
  SbColors get sbColors => Theme.of(this).extension<SbColors>() ?? SbColors.light;

  TextTheme get sbText => Theme.of(this).textTheme;

  /// True when the user asked the OS for reduced motion.
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}
