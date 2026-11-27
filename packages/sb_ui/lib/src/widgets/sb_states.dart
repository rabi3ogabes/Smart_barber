import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/l10n/generated/sb_localizations.dart';
import 'package:sb_ui/src/failure_message.dart';
import 'package:sb_ui/src/theme/sb_theme.dart';
import 'package:sb_ui/src/tokens/sb_tokens.g.dart';
import 'package:sb_ui/src/widgets/sb_button.dart';
import 'package:sb_ui/src/widgets/sb_skeleton.dart';

class _StateLayout extends StatelessWidget {
  const new({required this.icon, required this.iconBg, required this.iconFg, required this.title, this.body, this.action});

  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsetsDirectional.all(SbSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconFg),
          ),
          const SizedBox(height: SbSpace.md),
          Text(title, textAlign: TextAlign.center, style: context.sbText.titleMedium),
          if (body != null) ...[
            const SizedBox(height: SbSpace.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(body!, textAlign: TextAlign.center, style: context.sbText.bodyMedium?.copyWith(color: context.sbColors.textSecondary)),
            ),
          ],
          if (action != null) ...[const SizedBox(height: SbSpace.lg), action!],
        ],
      ),
    ),
  );
}

class SbEmptyState extends StatelessWidget {
  const new({super.key, this.title, this.body, this.icon = Icons.inbox_outlined, this.action});

  final String? title;
  final String? body;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => _StateLayout(
    icon: icon,
    iconBg: context.sbColors.accentSoft,
    iconFg: context.sbColors.accent,
    title: title ?? SbLocalizations.of(context).emptyTitle,
    body: body,
    action: action,
  );
}

/// Error with retry. Shows a translated message for [failure], never a raw exception (rule 11).
class SbErrorState extends StatelessWidget {
  const new({super.key, this.failure, this.onRetry, this.retrying = false});

  final AppFailure? failure;
  final VoidCallback? onRetry;
  final bool retrying;

  @override
  Widget build(BuildContext context) {
    final l = SbLocalizations.of(context);
    final offline = failure is NetworkFailure;
    return _StateLayout(
      icon: offline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
      iconBg: context.sbColors.errorSoft,
      iconFg: context.sbColors.error,
      title: l.errorTitle,
      body: failure == null ? l.errorBody : failureMessage(l, failure!),
      action: onRetry == null ? null : SbButton(label: l.retry, onPressed: onRetry, loading: retrying, variant: SbButtonVariant.secondary, icon: Icons.refresh_rounded),
    );
  }
}

class SbNoPermissionState extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = SbLocalizations.of(context);
    return _StateLayout(
      icon: Icons.lock_outline_rounded,
      iconBg: context.sbColors.surfaceMuted,
      iconFg: context.sbColors.textSecondary,
      title: l.noPermissionTitle,
      body: l.noPermissionBody,
    );
  }
}

/// Thin banner shown above content while offline (flutter.md, Offline).
class SbOfflineBanner extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    return Semantics(
      liveRegion: true,
      child: Material(
        color: c.warningSoft,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: SbSpace.lg, vertical: SbSpace.xs),
            child: Row(
              children: [
                Icon(Icons.wifi_off_rounded, size: 18, color: c.warning),
                const SizedBox(width: SbSpace.xs),
                Expanded(child: Text(SbLocalizations.of(context).offlineBanner, style: context.sbText.labelMedium?.copyWith(color: c.warning))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The states every screen must handle (rule 11).
sealed class SbViewState<T> {
  const new();
}

final class SbLoading<T> extends SbViewState<T> {
  const new();
}

final class SbEmpty<T> extends SbViewState<T> {
  const new();
}

final class SbContent<T> extends SbViewState<T> {
  const new(this.value);

  final T value;
}

final class SbFailed<T> extends SbViewState<T> {
  const new(this.failure);

  final AppFailure failure;
}

final class SbNoPermission<T> extends SbViewState<T> {
  const new();
}

/// Renders the right widget for a [SbViewState]: skeleton, empty, error + retry, no-permission or content.
class SbStateView<T> extends StatelessWidget {
  const new({required this.state, required this.builder, super.key, this.onRetry, this.empty, this.loading});

  final SbViewState<T> state;
  final Widget Function(BuildContext context, T value) builder;
  final VoidCallback? onRetry;
  final Widget? empty;
  final Widget? loading;

  @override
  Widget build(BuildContext context) => switch (state) {
    SbLoading<T>() => loading ?? const SbSkeletonList(),
    SbEmpty<T>() => empty ?? const SbEmptyState(),
    SbFailed<T>(:final failure) => SbErrorState(failure: failure, onRetry: onRetry),
    SbNoPermission<T>() => const SbNoPermissionState(),
    SbContent<T>(:final value) => builder(context, value),
  };
}
