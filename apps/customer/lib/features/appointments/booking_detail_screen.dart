import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/features/appointments/appointments_providers.dart';
import 'package:smartbarber_customer/features/appointments/rate_visit_sheet.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/features/common/external_links.dart';
import 'package:smartbarber_customer/features/home/home_providers.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Booking detail: status timeline, add to calendar, directions, reschedule, cancel with the
/// salon's policy, and "Rate your visit" once completed. Also the target of booking notifications.
class BookingDetailScreen extends ConsumerWidget {
  const new({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final booking = ref.watch(bookingDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(l.bookingDetailTitle)),
      body: AsyncView<CustomerBooking>(
        value: booking,
        onRetry: () => ref.invalidate(bookingDetailProvider(id)),
        loading: const Padding(padding: EdgeInsetsDirectional.all(SbSpace.lg), child: SbSkeletonList(lines: 6)),
        builder: (context, b) => RefreshIndicator(onRefresh: () => ref.refresh(bookingDetailProvider(id).future), child: _Detail(booking: b)),
      ),
    );
  }
}

BookingStatus parseStatus(String? value) => switch (value) {
  'pending' => BookingStatus.pending,
  'confirmed' => BookingStatus.confirmed,
  'arrived' => BookingStatus.arrived,
  'in_service' => BookingStatus.inService,
  'completed' => BookingStatus.completed,
  'cancelled' => BookingStatus.cancelled,
  'no_show' => BookingStatus.noShow,
  _ => BookingStatus.unknown,
};

class _Detail extends ConsumerStatefulWidget {
  const new({required this.booking});

  final CustomerBooking booking;

