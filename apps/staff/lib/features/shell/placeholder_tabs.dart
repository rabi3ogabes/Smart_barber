import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_staff/app/session.dart';
import 'package:smartbarber_staff/l10n/generated/app_localizations.dart';

class _SoonTab extends ConsumerWidget {
  const new({required this.title, required this.heading, required this.body, required this.icon});

  final String title;
  final String heading;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(staffSessionProvider).value;
    final salon = session is StaffSignedInState ? session.me.salon : null;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (salon != null)
              Text(localize(salon.name, Localizations.localeOf(context).languageCode), style: context.sbText.bodySmall),
          ],
        ),
      ),
      body: SbEmptyState(
        icon: icon,
        title: heading,
        body: body,
        action: SbBadge(label: SbLocalizations.of(context).comingSoon, tone: SbTone.accent, dot: true),
      ),
    );
  }
}

class TodayTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabToday, heading: l.todaySoonTitle, body: l.todaySoonBody, icon: Icons.event_seat_outlined);
  }
}

class QueueTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabQueue, heading: l.queueSoonTitle, body: l.queueSoonBody, icon: Icons.groups_outlined);
  }
}

class CustomersTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabCustomers, heading: l.customersSoonTitle, body: l.customersSoonBody, icon: Icons.badge_outlined);
  }
}

class PosTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabPos, heading: l.posSoonTitle, body: l.posSoonBody, icon: Icons.point_of_sale_outlined);
  }
}
