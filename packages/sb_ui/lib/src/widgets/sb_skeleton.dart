import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

/// Loading placeholder with a soft pulse; static when the user prefers reduced motion.
class SbSkeleton extends StatefulWidget {
  const new({super.key, this.height = 16, this.width, this.radius = SbRadius.input});

  final double height;
  final double? width;
  final double radius;

  @override
  State<SbSkeleton> createState() => _SbSkeletonState();
}

class _SbSkeletonState extends State<SbSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Color.lerp(c.surfaceMuted, c.border, _controller.value),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}

/// A few skeleton lines, the default loading state for lists and cards.
class SbSkeletonList extends StatelessWidget {
  const new({super.key, this.lines = 4});

  final int lines;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.all(SbSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines; i++) ...[
          const SbSkeleton(height: 56, radius: SbRadius.card),
          if (i < lines - 1) const SizedBox(height: SbSpace.sm),
        ],
      ],
    ),
  );
}
