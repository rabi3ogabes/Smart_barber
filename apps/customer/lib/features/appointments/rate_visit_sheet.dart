import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// "Rate your visit": 1–5 stars and an optional comment. True when a review was saved.
Future<bool?> showRateVisitSheet(BuildContext context, CustomerBooking booking) =>
    showSbSheet<bool>(context: context, title: AppLocalizations.of(context).rateVisitTitle, builder: (_) => RateVisitForm(bookingId: booking.id));

class RateVisitForm extends ConsumerStatefulWidget {
  const new({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<RateVisitForm> createState() => _RateVisitFormState();
}

class _RateVisitFormState extends ConsumerState<RateVisitForm> {
  int _rating = 0;
  final _comment = TextEditingController();
  bool _saving = false;
  String? _error;
  String? _key;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    if (_rating == 0) {
      setState(() => _error = l.ratingRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    _key ??= Idempotency.newKey();
    final text = _comment.text.trim();
    final result = await ref.read(bookingRepositoryProvider).review(widget.bookingId, rating: _rating, idempotencyKey: _key!, comment: text.isEmpty ? null : text);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok():
        showMessage(context, l.ratingThanks);
        Navigator.pop(context, true);
      case Err(:final failure):
        setState(() => _error = failureMessage(SbLocalizations.of(context), failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.sbColors;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.rateVisitBody, style: context.sbText.bodyMedium?.copyWith(color: c.textSecondary)),
          const SizedBox(height: SbSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  iconSize: 40,
                  tooltip: l.starsLabel(i),
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded, color: c.accent),
                ),
            ],
          ),
          const SizedBox(height: SbSpace.md),
          SbTextField(label: l.ratingCommentLabel, hint: l.ratingCommentHint, controller: _comment, maxLength: 1000),
          if (_error != null) ...[
            const SizedBox(height: SbSpace.xs),
            Text(_error!, style: context.sbText.bodySmall?.copyWith(color: c.error)),
          ],
          const SizedBox(height: SbSpace.md),
          SbButton(label: l.ratingSubmit, expand: true, loading: _saving, onPressed: _saving ? null : _submit),
        ],
      ),
    );
  }
}
