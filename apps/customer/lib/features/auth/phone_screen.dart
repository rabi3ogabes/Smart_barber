import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/auth/phone_number.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const new({super.key, this.from});

  final String? from;

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phone = TextEditingController();
  bool _loading = false;
  String? _fieldError;
  AppFailure? _failure;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final phone = normalizePhone(_phone.text);
    if (phone == null) {
      setState(() => _fieldError = l.phoneInvalid);
      return;
    }

    setState(() {
      _loading = true;
      _fieldError = null;
      _failure = null;
    });
    final result = await ref.read(customerAuthRepositoryProvider).requestOtp(phone);
    if (!mounted) return;
    setState(() => _loading = false);

    switch (result) {
      case Ok(:final value):
        OtpRoute(phone: phone, retryAfter: value.retryAfter, from: widget.from).go(context);
      case Err(:final failure):
        setState(() {
          _failure = failure;
          if (failure is ApiFailure) _fieldError = failure.fieldError('phone');
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final expired = ref.watch(customerSessionProvider).value is SignedOut &&
        (ref.watch(customerSessionProvider).value! as SignedOut).expired;
    final failure = _failure;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(SbSpace.xl),
          children: [
            const SizedBox(height: SbSpace.xxl),
            const Align(alignment: AlignmentDirectional.centerStart, child: SbLogo()),
            const SizedBox(height: SbSpace.xl),
            Text(l.phoneTitle, style: context.sbText.headlineMedium),
            const SizedBox(height: SbSpace.xs),
            Text(l.phoneSubtitle, style: context.sbText.bodyLarge?.copyWith(color: context.sbColors.textSecondary)),
            if (expired) ...[
              const SizedBox(height: SbSpace.lg),
              SbBadge(label: l.sessionExpired, tone: SbTone.warning),
            ],
            const SizedBox(height: SbSpace.xl),
            SbTextField(
              label: l.phoneLabel,
              controller: _phone,
              hint: l.phoneHint,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              ltr: true,
              autofocus: true,
              error: _fieldError,
              prefix: Padding(
                padding: const EdgeInsetsDirectional.only(start: SbSpace.md, end: SbSpace.xs),
                child: Text('+974', textDirection: TextDirection.ltr, style: context.sbText.bodyLarge?.copyWith(color: context.sbColors.textSecondary)),
              ),
              onSubmitted: (_) => _submit(),
            ),
            if (failure != null && _fieldError == null) ...[
              const SizedBox(height: SbSpace.sm),
              Text(failureMessage(SbLocalizations.of(context), failure), style: context.sbText.bodySmall?.copyWith(color: context.sbColors.error)),
            ],
            const SizedBox(height: SbSpace.xl),
            SbButton(label: l.sendCode, onPressed: _submit, loading: _loading, expand: true),
          ],
        ),
      ),
    );
  }
}
