
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/routes.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/common/display.dart';
import 'package:smartbarber_customer/features/salon/salon_providers.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Opens a salon: by QR or link first (spec-review item 2), then "your salons", then name search
/// (only salons that opted in are found).
class SalonEntryScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SalonEntryScreen> createState() => _SalonEntryScreenState();
}

class _SalonEntryScreenState extends ConsumerState<SalonEntryScreen> {
  final _code = TextEditingController();
  final _search = TextEditingController();
  bool _resolving = false;
  String? _codeError;
  bool _searching = false;
  List<SalonCard>? _results;
  AppFailure? _searchFailure;

  @override
  void dispose() {
    _code.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _open(SalonCard salon) async {
    await ref.read(currentSalonProvider.notifier).select(salon);
    if (mounted) const HomeRoute().go(context);
  }

  Future<void> _resolve(String code) async {
    final l = AppLocalizations.of(context);
    if (code.trim().isEmpty) {
      setState(() => _codeError = l.salonCodeRequired);
      return;
    }
    setState(() {
      _resolving = true;
      _codeError = null;
    });
    final result = await ref.read(salonRepositoryProvider).resolve(code.trim());
    if (!mounted) return;
    setState(() => _resolving = false);
    switch (result) {
      case Ok(:final value):
        await _open(value);
      case Err(:final failure):
        setState(
          () => _codeError = failure is ApiFailure && failure.status == 404
              ? l.salonCodeNotFound
              : failureMessage(SbLocalizations.of(context), failure),
        );
    }
  }

  Future<void> _scan() async {
    final code = await const QrScanRoute().push<String>(context);
    if (code != null && mounted) {
      _code.text = code;
      await _resolve(code);
    }
  }

  Future<void> _runSearch() async {
    final q = _search.text.trim();
    if (q.length < 2) return;
    setState(() {
      _searching = true;
      _searchFailure = null;
    });
    final result = await ref.read(salonRepositoryProvider).search(q);
    if (!mounted) return;
    setState(() {
      _searching = false;
      _results = result.valueOrNull;
      _searchFailure = result.failureOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mine = ref.watch(mySalonsProvider);
    final current = ref.watch(currentSalonProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.salonEntryTitle),
        automaticallyImplyLeading: current != null,
        leading: current != null ? BackButton(onPressed: () => const HomeRoute().go(context)) : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(mySalonsProvider.future),
        child: ListView(
          padding: const EdgeInsetsDirectional.all(SbSpace.lg),
          children: [
            Text(l.salonEntrySubtitle, style: context.sbText.bodyMedium?.copyWith(color: context.sbColors.textSecondary)),
            const SizedBox(height: SbSpace.lg),
            SbButton(label: l.salonScanQr, icon: Icons.qr_code_scanner_rounded, expand: true, onPressed: _resolving ? null : _scan),
            const SizedBox(height: SbSpace.lg),
            SbTextField(
              label: l.salonCodeLabel,
              hint: l.salonCodeHint,
              controller: _code,
              error: _codeError,
              textInputAction: TextInputAction.go,
              onSubmitted: _resolve,
            ),
            const SizedBox(height: SbSpace.sm),
            SbButton(
              label: l.salonOpen,
              variant: SbButtonVariant.secondary,
              expand: true,
              loading: _resolving,
              onPressed: () => _resolve(_code.text),
            ),
            const SizedBox(height: SbSpace.xl),
            Text(l.salonYours, style: context.sbText.titleMedium),
            const SizedBox(height: SbSpace.sm),
            AsyncView<List<SalonCard>>(
              value: mine,
              onRetry: () => ref.invalidate(mySalonsProvider),
              isEmpty: (list) => list.isEmpty,
              loading: const SbSkeletonList(lines: 2),
              empty: Text(l.salonYoursEmpty, style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
              builder: (context, list) => Column(children: [for (final s in list) _SalonTile(salon: s, onTap: () => _open(s))]),
            ),
            const SizedBox(height: SbSpace.xl),
            Text(l.salonSearchTitle, style: context.sbText.titleMedium),
            const SizedBox(height: SbSpace.sm),
            SbTextField(
              label: l.salonSearchLabel,
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              helper: l.salonSearchHelper,
            ),
            const SizedBox(height: SbSpace.sm),
            if (_searching)
              const SbSkeletonList(lines: 2)
            else if (_searchFailure != null)
              SbErrorState(failure: _searchFailure, onRetry: _runSearch)
            else if (_results != null && _results!.isEmpty)
              SbEmptyState(icon: Icons.search_off_rounded, title: l.salonSearchEmpty, body: l.salonSearchEmptyBody)
            else if (_results != null)
              for (final s in _results!) _SalonTile(salon: s, onTap: () => _open(s)),
          ],
        ),
      ),
    );
  }
}

class _SalonTile extends StatelessWidget {
  const new({required this.salon, required this.onTap});

  final SalonCard salon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final address = context.tr(salon.address);
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: SbSpace.sm),
      child: SbCard(
        onTap: onTap,
        padding: const EdgeInsetsDirectional.all(SbSpace.md),
        child: Row(
          children: [
            SbAvatar(label: context.tr(salon.name), url: salon.logoUrl),
            const SizedBox(width: SbSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr(salon.name), style: context.sbText.titleSmall),
                  Text(
                    address.isEmpty ? l.salonBranches(salon.branchesCount) : address,
                    style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SbDirectionalIcon(Icons.chevron_right_rounded, color: context.sbColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
