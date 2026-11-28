import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/features/appointments/appointments_providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Upcoming and past visits across every salon the customer uses.
class AppointmentsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.tabAppointments),
          bottom: TabBar(tabs: [Tab(text: l.upcoming), Tab(text: l.past)]),
        ),
        body: const TabBarView(children: [_BookingTab(upcoming: true), _BookingTab(upcoming: false)]),
      ),
    );
  }
}

class _BookingTab extends ConsumerWidget {
  const new({required this.upcoming});

  final bool upcoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final provider = bookingListProvider(upcoming: upcoming);
    return AsyncView<List<CustomerBooking>>(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      isEmpty: (list) => list.isEmpty,
      loading: const Padding(padding: EdgeInsetsDirectional.all(SbSpace.lg), child: SbSkeletonList()),
      empty: SbEmptyState(
        icon: upcoming ? Icons.event_available_outlined : Icons.history_rounded,
        title: upcoming ? l.noUpcomingTitle : l.noPastTitle,
        body: upcoming ? l.noUpcomingBody : l.noPastBody,
        action: upcoming ? SbButton(label: l.bookNow, onPressed: () => const BookRoute().go(context)) : null,
      ),
      builder: (context, list) => RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.pixels > n.metrics.maxScrollExtent - 200) unawaited(ref.read(provider.notifier).loadMore());
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.all(SbSpace.lg),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: SbSpace.sm),
            itemBuilder: (context, i) => BookingCard(booking: list[i], onTap: () => BookingDetailRoute(id: list[i].id).push<void>(context)),
          ),
        ),
      ),
    );
  }
}

/// One booking: when (branch timezone), where, what, status.
class BookingCard extends StatelessWidget {
  const new({required this.booking, required this.onTap, super.key, this.trailing});

  final CustomerBooking booking;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tz = booking.branch?.timezone ?? 'UTC';
    final (label, tone) = statusLabel(l, booking.status);
    final c = context.sbColors;
    return SbCard(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.all(SbSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${SbZonedTime.day(booking.startsAt, tz, context.lang)} · ${SbZonedTime.time(booking.startsAt, tz, context.lang)}',
                  style: context.sbText.titleSmall,
                ),
              ),
              SbBadge(label: label, tone: tone, dot: true),
            ],
          ),
          const SizedBox(height: SbSpace.xxs),
          Text(booking.items.map((i) => context.tr(i.name)).join(' + '), style: context.sbText.bodyMedium),
          const SizedBox(height: SbSpace.xxs),
          Text(
            [context.tr(booking.salon?.name), context.tr(booking.branch?.name), if (booking.barber != null) context.tr(booking.barber!.name)]
                .where((s) => s.isNotEmpty)
                .join(' · '),
            style: context.sbText.bodySmall?.copyWith(color: c.textSecondary),
          ),
          if (trailing != null) ...[const SizedBox(height: SbSpace.sm), trailing!],
        ],
      ),
    );
  }
}
