import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_staff/app/preferences_controllers.dart';

/// Shared layout for the sign-in steps, with a language toggle.
class AuthScaffold extends ConsumerWidget {
  const new({required this.title, required this.subtitle, required this.children, super.key, this.leading});

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? leading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sb = SbLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        shape: const Border(),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: () => ref.read(appLocaleProvider.notifier).set(Locale(isArabic ? 'en' : 'ar')),
            icon: const Icon(Icons.translate_rounded, size: 18),
            label: Text(isArabic ? sb.languageEnglish : sb.languageArabic),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(SbSpace.xl),
          children: [
            const Align(alignment: AlignmentDirectional.centerStart, child: SbLogo()),
            const SizedBox(height: SbSpace.xl),
            Text(title, style: context.sbText.headlineMedium),
            const SizedBox(height: SbSpace.xs),
            Text(subtitle, style: context.sbText.bodyLarge?.copyWith(color: context.sbColors.textSecondary)),
            const SizedBox(height: SbSpace.xl),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Inline error text under a form.
class FormErrorText extends StatelessWidget {
  const new(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsetsDirectional.only(top: SbSpace.sm),
          child: Text(message!, style: context.sbText.bodySmall?.copyWith(color: context.sbColors.error)),
        );
}
