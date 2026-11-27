import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_staff/app/providers.dart';
import 'package:smartbarber_staff/app/session.dart';
import 'package:smartbarber_staff/features/auth/auth_scaffold.dart';
import 'package:smartbarber_staff/features/auth/login_controller.dart';
import 'package:smartbarber_staff/l10n/generated/app_localizations.dart';

class TwoFactorScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends ConsumerState<TwoFactorScreen> {
  final _code = TextEditingController();
  bool _recovery = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final step = ref.read(loginFlowProvider);
    if (step is! StaffTwoFactorRequired) return;
    if (_code.text.trim().isEmpty) {
      setState(() => _error = l.codeRequired);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(staffAuthRepositoryProvider).verifyTwoFactor(challengeToken: step.challengeToken, code: _code.text.trim());
    if (!mounted) return;
    final failure = await applyLoginStep(ref, result);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = failure == null ? null : failureMessage(sb, failure);
    });
    if (failure != null) _code.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AuthScaffold(
      title: l.twoFactorTitle,
      subtitle: _recovery ? l.recoverySubtitle : l.twoFactorSubtitle,
      leading: IconButton(
        tooltip: l.startOver,
        icon: const SbDirectionalIcon(Icons.arrow_back_rounded),
        onPressed: () => ref.read(loginFlowProvider.notifier).set(null),
      ),
      children: [
        SbTextField(
          label: _recovery ? l.recoveryCode : l.code,
          controller: _code,
          keyboardType: _recovery ? TextInputType.text : TextInputType.number,
          inputFormatters: _recovery ? null : [FilteringTextInputFormatter.digitsOnly],
          autofillHints: const [AutofillHints.oneTimeCode],
          maxLength: _recovery ? 20 : 6,
          ltr: true,
          autofocus: true,
          error: _error,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: SbSpace.xl),
        SbButton(label: l.verify, onPressed: _submit, loading: _loading, expand: true),
        const SizedBox(height: SbSpace.sm),
        SbButton(
          label: _recovery ? l.useAuthenticator : l.useRecovery,
          variant: SbButtonVariant.ghost,
          expand: true,
          onPressed: () => setState(() {
            _recovery = !_recovery;
            _code.clear();
            _error = null;
          }),
        ),
      ],
    );
  }
}
