import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_staff/app/providers.dart';
import 'package:smartbarber_staff/app/session.dart';
import 'package:smartbarber_staff/features/auth/auth_scaffold.dart';
import 'package:smartbarber_staff/features/auth/login_controller.dart';
import 'package:smartbarber_staff/l10n/generated/app_localizations.dart';

class SalonPickerScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SalonPickerScreen> createState() => _SalonPickerScreenState();
}

class _SalonPickerScreenState extends ConsumerState<SalonPickerScreen> {
  String? _loadingSalon;
  String? _error;

  Future<void> _pick(StaffSalonSelectionRequired step, MembershipOption option) async {
    final sb = SbLocalizations.of(context);
    setState(() {
      _loadingSalon = option.salon;
      _error = null;
    });
    final result = await ref.read(staffAuthRepositoryProvider).selectSalon(selectionToken: step.selectionToken, salonId: option.salon);
    if (!mounted) return;
    final failure = await applyLoginStep(ref, result);
    if (!mounted) return;
    setState(() {
      _loadingSalon = null;
      _error = failure == null ? null : failureMessage(sb, failure);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final step = ref.watch(loginFlowProvider);
    final language = Localizations.localeOf(context).languageCode;
    final options = step is StaffSalonSelectionRequired ? step.memberships : const <MembershipOption>[];

    return AuthScaffold(
      title: l.salonPickerTitle,
      subtitle: l.salonPickerSubtitle,
      leading: IconButton(
        tooltip: l.startOver,
        icon: const SbDirectionalIcon(Icons.arrow_back_rounded),
        onPressed: () => ref.read(loginFlowProvider.notifier).set(null),
      ),
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: SbSpace.sm),
            child: SbCard(
              onTap: _loadingSalon == null && step is StaffSalonSelectionRequired ? () => _pick(step, option) : null,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: context.sbColors.accentSoft,
                    child: Icon(Icons.storefront_rounded, color: context.sbColors.accent),
                  ),
                  const SizedBox(width: SbSpace.md),
                  Expanded(child: Text(localize(option.name, language), style: context.sbText.titleMedium)),
                  if (_loadingSalon == option.salon)
                    const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  else
                    SbDirectionalIcon(Icons.chevron_right_rounded, color: context.sbColors.textSecondary),
                ],
              ),
            ),
          ),
        FormErrorText(_error),
      ],
    );
  }
}
