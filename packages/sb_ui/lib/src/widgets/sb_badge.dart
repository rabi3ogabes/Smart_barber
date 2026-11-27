import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

enum SbTone { neutral, accent, success, warning, error, info }

class SbBadge extends StatelessWidget {
  const new({required this.label, super.key, this.tone = SbTone.neutral, this.dot = false});

  final String label;
  final SbTone tone;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    final (bg, fg) = switch (tone) {
      SbTone.neutral => (c.surfaceMuted, c.textSecondary),
      SbTone.accent => (c.accentSoft, c.accent),
      SbTone.success => (c.successSoft, c.success),
      SbTone.warning => (c.warningSoft, c.warning),
      SbTone.error => (c.errorSoft, c.error),
      SbTone.info => (c.infoSoft, c.info),
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(SbRadius.pill)),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: SbSpace.xs + 2, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot) ...[
              Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
              const SizedBox(width: SbSpace.xxs + 2),
            ],
            Text(label, style: context.sbText.labelSmall?.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}
