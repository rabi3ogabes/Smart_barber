import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.signOutConfirmTitle),
        content: Text(l.signOutConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(sb.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(sb.signOut)),
        ],
      ),
    );
    if (ok ?? false) await ref.read(customerSessionProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final session = ref.watch(customerSessionProvider).value;
    final account = session is SignedIn ? session.account : null;
    final locale = ref.watch(appLocaleProvider)?.languageCode ?? 'ar';
    final mode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(SbSpace.xl),
        children: [
          SbCard(
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: context.sbColors.accentSoft, child: Icon(Icons.person_rounded, color: context.sbColors.accent)),
                const SizedBox(width: SbSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((account?.name?.isNotEmpty ?? false) ? account!.name! : l.profileGuestName, style: context.sbText.titleMedium),
                      if (account != null)
                        Text(account.phone, textDirection: TextDirection.ltr, style: context.sbText.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpace.xl),
          Text(l.profileLanguage, style: context.sbText.titleSmall),
          const SizedBox(height: SbSpace.xs),
          Wrap(
            spacing: SbSpace.xs,
            children: [
              SbChip(label: sb.languageArabic, selected: locale == 'ar', onTap: () => ref.read(appLocaleProvider.notifier).set(const Locale('ar'))),
              SbChip(label: sb.languageEnglish, selected: locale == 'en', onTap: () => ref.read(appLocaleProvider.notifier).set(const Locale('en'))),
            ],
          ),
          const SizedBox(height: SbSpace.lg),
          Text(l.profileTheme, style: context.sbText.titleSmall),
          const SizedBox(height: SbSpace.xs),
          Wrap(
            spacing: SbSpace.xs,
            children: [
              for (final (m, label) in [(ThemeMode.light, sb.themeLight), (ThemeMode.dark, sb.themeDark), (ThemeMode.system, sb.themeSystem)])
                SbChip(label: label, selected: mode == m, onTap: () => ref.read(appThemeModeProvider.notifier).set(m)),
            ],
          ),
          const SizedBox(height: SbSpace.xxl),
          SbButton(label: sb.signOut, icon: Icons.logout_rounded, variant: SbButtonVariant.secondary, expand: true, onPressed: () => _confirmSignOut(context, ref)),
        ],
      ),
    );
  }
}
