import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/preferences_controllers.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Picks a photo; replaceable in tests.
final imagePickerProvider = Provider<Future<XFile?> Function()>(
  (ref) => () => ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, maxHeight: 1600, imageQuality: 90),
);

class ProfileScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _uploading = false;
  bool _deleting = false;
  String? _deleteKey;

  Future<void> _confirmSignOut() async {
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

  Future<void> _changePhoto() async {
    final l = AppLocalizations.of(context);
    final file = await ref.read(imagePickerProvider)();
    if (file == null || !mounted) return;
    setState(() => _uploading = true);
    final result = await ref.read(customerHomeRepositoryProvider).uploadAvatar(await file.readAsBytes(), file.name);
    if (!mounted) return;
    setState(() => _uploading = false);
    switch (result) {
      case Ok(:final value):
        await ref.read(customerSessionProvider.notifier).updated(value);
        if (mounted) showMessage(context, l.photoUpdated);
      case Err(:final failure):
        showFailure(context, failure);
    }
  }

  Future<void> _editName(CustomerAccount account) async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final controller = TextEditingController(text: account.name ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.editName),
        content: SbTextField(label: l.nameLabel, controller: controller, maxLength: 120, autofillHints: const [AutofillHints.name]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(sb.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: Text(l.save)),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == account.name || !mounted) return;
    final result = await ref.read(customerAuthRepositoryProvider).updateProfile(name: name);
    if (!mounted) return;
    switch (result) {
      case Ok(:final value):
        await ref.read(customerSessionProvider.notifier).updated(value);
      case Err(:final failure):
        showFailure(context, failure);
    }
  }

  Future<void> _deleteAccount() async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteAccountTitle),
        content: Text(l.deleteAccountBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(sb.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.deleteAccountConfirm, style: TextStyle(color: context.sbColors.error)),
          ),
        ],
      ),
    );
    if (!(ok ?? false) || !mounted) return;
    setState(() => _deleting = true);
    _deleteKey ??= Idempotency.newKey();
    final result = await ref.read(customerHomeRepositoryProvider).requestDeletion(idempotencyKey: _deleteKey!);
    if (!mounted) return;
    setState(() => _deleting = false);
    switch (result) {
      case Ok():
        showMessage(context, l.accountDeleted);
        await ref.read(currentSalonProvider.notifier).clear();
        await ref.read(customerSessionProvider.notifier).accountDeleted();
      case Err(:final failure):
        showFailure(context, failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final session = ref.watch(customerSessionProvider).value;
    final account = session is SignedIn ? session.account : null;
    final locale = ref.watch(appLocaleProvider)?.languageCode ?? 'ar';
    final mode = ref.watch(appThemeModeProvider);
    final salon = ref.watch(currentSalonProvider);
    final displayName = (account?.name?.isNotEmpty ?? false) ? account!.name! : l.profileGuestName;

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(SbSpace.xl),
        children: [
          SbCard(
            child: Row(
              children: [
                Semantics(
                  button: true,
                  label: l.changePhoto,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _uploading ? null : _changePhoto,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SbAvatar(label: displayName, url: account?.avatarUrl, radius: 32),
                        if (_uploading) const SizedBox.square(dimension: 64, child: CircularProgressIndicator(strokeWidth: 2)),
                        PositionedDirectional(
                          end: 0,
                          bottom: 0,
                          child: CircleAvatar(radius: 12, backgroundColor: context.sbColors.primary, child: Icon(Icons.photo_camera_outlined, size: 14, color: context.sbColors.onPrimary)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: SbSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: context.sbText.titleMedium),
                      if (account != null) Text(account.phone, textDirection: TextDirection.ltr, style: context.sbText.bodySmall),
                    ],
                  ),
                ),
                if (account != null) IconButton(tooltip: l.editName, icon: const Icon(Icons.edit_outlined), onPressed: () => _editName(account)),
              ],
            ),
          ),
          const SizedBox(height: SbSpace.lg),
          if (salon != null)
            ListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              leading: const Icon(Icons.storefront_outlined),
              title: Text(l.currentSalon),
              subtitle: Text(context.tr(salon.name)),
              trailing: TextButton(onPressed: () => const SalonEntryRoute().push<void>(context), child: Text(l.switchSalon)),
            ),
          ListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            leading: const Icon(Icons.notifications_none_rounded),
            title: Text(l.notificationSettings),
            trailing: const SbDirectionalIcon(Icons.chevron_right_rounded),
            onTap: () => const NotificationSettingsRoute().push<void>(context),
          ),
          const SizedBox(height: SbSpace.lg),
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
          SbButton(label: sb.signOut, icon: Icons.logout_rounded, variant: SbButtonVariant.secondary, expand: true, onPressed: _confirmSignOut),
          const SizedBox(height: SbSpace.md),
          SbButton(label: l.deleteAccount, variant: SbButtonVariant.ghost, expand: true, loading: _deleting, onPressed: _deleting ? null : _deleteAccount),
          Text(l.deleteAccountHint, textAlign: TextAlign.center, style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
        ],
      ),
    );
  }
}
