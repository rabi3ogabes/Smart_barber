import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

class SbCard extends StatelessWidget {
  const new({required this.child, super.key, this.padding = const EdgeInsetsDirectional.all(SbSpace.lg), this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SbRadius.card), side: BorderSide(color: c.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
  }
}
