import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

enum SbButtonVariant { primary, accent, secondary, ghost, danger }

/// Brand button. Minimum height 48 (touch target); shows a spinner and blocks taps while [loading].
class SbButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = SbButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final SbButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    final (bg, fg, border) = switch (variant) {
      SbButtonVariant.primary => (c.primary, c.onPrimary, Colors.transparent),
      SbButtonVariant.accent => (c.accent, c.onPrimary, Colors.transparent),
      SbButtonVariant.secondary => (c.surface, c.textPrimary, c.border),
      SbButtonVariant.ghost => (Colors.transparent, c.textPrimary, Colors.transparent),
      SbButtonVariant.danger => (c.error, Colors.white, Colors.transparent),
    };
    final enabled = onPressed != null && !loading;

    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: fg))
        else if (icon != null)
          Icon(icon, size: 18, color: fg),
        if (loading || icon != null) const SizedBox(width: SbSpace.xs),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: context.sbText.labelLarge?.copyWith(color: fg))),
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: loading ? '$label…' : null,
      child: AnimatedOpacity(
        opacity: enabled || loading ? 1 : 0.5,
        duration: context.reduceMotion ? Duration.zero : SbMotion.fast,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SbRadius.input), side: BorderSide(color: border)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: SbLayout.touchTarget, minWidth: expand ? double.infinity : 0),
              child: Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: SbSpace.lg + 4), child: child),
            ),
          ),
        ),
      ),
    );
  }
}
