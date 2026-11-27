import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// A tab whose feature ships in a later phase. Says so honestly; no fake content.
class _SoonTab extends StatelessWidget {
  const new({required this.title, required this.heading, required this.body, required this.icon, this.header});

  final String title;
  final String heading;
  final String body;
  final IconData icon;
  final Widget? header;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?header,
        Expanded(
          child: SbEmptyState(
            icon: icon,
            title: heading,
            body: body,
            action: SbBadge(label: SbLocalizations.of(context).comingSoon, tone: SbTone.accent, dot: true),
          ),
        ),
      ],
    ),
  );
}

class HomeTab extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final session = ref.watch(customerSessionProvider).value;
    final name = session is SignedIn ? session.account.name : null;
    final hour = ref.watch(clockProvider)().hour;
    final greeting = hour < 12 ? l.greetingMorning : (hour < 17 ? l.greetingAfternoon : l.greetingEvening);

    return _SoonTab(
      title: l.tabHome,
      heading: l.homeSoonTitle,
      body: l.homeSoonBody,
      icon: Icons.storefront_outlined,
      header: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(SbSpace.xl, SbSpace.xl, SbSpace.xl, 0),
        child: Text(name == null || name.isEmpty ? greeting : l.greetingWithName(greeting, name), style: context.sbText.headlineSmall),
      ),
    );
  }
}

class BookTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabBook, heading: l.bookSoonTitle, body: l.bookSoonBody, icon: Icons.content_cut_rounded);
  }
}

class AiStudioTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabAiStudio, heading: l.aiSoonTitle, body: l.aiSoonBody, icon: Icons.auto_awesome_outlined);
  }
}

class AppointmentsTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabAppointments, heading: l.appointmentsSoonTitle, body: l.appointmentsSoonBody, icon: Icons.event_available_outlined);
  }
}
