import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/features/appointments/appointments_providers.dart';
import 'package:smartbarber_customer/features/booking/booking_draft.dart';
import 'package:smartbarber_customer/features/booking/slot_picker.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/features/home/home_providers.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Services + add-ons → barber or "Any available" → date and time → summary with the server quote
/// → confirm. A taken slot (409) brings the customer back to fresh times with a friendly message.
class BookingStepperScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final branch = ref.watch(activeBranchProvider);

    return AsyncView<SalonBranch?>(
      value: branch,
      onRetry: () => ref.invalidate(activeBranchProvider),
      builder: (context, b) {
        if (b == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l.tabBook)),
            body: SbEmptyState(icon: Icons.storefront_outlined, title: l.noBranchesTitle, body: l.noBranchesBody),
          );
        }
        return _Stepper(branch: b);
      },
    );
  }
}

class _Stepper extends ConsumerStatefulWidget {
  const new({required this.branch});

  final SalonBranch branch;

  @override
  ConsumerState<_Stepper> createState() => _StepperState();
}

class _StepperState extends ConsumerState<_Stepper> {
  bool _confirming = false;
  AppFailure? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = ref.read(bookingDraftProvider);
      if (draft.branch == null || (draft.branch != widget.branch.id && !draft.hasSelection)) {
        ref.read(bookingDraftProvider.notifier).setBranch(widget.branch.id);
      }
    });
  }

  Future<void> _confirm() async {
    setState(() {
      _confirming = true;
      _error = null;
    });
    final outcome = await ref.read(bookingDraftProvider.notifier).confirm();
    if (!mounted) return;
    setState(() => _confirming = false);
    switch (outcome) {
      case Confirmed():
        ref
          ..invalidate(homeProvider)
          ..invalidate(bookingListProvider);
      case SlotTaken():
        break; // the time step shows the notice and fresh times
      case ConfirmFailed(:final failure):
        setState(() => _error = failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final notifier = ref.read(bookingDraftProvider.notifier);
    final steps = [BookingStep.services, BookingStep.barber, BookingStep.time, BookingStep.summary];
    final index = steps.indexOf(draft.step);

    if (draft.step == BookingStep.done && draft.created != null) {
      return _Done(booking: draft.created!, onAgain: notifier.reset);
    }

    final title = switch (draft.step) {
      BookingStep.services => l.stepServices,
      BookingStep.barber => l.stepBarber,
      BookingStep.time => l.stepTime,
      _ => l.stepSummary,
    };
    final canContinue = switch (draft.step) {
      BookingStep.services => draft.hasSelection,
      BookingStep.barber => true,
      BookingStep.time => draft.slot != null,
      _ => false,
    };

    return PopScope(
      canPop: index <= 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && index > 0) notifier.goTo(steps[index - 1]);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: index > 0 ? BackButton(onPressed: () => notifier.goTo(steps[index - 1])) : null,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(24),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(SbSpace.lg, 0, SbSpace.lg, SbSpace.xs),
              child: Row(
                children: [
                  Text(l.stepOf(index + 1, steps.length), style: context.sbText.labelSmall),
                  const SizedBox(width: SbSpace.sm),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(SbRadius.pill),
                      child: LinearProgressIndicator(value: (index + 1) / steps.length, minHeight: 4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: switch (draft.step) {
          BookingStep.services => _ServicesStep(branch: widget.branch),
          BookingStep.barber => _BarberStep(branch: widget.branch),
          BookingStep.time => _TimeStep(branch: widget.branch),
          _ => _SummaryStep(branch: widget.branch),
        },
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(SbSpace.lg),
            child: draft.step == BookingStep.summary
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_error != null) ...[
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            failureMessage(SbLocalizations.of(context), _error!),
                            textAlign: TextAlign.center,
                            style: context.sbText.bodySmall?.copyWith(color: context.sbColors.error),
                          ),
                        ),
                        const SizedBox(height: SbSpace.xs),
                      ],
                      SbButton(label: l.confirmBooking, expand: true, loading: _confirming, onPressed: _confirming ? null : _confirm),
                    ],
                  )
                : SbButton(label: SbLocalizations.of(context).continueLabel, expand: true, onPressed: canContinue ? () => notifier.goTo(steps[index + 1]) : null),
          ),
        ),
      ),
    );
  }
}

