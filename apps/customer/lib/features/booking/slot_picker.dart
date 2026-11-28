import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/booking/booking_draft.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Date strip + free times from the API, both in the branch timezone. Shared by the booking
/// stepper and reschedule. The server re-checks the chosen time when it books.
class SlotPicker extends ConsumerWidget {
  const new({
    required this.selection,
    required this.timezone,
    required this.date,
    required this.onDate,
    required this.onSlot,
    super.key,
    this.selected,
    this.daysAhead = 14,
    this.highlight = const [],
    this.notice,
  });

  final BookingSelection selection;
  final String timezone;
  final String date;
  final ValueChanged<String> onDate;
  final ValueChanged<Slot> onSlot;
  final Slot? selected;
  final int daysAhead;

  /// Times the server suggested after a 409; shown first.
  final List<DateTime> highlight;

  /// Shown above the times (e.g. "someone just booked that time").
  final String? notice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final now = ref.watch(clockProvider)().toUtc();
    final days = [for (var i = 0; i < daysAhead; i++) now.add(Duration(days: i))];
    final slots = ref.watch(slotsProvider(selection, date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, _) => const SizedBox(width: SbSpace.xs),
            itemBuilder: (context, i) {
              final wall = SbZonedTime.wallClock(days[i], timezone);
              final iso = SbZonedTime.isoDate(wall);
              final active = iso == date;
              final c = context.sbColors;
              return Semantics(
                selected: active,
                button: true,
                child: InkWell(
                  borderRadius: BorderRadius.circular(SbRadius.card),
                  onTap: () => onDate(iso),
                  child: AnimatedContainer(
                    duration: SbMotion.fast,
                    width: 60,
                    decoration: BoxDecoration(
                      color: active ? c.primary : c.surface,
                      borderRadius: BorderRadius.circular(SbRadius.card),
                      border: Border.all(color: active ? c.primary : c.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          i == 0 ? l.today : SbZonedTime.weekdayShort(days[i], timezone, context.lang),
                          style: context.sbText.labelSmall?.copyWith(color: active ? c.onPrimary : c.textSecondary),
                        ),
                        const SizedBox(height: SbSpace.xxs),
                        Text(
                          SbZonedTime.dayOfMonth(days[i], timezone, context.lang),
                          style: context.sbText.titleMedium?.copyWith(color: active ? c.onPrimary : c.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: SbSpace.lg),
        if (notice != null) ...[
          Semantics(
            liveRegion: true,
            child: Container(
              padding: const EdgeInsetsDirectional.all(SbSpace.md),
              decoration: BoxDecoration(color: context.sbColors.warningSoft, borderRadius: BorderRadius.circular(SbRadius.card)),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: context.sbColors.warning),
                  const SizedBox(width: SbSpace.sm),
                  Expanded(child: Text(notice!, style: context.sbText.bodyMedium)),
                ],
              ),
            ),
          ),
          const SizedBox(height: SbSpace.md),
        ],
        if (highlight.isNotEmpty) ...[
          Text(l.slotTakenAlternatives, style: context.sbText.titleSmall),
          const SizedBox(height: SbSpace.xs),
        ],
        AsyncView<SlotDay>(
          value: slots,
          onRetry: () => ref.invalidate(slotsProvider(selection, date)),
          isEmpty: (d) => d.slots.isEmpty,
          loading: const SbSkeletonList(lines: 3),
          empty: SbEmptyState(icon: Icons.event_busy_outlined, title: l.noSlotsTitle, body: l.noSlotsBody),
          builder: (context, day) {
            final ordered = [
              ...day.slots.where((s) => highlight.contains(s.startsAt)),
              ...day.slots.where((s) => !highlight.contains(s.startsAt)),
            ];
            return Wrap(
              spacing: SbSpace.xs,
              runSpacing: SbSpace.xs,
              children: [
                for (final s in ordered)
                  SbChip(label: s.time, selected: selected?.startsAt == s.startsAt, onTap: () => onSlot(s)),
              ],
            );
          },
        ),
      ],
    );
  }
}