  @override
  ConsumerState<_Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<_Detail> {
  bool _cancelling = false;
  bool _exporting = false;
  String? _cancelKey;

  CustomerBooking get b => widget.booking;

  void _refreshAll() => ref
    ..invalidate(bookingDetailProvider(b.id))
    ..invalidate(bookingListProvider)
    ..invalidate(homeProvider);

  Future<void> _addToCalendar() async {
    setState(() => _exporting = true);
    final result = await ref.read(bookingRepositoryProvider).calendarFile(b.id);
    if (!mounted) return;
    setState(() => _exporting = false);
    switch (result) {
      case Ok(:final value):
        await shareCalendarFile(context, value, b.id);
      case Err(:final failure):
        showFailure(context, failure);
    }
  }

  Future<void> _cancel() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.cancelBookingTitle),
        content: Text(l.cancelBookingBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.keepBooking)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.confirm)),
        ],
      ),
    );
    if (!(ok ?? false) || !mounted) return;
    setState(() => _cancelling = true);
    _cancelKey ??= Idempotency.newKey();
    final result = await ref.read(bookingRepositoryProvider).cancel(b.id, idempotencyKey: _cancelKey!);
    if (!mounted) return;
    setState(() => _cancelling = false);
    switch (result) {
      case Ok():
        _cancelKey = null;
        showMessage(context, l.bookingCancelled);
        _refreshAll();
      case Err(:final failure):
        showFailure(context, failure);
    }
  }

  Future<void> _rate() async {
    final done = await showRateVisitSheet(context, b);
    if ((done ?? false) && mounted) _refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.sbColors;
    final tz = b.branch?.timezone ?? 'UTC';
    final (label, tone) = statusLabel(l, b.status);
    final window = b.policy?.cancellationWindowMinutes ?? 0;
    final deadline = b.startsAt.subtract(Duration(minutes: window));

    return ListView(
      padding: const EdgeInsetsDirectional.all(SbSpace.lg),
      children: [
        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(context.tr(b.salon?.name), style: context.sbText.titleMedium)),
                  SbBadge(label: label, tone: tone, dot: true),
                ],
              ),
              const SizedBox(height: SbSpace.xs),
              Text(SbZonedTime.longDay(b.startsAt, tz, context.lang), style: context.sbText.headlineSmall),
              Text(
                '${SbZonedTime.time(b.startsAt, tz, context.lang)}–${SbZonedTime.time(b.endsAt, tz, context.lang)}',
                textDirection: TextDirection.ltr,
                style: context.sbText.titleMedium?.copyWith(color: c.textSecondary),
              ),
              const Divider(height: SbSpace.xl),
              if (b.barber != null) _Line(icon: Icons.person_outline_rounded, text: context.tr(b.barber!.name)),
              if (b.branch != null) _Line(icon: Icons.storefront_outlined, text: [context.tr(b.branch!.name), context.tr(b.branch!.address)].where((s) => s.isNotEmpty).join(' · ')),
            ],
          ),
        ),
        const SizedBox(height: SbSpace.md),
        Wrap(
          spacing: SbSpace.xs,
          runSpacing: SbSpace.xs,
          children: [
            if (b.status.isUpcoming)
              ActionChip(
                avatar: const Icon(Icons.event_available_outlined, size: 18),
                label: Text(l.addToCalendar),
                onPressed: _exporting ? null : _addToCalendar,
              ),
            if (b.branch?.location != null)
              ActionChip(
                avatar: const Icon(Icons.directions_outlined, size: 18),
                label: Text(l.directions),
                onPressed: () => openMaps(context, b.branch!.location!, context.tr(b.branch!.name)),
              ),
            if (b.branch?.phone != null)
              ActionChip(avatar: const Icon(Icons.call_outlined, size: 18), label: Text(l.callSalon), onPressed: () => callPhone(context, b.branch!.phone!)),
          ],
        ),
        const SizedBox(height: SbSpace.lg),
        SbCard(
          child: Column(
            children: [
              for (final item in b.items)
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: SbSpace.xs),
                  child: Row(
                    children: [
                      Expanded(child: Text(context.tr(item.name), style: context.sbText.bodyMedium)),
                      Text(item.total.formatted, textDirection: TextDirection.ltr, style: context.sbText.bodyMedium),
                    ],
                  ),
                ),
              const Divider(height: SbSpace.lg),
              Row(
                children: [
                  Expanded(child: Text(l.total, style: context.sbText.titleMedium)),
                  Text(b.total.formatted, textDirection: TextDirection.ltr, style: context.sbText.titleMedium),
                ],
              ),
            ],
          ),
        ),
        if (b.review != null) ...[
          const SizedBox(height: SbSpace.lg),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.yourRating, style: context.sbText.titleSmall),
                const SizedBox(height: SbSpace.xxs),
                Row(children: [for (var i = 1; i <= 5; i++) Icon(i <= b.review!.rating ? Icons.star_rounded : Icons.star_outline_rounded, color: c.accent)]),
                if (b.review!.comment != null) Text(b.review!.comment!, style: context.sbText.bodyMedium),
              ],
            ),
          ),
        ],
        if (b.history != null && b.history!.isNotEmpty) ...[
          const SizedBox(height: SbSpace.lg),
          Text(l.timelineTitle, style: context.sbText.titleSmall),
          const SizedBox(height: SbSpace.xs),
          for (final (i, h) in b.history!.indexed)
            _TimelineEntry(entry: h, timezone: tz, last: i == b.history!.length - 1),
        ],
        const SizedBox(height: SbSpace.xl),
        if (b.canReview) ...[
          SbButton(label: l.rateVisit, icon: Icons.star_outline_rounded, variant: SbButtonVariant.accent, expand: true, onPressed: _rate),
          const SizedBox(height: SbSpace.sm),
        ],
        if (b.canChange) ...[
          Text(
            window > 0
                ? l.cancelPolicy(SbZonedTime.day(deadline, tz, context.lang), SbZonedTime.time(deadline, tz, context.lang))
                : l.cancelPolicyAnytime,
            style: context.sbText.bodySmall?.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: SbSpace.sm),
          SbButton(label: l.reschedule, icon: Icons.edit_calendar_outlined, variant: SbButtonVariant.secondary, expand: true, onPressed: () => RescheduleRoute(id: b.id).push<void>(context)),
          const SizedBox(height: SbSpace.sm),
          SbButton(label: l.cancelBooking, variant: SbButtonVariant.danger, expand: true, loading: _cancelling, onPressed: _cancelling ? null : _cancel),
        ],
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const new({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: SbSpace.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.sbColors.textSecondary),
        const SizedBox(width: SbSpace.sm),
        Expanded(child: Text(text, style: context.sbText.bodyMedium)),
      ],
    ),
  );
}

class _TimelineEntry extends StatelessWidget {
  const new({required this.entry, required this.timezone, required this.last});

  final BookingHistoryEntry entry;
  final String timezone;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.sbColors;
    final (label, _) = statusLabel(l, parseStatus(entry.to));
    final text = entry.rescheduled ? l.timelineRescheduled : label;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 12, height: 12, margin: const EdgeInsetsDirectional.only(top: SbSpace.xxs), decoration: BoxDecoration(color: last ? c.accent : c.border, shape: BoxShape.circle)),
              if (!last) Expanded(child: Container(width: 2, color: c.border)),
            ],
          ),
          const SizedBox(width: SbSpace.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: SbSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: context.sbText.bodyMedium),
                  Text(
                    '${SbZonedTime.day(entry.at, timezone, context.lang)} · ${SbZonedTime.time(entry.at, timezone, context.lang)}',
                    style: context.sbText.bodySmall?.copyWith(color: c.textSecondary),
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
