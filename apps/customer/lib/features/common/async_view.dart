import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';

extension ResultOrThrow<T> on Result<T> {
  /// The value, or throws the failure, so FutureProviders surface typed [AppFailure]s.
  T get orThrow => switch (this) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
}

/// Maps a provider's [AsyncValue] onto the shared screen states (rule 11): loading, error with
/// retry, empty and content. Errors are always [AppFailure]s, never raw exceptions.
class AsyncView<T> extends StatelessWidget {
  const new({required this.value, required this.builder, super.key, this.onRetry, this.isEmpty, this.empty, this.loading});

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    final state = switch (value) {
      AsyncData(:final value) when isEmpty?.call(value) ?? false => SbEmpty<T>(),
      AsyncData(:final value) => SbContent(value),
      AsyncError(:final error) when !value.hasValue => _failed(error),
      AsyncError() => SbContent(value.requireValue),
      _ when value.hasValue => SbContent(value.requireValue),
      _ => SbLoading<T>(),
    };
    return SbStateView<T>(state: state, builder: builder, onRetry: onRetry, empty: empty, loading: loading);
  }

  SbViewState<T> _failed(Object error) {
    final failure = AppFailure.from(error);
    return failure is ApiFailure && failure.status == 403 ? SbNoPermission<T>() : SbFailed<T>(failure);
  }
}

/// A snackbar with the translated failure message.
void showFailure(BuildContext context, AppFailure failure) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failureMessage(SbLocalizations.of(context), failure))));
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
