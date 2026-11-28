import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/features/common/external_links.dart';
import 'package:smartbarber_customer/features/salon/salon_providers.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Branch picker with today's hours and a map link per branch (ADR-010: the phone's maps app,
/// not an embedded map SDK).
Future<void> showBranchPicker(BuildContext context, SalonCard salon) {
  return showSbSheet<void>(context: context, title: AppLocalizations.of(context).branchPickerTitle, builder: (_) => _BranchList(salon: salon));
}

class _BranchList extends ConsumerWidget {
  const new({required this.salon});

  final SalonCard salon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selected = ref.watch(currentBranchProvider);
    final branches = ref.watch(salonBranchesProvider(salon.slug));

    return AsyncView<List<SalonBranch>>(
      value: branches,
      onRetry: () => ref.invalidate(salonBranchesProvider(salon.slug)),
      isEmpty: (b) => b.isEmpty,
      loading: const SbSkeletonList(lines: 3),
      builder: (context, list) => ListView(
        shrinkWrap: true,
        children: [
          for (final (i, b) in list.indexed)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: SbSpace.sm),
              child: SbCard(
                onTap: () async {
                  await ref.read(currentBranchProvider.notifier).select(b.id);
                  if (context.mounted) Navigator.pop(context);
                },
                padding: const EdgeInsetsDirectional.all(SbSpace.md),
                child: Row(
                  children: [
                    Icon(
                      (selected == b.id || (selected == null && i == 0)) ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: context.sbColors.accent,
                    ),
                    const SizedBox(width: SbSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.tr(b.name), style: context.sbText.titleSmall),
                          if (context.tr(b.address).isNotEmpty)
                            Text(context.tr(b.address), style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
                          const SizedBox(height: SbSpace.xxs),
                          Text(
                            b.today.isEmpty ? l.closedToday : l.openToday(hoursLabel(l, b.today)),
                            style: context.sbText.labelMedium?.copyWith(color: b.today.isEmpty ? context.sbColors.error : context.sbColors.success),
                          ),
                        ],
                      ),
                    ),
                    if (b.location != null)
                      IconButton(
                        tooltip: l.directions,
                        icon: const Icon(Icons.map_outlined),
                        onPressed: () => openMaps(context, b.location!, context.tr(b.name)),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
