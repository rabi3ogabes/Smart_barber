import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_staff/app/preferences_controllers.dart';
import 'package:smartbarber_staff/app/session.dart';
import 'package:smartbarber_staff/l10n/generated/app_localizations.dart';

class MeScreen extends ConsumerWidget {
  const new({super.key});

  String _role(AppLocalizations l, String role) => switch (role) {
    'owner' => l.roleOwner,
    'general_manager' => l.roleGeneralManager,
    'branch_manager' => l.roleBranchManager,
    'receptionist' => l.roleReceptionist,
    'barber' => l.roleBarber,
    'accountant' => l.roleAccountant,
    'marketing_manager' => l.roleMarketingManager,
    'inventory_manager' => l.roleInventoryManager,
    _ => role,
  };

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
    if (ok ?? false) await ref.read(staffSessionProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final session = ref.watch(staffSessionProvider).value;
    final me = session is StaffSignedInState ? session.me : null;
    final language = Localizations.localeOf(context).languageCode;
    final mode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.meTitle)),
      body: me == null
          ? const SbSkeletonList(lines: 3)
          : ListView(
              padding: const EdgeInsetsDirectional.all(SbSpace.xl),
              children: [
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(me.user.name, style: context.sbText.titleMedium),
                      if (me.user.email != null) Text(me.user.email!, textDirection: TextDirection.ltr, style: context.sbText.bodySmall),
                      const SizedBox(height: SbSpace.md),
                      Text(l.meSalon, style: context.sbText.labelSmall),
                      Text(localize(me.salon?.name, language), style: context.sbText.bodyLarge),
                      const SizedBox(height: SbSpace.sm),
                      Text(l.meRoles, style: context.sbText.labelSmall),
                      const SizedBox(height: SbSpace.xxs),
                      Wrap(spacing: SbSpace.xs, children: [for (final r in me.roles) SbBadge(label: _role(l, r), tone: SbTone.accent)]),
                    ],
                  ),
                ),
                const SizedBox(height: SbSpace.xl),
                Text(l.meLanguage, style: context.sbText.titleSmall),
                const SizedBox(height: SbSpace.xs),
                Wrap(
                  spacing: SbSpace.xs,
                  children: [
                    SbChip(label: sb.languageArabic, selected: language == 'ar', onTap: () => ref.read(appLocaleProvider.notifier).set(const Locale('ar'))),
                    SbChip(label: sb.languageEnglish, selected: language == 'en', onTap: () => ref.read(appLocaleProvider.notifier).set(const Locale('en'))),
                  ],
                ),
                const SizedBox(height: SbSpace.lg),
                Text(l.meTheme, style: context.sbText.titleSmall),
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
