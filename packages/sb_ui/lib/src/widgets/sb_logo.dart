import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

/// Placeholder wordmark until the brand logo exists (spec-review Q8). Does not mirror in RTL.
class SbLogo extends StatelessWidget {
  const new({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: c.primary, borderRadius: BorderRadius.circular(size * 0.22)),
        alignment: Alignment.center,
        child: Text(
          'S',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontFamily: 'packages/sb_ui/${SbFonts.displayLatin}',
            fontSize: size * 0.52,
            fontVariations: const [FontVariation.weight(600)],
            color: c.accent,
            height: 1,
          ),
        ),
      ),
    );
  }
}
