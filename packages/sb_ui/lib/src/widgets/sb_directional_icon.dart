import 'package:material_ui/material_ui.dart';

/// An icon that points "forward" or "back" and therefore mirrors in RTL (flutter.md, Rules for
/// every screen). Brand icons and clocks must use a plain [Icon] instead.
class SbDirectionalIcon extends StatelessWidget {
  const new(this.icon, {super.key, this.size, this.color, this.semanticLabel});

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Transform.flip(
    flipX: Directionality.of(context) == TextDirection.rtl,
    child: Icon(icon, size: size, color: color, semanticLabel: semanticLabel),
  );
}
