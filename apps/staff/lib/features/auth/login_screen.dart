import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_staff/app/providers.dart';
import 'package:smartbarber_staff/app/session.dart';
import 'package:smartbarber_staff/features/auth/auth_scaffold.dart';
import 'package:smartbarber_staff/features/auth/login_controller.dart';
import 'package:smartbarber_staff/l10n/generated/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _emailError;
  String? _passwordError;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final email = _email.text.trim().toLowerCase();
    setState(() {
      _emailError = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email) ? null : l.emailInvalid;
      _passwordError = _password.text.isEmpty ? l.passwordRequired : null;
      _error = null;
    });
    if (_emailError != null || _passwordError != null) return;

    setState(() => _loading = true);
    final result = await ref.read(staffAuthRepositoryProvider).login(email: email, password: _password.text, deviceName: 'staff-app');
    if (!mounted) return;
    final failure = await applyLoginStep(ref, result);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = failure == null ? null : failureMessage(sb, failure);
      if (failure is ApiFailure) {
        _emailError = failure.fieldError('email') ?? _emailError;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final session = ref.watch(staffSessionProvider).value;
    final expired = session is StaffSignedOut && session.expired;

    return AutofillGroup(
      child: AuthScaffold(
        title: l.loginTitle,
        subtitle: l.loginSubtitle,
        children: [
          if (expired) ...[SbBadge(label: l.sessionExpired, tone: SbTone.warning), const SizedBox(height: SbSpace.lg)],
          SbTextField(
            label: l.email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            ltr: true,
            error: _emailError,
          ),
          const SizedBox(height: SbSpace.lg),
          SbTextField(
            label: l.password,
            controller: _password,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            ltr: true,
            error: _passwordError,
            onSubmitted: (_) => _submit(),
          ),
          FormErrorText(_error),
          const SizedBox(height: SbSpace.xl),
          SbButton(label: l.signIn, onPressed: _submit, loading: _loading, expand: true),
        ],
      ),
    );
  }
}
