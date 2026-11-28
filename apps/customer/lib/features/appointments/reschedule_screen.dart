import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/appointments/appointments_providers.dart';
import 'package:smartbarber_customer/features/booking/booking_draft.dart';
import 'package:smartbarber_customer/features/booking/slot_picker.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/home/home_providers.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Pick a new time for the same services and barber. A taken time (409) refreshes the free times.
class RescheduleScreen extends ConsumerWidget {
  const new({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.reschedule)),
      body: AsyncView<CustomerBooking>(
        value: ref.watch(bookingDetailProvider(id)),
        onRetry: () => ref.invalidate(bookingDetailProvider(id)),
        builder: (context, b) => b.canChange && b.branch != null
            ? _Reschedule(booking: b)
            : SbEmptyState(icon: Icons.lock_clock_outlined, title: l.cannotRescheduleTitle, body: l.cannotRescheduleBody),
      ),
    );
  }
}

class _Reschedule extends ConsumerStatefulWidget {
  const new({required this.booking});

  final CustomerBooking booking;

  @override
  ConsumerState<_Reschedule> createState() => _RescheduleState();
}

class _RescheduleState extends ConsumerState<_Reschedule> {
  late String _date;
  Slot? _slot;
  bool _saving = false;
  String? _key;
  List<DateTime> _alternatives = const [];
  bool _taken = false;

  CustomerBooking get b => widget.booking;

  BookingSelection get _selection => BookingSelection(
    branch: b.branch!.id,
    services: b.items.where((i) => i.type == 'service' && i.service != null).map((i) => i.service!).toList(),
    barber: b.barber?.id,
  );

  @override
  void initState() {
    super.initState();
    _date = SbZonedTime.isoDate(SbZonedTime.wallClock(b.startsAt, b.branch!.timezone));
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final slot = _slot;
    if (slot == null) return;
    setState(() => _saving = true);
    _key ??= Idempotency.newKey();
    final result = await ref.read(bookingRepositoryProvider).reschedule(b.id, slot.startsAt, idempotencyKey: _key!);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok():
        ref
          ..invalidate(bookingDetailProvider(b.id))
          ..invalidate(bookingListProvider)
          ..invalidate(homeProvider);
        showMessage(context, l.rescheduled);
        context.pop();
      case Err(failure: final ApiFailure f) when f.code == 'BOOKING_SLOT_TAKEN':
        setState(() {
          _slot = null;
          _key = null;
          _taken = true;
          _alternatives = (f.data['alternatives'] as List<dynamic>? ?? const []).whereType<String>().map((s) => DateTime.parse(s).toUtc()).toList();
        });
        ref.invalidate(slotsProvider);
      case Err(:final failure):
        showFailure(context, failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final maxDays = ref.watch(homeProvider).value?.salon.bookingPolicy?.maxDaysAhead ?? 14;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.all(SbSpace.lg),
            children: [
              Text(l.rescheduleCurrent(SbZonedTime.day(b.startsAt, b.branch!.timezone, Localizations.localeOf(context).languageCode), SbZonedTime.time(b.startsAt, b.branch!.timezone, Localizations.localeOf(context).languageCode)),
                  style: context.sbText.bodyMedium?.copyWith(color: context.sbColors.textSecondary)),
              const SizedBox(height: SbSpace.md),
              SlotPicker(
                selection: _selection,
                timezone: b.branch!.timezone,
                date: _date,
                daysAhead: maxDays.clamp(1, 30),
                selected: _slot,
                highlight: _alternatives,
                notice: _taken ? l.slotTakenMessage : null,
                onDate: (d) => setState(() {
                  _date = d;
                  _slot = null;
                  _key = null;
                }),
                onSlot: (s) => setState(() {
                  _slot = s;
                  _key = null;
                }),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(SbSpace.lg),
            child: SbButton(label: l.confirmNewTime, expand: true, loading: _saving, onPressed: _slot == null || _saving ? null : _save),
          ),
        ),
      ],
    );
  }
}
