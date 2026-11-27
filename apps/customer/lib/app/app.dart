import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalWidgetsLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/router.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

const supportedLocales = [Locale('ar'), Locale('en')];

const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  SbLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class CustomerApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Arabic until the user picks; Directionality follows the locale (no per-widget hacks).
    final locale = ref.watch(appLocaleProvider) ?? const Locale('ar');
    final online = ref.watch(onlineProvider).value ?? true;

    return MaterialApp.router(
      title: 'Smart Barber',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      theme: SbTheme.build(Brightness.light, languageCode: locale.languageCode),
      darkTheme: SbTheme.build(Brightness.dark, languageCode: locale.languageCode),
      themeMode: ref.watch(appThemeModeProvider),
      builder: (context, child) => Column(
        children: [
          if (!online) const SbOfflineBanner(),
          Expanded(child: child ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
