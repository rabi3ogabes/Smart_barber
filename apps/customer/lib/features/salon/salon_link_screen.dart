import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Opened by `smartbarber://salon/{slug}` or a scanned link: resolves it, remembers the salon,
/// then shows Home.
class SalonLinkScreen extends ConsumerStatefulWidget {
  const new({required this.code, super.key});

  final String code;

  @override
  ConsumerState<SalonLinkScreen> createState() => _SalonLinkScreenState();
}

class _SalonLinkScreenState extends ConsumerState<SalonLinkScreen> {
  AppFailure? _failure;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    unawaited(_resolve());
  }

  Future<void> _resolve() async {
    setState(() {
      _busy = true;
      _failure = null;
    });
    final result = await ref.read(salonRepositoryProvider).resolve(widget.code);
    if (!mounted) return;
    switch (result) {
      case Ok(:final value):
        await ref.read(currentSalonProvider.notifier).select(value);
        if (mounted) const HomeRoute().go(context);
      case Err(:final failure):
        setState(() {
          _busy = false;
          _failure = failure;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final notFound = _failure is ApiFailure && (_failure! as ApiFailure).status == 404;
    return Scaffold(
      appBar: AppBar(title: Text(l.salonEntryTitle)),
      body: _busy
          ? const Center(child: CircularProgressIndicator())
          : notFound
          ? SbEmptyState(
              icon: Icons.storefront_outlined,
              title: l.salonCodeNotFound,
              body: l.salonLinkNotFoundBody,
              action: SbButton(label: l.salonChooseAnother, onPressed: () => const SalonEntryRoute().go(context)),
            )
          : SbErrorState(failure: _failure, onRetry: _resolve),
    );
  }
}
