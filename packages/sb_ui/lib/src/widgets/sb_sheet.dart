import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

/// Opens a bottom sheet with a title and safe-area padding.
Future<T?> showSbSheet<T>({required BuildContext context, required String title, required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsetsDirectional.fromSTEB(SbSpace.xl, 0, SbSpace.xl, SbSpace.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: context.sbText.titleMedium),
          const SizedBox(height: SbSpace.lg),
          Flexible(child: builder(context)),
        ],
      ),
    ),
  );
}
