import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';

/// Labelled text field. Phones, emails and codes stay LTR inside Arabic screens ([ltr]).
class SbTextField extends StatelessWidget {
  const new({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.helper,
    this.error,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.ltr = false,
    this.maxLength,
    this.onSubmitted,
    this.onChanged,
    this.prefix,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final String? error;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final bool ltr;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: context.sbText.labelMedium),
        const SizedBox(height: SbSpace.xs - 2),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          autofocus: autofocus,
          enabled: enabled,
          maxLength: maxLength,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          textDirection: ltr ? TextDirection.ltr : null,
          style: context.sbText.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            helperText: error == null ? helper : null,
            errorText: error,
            errorMaxLines: 3,
            counterText: '',
            prefixIcon: prefix,
          ),
        ),
      ],
    );
  }
}
