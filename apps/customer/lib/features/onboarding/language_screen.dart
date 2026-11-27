import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// First launch: pick Arabic or English. Each option is written in its own language.
class LanguageScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    Widget option(String label, String code) => Padding(
      padding: const EdgeInsetsDirectional.only(bottom: SbSpace.sm),
      child: SbCard(
        onTap: () => ref.read(appLocaleProvider.notifier).set(Locale(code)),
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.sbText.titleMedium)),
            SbDirectionalIcon(Icons.chevron_right_rounded, color: context.sbColors.textSecondary),
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(SbSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Align(alignment: AlignmentDirectional.centerStart, child: SbLogo()),
              const SizedBox(height: SbSpace.xl),
              Text(l.languageTitle, style: context.sbText.headlineMedium),
              const SizedBox(height: SbSpace.xxs),
              Text(l.languageSubtitle, style: context.sbText.bodyLarge?.copyWith(color: context.sbColors.textSecondary)),
              const SizedBox(height: SbSpace.xl),
              option(sb.languageArabic, 'ar'),
              option(sb.languageEnglish, 'en'),
              const SizedBox(height: SbSpace.xs),
              Text(l.languageChangeLater, style: context.sbText.bodySmall),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
