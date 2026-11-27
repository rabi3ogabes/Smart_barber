import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

class SbChip extends StatelessWidget {
  const new({required this.label, super.key, this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return Semantics(
      selected: selected,
      button: onTap != null,
      child: Material(
        color: selected ? c.primary : c.surface,
        shape: StadiumBorder(side: BorderSide(color: selected ? c.primary : c.border)),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: SbSpace.md + 2),
              child: Center(
                widthFactor: 1,
                child: Text(label, style: context.sbText.labelMedium?.copyWith(color: selected ? c.onPrimary : c.textPrimary)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