class _ServicesStep extends ConsumerWidget {
  const new({required this.branch});

  final SalonBranch branch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final notifier = ref.read(bookingDraftProvider.notifier);
    final menu = ref.watch(branchMenuProvider(branch.id));

    return AsyncView<ServiceMenu>(
      value: menu,
      onRetry: () => ref.invalidate(branchMenuProvider(branch.id)),
      isEmpty: (m) => m.services.isEmpty && m.bundles.isEmpty,
      empty: SbEmptyState(icon: Icons.content_cut_rounded, title: l.noServicesTitle, body: l.noServicesBody),
      loading: const Padding(padding: EdgeInsetsDirectional.all(SbSpace.lg), child: SbSkeletonList(lines: 6)),
      builder: (context, m) => ListView(
        padding: const EdgeInsetsDirectional.all(SbSpace.lg),
        children: [
          if (m.bundles.isNotEmpty) ...[
            Text(l.bundlesTitle, style: context.sbText.titleSmall),
            const SizedBox(height: SbSpace.xs),
            for (final b in m.bundles)
              _PickTile(
                title: context.tr(b.name),
                subtitle: durationLabel(l, b.durationMinutes),
                price: b.price.formatted,
                selected: draft.bundles.contains(b.id),
                onTap: () => notifier.toggleBundle(b.id),
              ),
            const SizedBox(height: SbSpace.lg),
            Text(l.servicesTitle, style: context.sbText.titleSmall),
            const SizedBox(height: SbSpace.xs),
          ],
          for (final s in m.services) ...[
            _PickTile(
              title: context.tr(s.name),
              subtitle: durationLabel(l, s.durationMinutes),
              price: s.price?.formatted,
              selected: draft.services.contains(s.id),
              onTap: () => notifier.toggleService(s),
            ),
            if (draft.services.contains(s.id) && s.addons.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(SbSpace.xl, 0, 0, SbSpace.sm),
                child: Wrap(
                  spacing: SbSpace.xs,
                  runSpacing: SbSpace.xs,
                  children: [
                    for (final a in s.addons)
                      SbChip(label: '${context.tr(a.name)} · +${a.price.formatted}', selected: draft.addons.contains(a.id), onTap: () => notifier.toggleAddon(a.id)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _PickTile extends StatelessWidget {
  const new({required this.title, required this.subtitle, required this.selected, required this.onTap, this.price});

  final String title;
  final String subtitle;
  final String? price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: SbSpace.xs),
      child: Semantics(
        checked: selected,
        child: SbCard(
          onTap: onTap,
          padding: const EdgeInsetsDirectional.all(SbSpace.md),
          child: Row(
            children: [
              Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, color: selected ? c.accent : c.textSecondary),
              const SizedBox(width: SbSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.sbText.titleSmall),
                    Text(subtitle, style: context.sbText.bodySmall?.copyWith(color: c.textSecondary)),
                  ],
                ),
              ),
              if (price != null) Text(price!, textDirection: TextDirection.ltr, style: context.sbText.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarberStep extends ConsumerWidget {
  const new({required this.branch});

  final SalonBranch branch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final notifier = ref.read(bookingDraftProvider.notifier);
    final barbers = ref.watch(branchBarbersProvider(branch.id));

    return AsyncView<List<BarberProfile>>(
      value: barbers,
      onRetry: () => ref.invalidate(branchBarbersProvider(branch.id)),
      loading: const Padding(padding: EdgeInsetsDirectional.all(SbSpace.lg), child: SbSkeletonList()),
      builder: (context, list) => ListView(
        padding: const EdgeInsetsDirectional.all(SbSpace.lg),
        children: [
          _BarberTile(
            name: l.anyBarber,
            detail: l.anyBarberHint,
            selected: draft.barber == null,
            onTap: () => notifier.chooseBarber(null),
            icon: Icons.groups_2_outlined,
          ),
          for (final b in list)
            _BarberTile(
              name: context.tr(b.displayName),
              detail: [
                if (b.rating != null) '★ ${b.rating!.average.toStringAsFixed(1)} (${b.rating!.count})',
                ...b.specialties.map((s) => specialtyLabel(l, s)),
              ].join(' · '),
              photo: b.photoUrl,
              selected: draft.barber == b.id,
              onTap: () => notifier.chooseBarber(b.id),
            ),
        ],
      ),
    );
  }
}

String specialtyLabel(AppLocalizations l, String key) => switch (key) {
  'fade' => l.specialtyFade,
  'classic_cut' => l.specialtyClassicCut,
  'beard' => l.specialtyBeard,
  'shave' => l.specialtyShave,
  'kids' => l.specialtyKids,
  'long_hair' => l.specialtyLongHair,
  'coloring' => l.specialtyColoring,
  'styling' => l.specialtyStyling,
  'facial' => l.specialtyFacial,
  _ => key,
};

class _BarberTile extends StatelessWidget {
  const new({required this.name, required this.detail, required this.selected, required this.onTap, this.photo, this.icon});

  final String name;
  final String detail;
  final bool selected;
  final VoidCallback onTap;
  final String? photo;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: SbSpace.xs),
      child: Semantics(
        selected: selected,
        child: SbCard(
          onTap: onTap,
          padding: const EdgeInsetsDirectional.all(SbSpace.md),
          child: Row(
            children: [
              if (icon != null)
                CircleAvatar(radius: 24, backgroundColor: c.accentSoft, child: Icon(icon, color: c.accent))
              else
                SbAvatar(label: name, url: photo),
              const SizedBox(width: SbSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: context.sbText.titleSmall),
                    if (detail.isNotEmpty) Text(detail, style: context.sbText.bodySmall?.copyWith(color: c.textSecondary)),
                  ],
                ),
              ),
              Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: selected ? c.accent : c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeStep extends ConsumerWidget {
  const new({required this.branch});

  final SalonBranch branch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final notifier = ref.read(bookingDraftProvider.notifier);
    final selection = draft.selection;
    if (selection == null) return const SizedBox.shrink();
    final today = SbZonedTime.today(ref.watch(clockProvider)().toUtc(), branch.timezone);
    final date = draft.date ?? today;
    final maxDays = ref.watch(homeProvider).value?.salon.bookingPolicy?.maxDaysAhead ?? 14;

    return ListView(
      padding: const EdgeInsetsDirectional.all(SbSpace.lg),
      children: [
        SlotPicker(
          selection: selection,
          timezone: branch.timezone,
          date: date,
          daysAhead: maxDays.clamp(1, 30),
          selected: draft.slot,
          highlight: draft.alternatives,
          notice: draft.slotTaken ? AppLocalizations.of(context).slotTakenMessage : null,
          onDate: notifier.chooseDate,
          onSlot: notifier.chooseSlot,
        ),
      ],
    );
  }
}

class _SummaryStep extends ConsumerWidget {
  const new({required this.branch});

  final SalonBranch branch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final selection = draft.selection;
    final slot = draft.slot;
    if (selection == null || slot == null) return const SizedBox.shrink();
    final quote = ref.watch(quoteProvider(selection));
    final barbers = ref.watch(branchBarbersProvider(branch.id)).value ?? const [];
    final barber = barbers.where((b) => b.id == draft.barber).firstOrNull;
    final salon = ref.watch(currentSalonProvider);

    return ListView(
      padding: const EdgeInsetsDirectional.all(SbSpace.lg),
      children: [
        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr(salon?.name), style: context.sbText.titleMedium),
              Text(context.tr(branch.name), style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
              const Divider(height: SbSpace.xl),
              _Row(icon: Icons.event_outlined, text: SbZonedTime.longDay(slot.startsAt, branch.timezone, context.lang)),
              _Row(icon: Icons.schedule_rounded, text: SbZonedTime.time(slot.startsAt, branch.timezone, context.lang)),
              _Row(icon: Icons.person_outline_rounded, text: barber == null ? l.anyBarber : context.tr(barber.displayName)),
            ],
          ),
        ),
        const SizedBox(height: SbSpace.lg),
        AsyncView<Quote>(
          value: quote,
          onRetry: () => ref.invalidate(quoteProvider(selection)),
          loading: const SbSkeletonList(lines: 3),
          builder: (context, q) => SbCard(
            child: Column(
              children: [
                for (final line in q.lines) _PriceRow(label: context.tr(line.name), value: line.total.formatted),
                if (q.discount.amount != 0) _PriceRow(label: l.discount, value: '−${q.discount.formatted}'),
                if (!q.pricesIncludeTax && q.tax.amount != 0) _PriceRow(label: l.tax, value: q.tax.formatted),
                const Divider(height: SbSpace.lg),
                _PriceRow(label: l.total, value: q.total.formatted, strong: true),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(durationLabel(l, q.durationMinutes), style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: SbSpace.lg),
        SbTextField(label: l.notesLabel, hint: l.notesHint, maxLength: 500, onChanged: ref.read(bookingDraftProvider.notifier).setNotes),
        if (salon != null) ...[
          const SizedBox(height: SbSpace.sm),
          Text(l.payAtSalon, style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const new({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: SbSpace.xs),
    child: Row(
      children: [
        Icon(icon, size: 20, color: context.sbColors.textSecondary),
        const SizedBox(width: SbSpace.sm),
        Expanded(child: Text(text, style: context.sbText.bodyMedium)),
      ],
    ),
  );
}

class _PriceRow extends StatelessWidget {
  const new({required this.label, required this.value, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? context.sbText.titleMedium : context.sbText.bodyMedium;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: SbSpace.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, textDirection: TextDirection.ltr, style: style),
        ],
      ),
    );
  }
}

class _Done extends StatelessWidget {
  const new({required this.booking, required this.onAgain});

  final CustomerBooking booking;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tz = booking.branch?.timezone ?? 'UTC';
    final pending = booking.status == BookingStatus.pending;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabBook), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(SbSpace.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(pending ? Icons.hourglass_top_rounded : Icons.check_circle_rounded, size: 64, color: pending ? context.sbColors.warning : context.sbColors.success),
            const SizedBox(height: SbSpace.lg),
            Text(pending ? l.bookingPendingTitle : l.bookingConfirmedTitle, textAlign: TextAlign.center, style: context.sbText.headlineSmall),
            const SizedBox(height: SbSpace.xs),
            Text(
              '${SbZonedTime.longDay(booking.startsAt, tz, context.lang)} · ${SbZonedTime.time(booking.startsAt, tz, context.lang)}',
              textAlign: TextAlign.center,
              style: context.sbText.bodyMedium,
            ),
            if (pending) ...[
              const SizedBox(height: SbSpace.xs),
              Text(l.bookingPendingBody, textAlign: TextAlign.center, style: context.sbText.bodySmall),
            ],
            const SizedBox(height: SbSpace.xl),
            SbButton(
              label: l.viewBooking,
              expand: true,
              onPressed: () {
                onAgain();
                unawaited(BookingDetailRoute(id: booking.id).push<void>(context));
              },
            ),
            const SizedBox(height: SbSpace.sm),
            SbButton(label: l.bookAnother, variant: SbButtonVariant.secondary, expand: true, onPressed: onAgain),
          ],
        ),
      ),
    );
  }
}
