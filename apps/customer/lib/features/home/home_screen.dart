import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/appointments/appointments_screen.dart';
import 'package:smartbarber_customer/features/appointments/rate_visit_sheet.dart';
import 'package:smartbarber_customer/features/booking/booking_draft.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/features/home/home_providers.dart';
import 'package:smartbarber_customer/features/salon/branch_picker.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Greeting, next appointment, "Book again", popular services, and placeholders for features the
/// salon has (AI Studio, loyalty) — everything as computed by the server.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final salon = ref.watch(currentSalonProvider);
    final home = ref.watch(homeProvider);
    final session = ref.watch(customerSessionProvider).value;
    final name = session is SignedIn ? session.account.name : null;
    final hour = ref.watch(clockProvider)().hour;
    final greeting = hour < 12 ? l.greetingMorning : (hour < 17 ? l.greetingAfternoon : l.greetingEvening);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(salon?.name)),
        actions: [
          if ((salon?.branchesCount ?? 0) > 1)
            IconButton(tooltip: l.branchPickerTitle, icon: const Icon(Icons.place_outlined), onPressed: () => showBranchPicker(context, salon!)),
          IconButton(tooltip: l.switchSalon, icon: const Icon(Icons.storefront_outlined), onPressed: () => const SalonEntryRoute().push<void>(context)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(homeProvider.future),
        child: ListView(
          padding: const EdgeInsetsDirectional.all(SbSpace.lg),
          children: [
            Text(name == null || name.isEmpty ? greeting : l.greetingWithName(greeting, name), style: context.sbText.headlineSmall),
            const SizedBox(height: SbSpace.lg),
            AsyncView<CustomerHome>(
              value: home,
              onRetry: () => ref.invalidate(homeProvider),
              loading: const SbSkeletonList(lines: 6),
              builder: (context, h) => _HomeContent(home: h),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const new({required this.home});

  final CustomerHome home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.sbColors;
    final next = home.nextAppointment;
    final again = home.bookAgain;
    final prompt = home.reviewPrompt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (prompt != null) ...[
          SbCard(
            onTap: () async {
              final done = await showSbSheet<bool>(context: context, title: l.rateVisitTitle, builder: (_) => RateVisitForm(bookingId: prompt.booking));
              if (done ?? false) ref.invalidate(homeProvider);
            },
            child: Row(
              children: [
                Icon(Icons.star_rounded, color: c.accent),
                const SizedBox(width: SbSpace.sm),
                Expanded(child: Text(prompt.barber == null ? l.rateLastVisit : l.rateLastVisitWith(context.tr(prompt.barber)), style: context.sbText.titleSmall)),
                SbDirectionalIcon(Icons.chevron_right_rounded, color: c.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: SbSpace.lg),
        ],
        Text(l.nextAppointment, style: context.sbText.titleMedium),
        const SizedBox(height: SbSpace.sm),
        if (next == null)
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.noNextAppointment, style: context.sbText.bodyMedium),
                const SizedBox(height: SbSpace.sm),
                SbButton(label: l.bookNow, icon: Icons.add_rounded, onPressed: () => const BookRoute().go(context)),
              ],
            ),
          )
        else
          BookingCard(
            booking: next,
            onTap: () => BookingDetailRoute(id: next.id).push<void>(context),
            trailing: next.canChange
                ? Row(
                    children: [
                      Expanded(
                        child: SbButton(label: l.reschedule, variant: SbButtonVariant.secondary, onPressed: () => RescheduleRoute(id: next.id).push<void>(context)),
                      ),
                      const SizedBox(width: SbSpace.sm),
                      Expanded(
                        child: SbButton(label: l.cancelBooking, variant: SbButtonVariant.ghost, onPressed: () => BookingDetailRoute(id: next.id).push<void>(context)),
                      ),
                    ],
                  )
                : null,
          ),
        if (again != null) ...[
          const SizedBox(height: SbSpace.lg),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ActionChip(
              avatar: const Icon(Icons.replay_rounded, size: 18),
              label: Text(l.bookAgain(again.names.map(context.tr).join(' + '))),
              onPressed: () {
                ref.read(bookingDraftProvider.notifier).prefill(again);
                const BookRoute().go(context);
              },
            ),
          ),
        ],
        if (home.popularServices.isNotEmpty) ...[
          const SizedBox(height: SbSpace.xl),
          Text(l.popularServices, style: context.sbText.titleMedium),
          const SizedBox(height: SbSpace.sm),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: home.popularServices.length,
              separatorBuilder: (_, _) => const SizedBox(width: SbSpace.sm),
              itemBuilder: (context, i) {
                final s = home.popularServices[i];
                return SizedBox(
                  width: 168,
                  child: SbCard(
                    padding: const EdgeInsetsDirectional.all(SbSpace.md),
                    onTap: home.branch == null
                        ? null
                        : () {
                            ref.read(bookingDraftProvider.notifier).startWith(home.branch!, s.id);
                            const BookRoute().go(context);
                          },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.content_cut_rounded, color: c.accent),
                        const Spacer(),
                        Text(context.tr(s.name), style: context.sbText.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text(
                          [if (s.price != null) s.price!.formatted, durationLabel(l, s.durationMinutes)].join(' · '),
                          style: context.sbText.bodySmall?.copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        if (home.features.aiStudio) ...[
          const SizedBox(height: SbSpace.lg),
          _SoonCard(icon: Icons.auto_awesome_outlined, title: l.aiSoonTitle, body: l.aiSoonBody),
        ],
        if (home.features.loyalty) ...[
          const SizedBox(height: SbSpace.lg),
          _SoonCard(icon: Icons.card_giftcard_rounded, title: l.loyaltySoonTitle, body: l.loyaltySoonBody),
        ],
      ],
    );
  }
}

class _SoonCard extends StatelessWidget {
  const new({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => SbCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(backgroundColor: context.sbColors.accentSoft, child: Icon(icon, color: context.sbColors.accent)),
        const SizedBox(width: SbSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.sbText.titleSmall),
              Text(body, style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
              const SizedBox(height: SbSpace.xs),
              SbBadge(label: SbLocalizations.of(context).comingSoon, tone: SbTone.accent, dot: true),
            ],
          ),
        ),
      ],
    ),
  );
}
