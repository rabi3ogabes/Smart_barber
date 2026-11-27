import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';

class SplashScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SbLogo(size: 72),
          const SizedBox(height: SbSpace.xl),
          SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2, semanticsLabel: SbLocalizations.of(context).loading)),
        ],
      ),
    ),
  );
}
