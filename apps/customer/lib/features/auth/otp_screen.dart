import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// U+2066 LEFT-TO-RIGHT ISOLATE … U+2069 POP DIRECTIONAL ISOLATE.
String _ltrIsolate(String text) => '${String.fromCharCode(0x2066)}$text${String.fromCharCode(0x2069)}';

class OtpScreen extends ConsumerStatefulWidget {
  const new({required this.phone, super.key, this.retryAfter = 60, this.from});

  final String phone;
  final int retryAfter;
  final String? from;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  Timer? _timer;
  late int _secondsLeft = widget.retryAfter;
  bool _verifying = false;
  bool _resending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startCountdown(widget.retryAfter);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) t.cancel();
      if (mounted) setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 9999));
    });
  }

  Future<void> _verify() async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final code = _code.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(() => _error = l.otpInvalidFormat);
      return;
    }

    setState(() {
      _verifying = true;
      _error = null;
    });
    final result = await ref.read(customerAuthRepositoryProvider).verifyOtp(phone: widget.phone, code: code, deviceName: 'customer-app');
    if (!mounted) return;

    switch (result) {
      case Ok(:final value):
        // The router redirect takes the user on (to `from` or Home) once the session changes.
        await ref.read(customerSessionProvider.notifier).signedIn(value);
      case Err(:final failure):
        setState(() {
          _verifying = false;
          _error = failureMessage(sb, failure);
        });
    }
  }

  Future<void> _resend() async {
    final l = AppLocalizations.of(context);
    final sb = SbLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _resending = true);
    final result = await ref.read(customerAuthRepositoryProvider).requestOtp(widget.phone);
    if (!mounted) return;
    setState(() => _resending = false);
    switch (result) {
      case Ok(:final value):
        _startCountdown(value.retryAfter);
        messenger.showSnackBar(SnackBar(content: Text(l.codeResent)));
      case Err(:final failure):
        final retry = failure is ApiFailure ? failure.data['retry_after'] : null;
        if (retry is int) _startCountdown(retry);
        setState(() => _error = failureMessage(sb, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const SbDirectionalIcon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(SbSpace.xl),
          children: [
            Text(l.otpTitle, style: context.sbText.headlineMedium),
            const SizedBox(height: SbSpace.xs),
            Text(
              // Phone numbers stay LTR inside Arabic text: wrap them in a left-to-right isolate.
              l.otpSubtitle(_ltrIsolate(widget.phone)),
              style: context.sbText.bodyLarge?.copyWith(color: context.sbColors.textSecondary),
            ),
            const SizedBox(height: SbSpace.xl),
            SbTextField(
              label: l.otpLabel,
              controller: _code,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 6,
              ltr: true,
              autofocus: true,
              error: _error,
              onSubmitted: (_) => _verify(),
              onChanged: (v) {
                if (v.length == 6 && !_verifying) unawaited(_verify());
              },
            ),
            const SizedBox(height: SbSpace.xl),
            SbButton(label: l.verify, onPressed: _verify, loading: _verifying, expand: true),
            const SizedBox(height: SbSpace.sm),
            SbButton(
              label: _secondsLeft > 0 ? l.resendIn(_secondsLeft) : l.resend,
              onPressed: _secondsLeft > 0 ? null : _resend,
              loading: _resending,
              variant: SbButtonVariant.ghost,
              expand: true,
            ),
            SbButton(label: l.changeNumber, onPressed: () => context.pop(), variant: SbButtonVariant.ghost, expand: true),
          ],
        ),
      ),
    );
  }
}
