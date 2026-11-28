import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// A tab whose feature ships in a later phase. Says so honestly; no fake content.
class _SoonTab extends StatelessWidget {
  const new({required this.title, required this.heading, required this.body, required this.icon});

  final String title;
  final String heading;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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

class AiStudioTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SoonTab(title: l.tabAiStudio, heading: l.aiSoonTitle, body: l.aiSoonBody, icon: Icons.auto_awesome_outlined);
  }
}
