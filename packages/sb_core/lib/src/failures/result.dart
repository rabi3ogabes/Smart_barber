import 'package:sb_core/src/failures/app_failure.dart';

/// Outcome of an operation that can fail with an [AppFailure].
sealed class Result<T> {
  const new();

  /// Runs [body] and captures any error as [Err].
  static Future<Result<T>> guard<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } on Object catch (error) {
      return Err(AppFailure.from(error));
    }
  }

  /// Value or null.
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  /// Failure or null.
  AppFailure? get failureOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final failure) => failure,
  };
}

/// Success.
final class Ok<T> extends Result<T> {
  const new(this.value);

  final T value;
}

/// Failure.
final class Err<T> extends Result<T> {
  const new(this.failure);

  final AppFailure failure;
}
