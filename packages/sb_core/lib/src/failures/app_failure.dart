import 'package:dio/dio.dart';
import 'package:sb_core/src/failures/api_error_code.dart';

/// Every error the apps can show. Exhaustive `switch` keeps error handling complete (flutter.md, Models).
sealed class AppFailure implements Exception {
  const new();

  /// Maps any Dio error to a failure. Raw exceptions never reach the UI (rule 11).
  factory fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return const NetworkFailure(NetworkIssue.offline);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkFailure(NetworkIssue.timeout);
      case DioExceptionType.cancel:
        return const CancelledFailure();
      case DioExceptionType.badResponse:
        return ApiFailure.fromResponse(e.response);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is AppFailure) return e.error! as AppFailure;
        return UnknownFailure(e.error ?? e.message);
    }
  }

  /// Maps any thrown object to a failure.
  factory from(Object error) => switch (error) {
    final AppFailure f => f,
    final DioException e => AppFailure.fromDio(e),
    _ => UnknownFailure(error),
  };
}

/// Why the network failed.
enum NetworkIssue { offline, timeout }

/// No connection or the server did not answer in time.
final class NetworkFailure extends AppFailure {
  const new(this.issue);

  final NetworkIssue issue;

  @override
  String toString() => 'NetworkFailure($issue)';
}

/// The API answered with the error envelope `{success:false, code, message, errors, data}`.
final class ApiFailure extends AppFailure {
  const new({
    required this.code,
    required this.status,
    this.message,
    this.fieldErrors = const {},
    this.data = const {},
  });

  /// Builds a failure from any error response; non-envelope bodies map to a server error.
  factory fromResponse(Response<dynamic>? response) {
    final status = response?.statusCode ?? 0;
    final body = response?.data;
    if (body is Map && body['success'] == false && body['code'] is String) {
      final errors = <String, List<String>>{};
      final rawErrors = body['errors'];
      if (rawErrors is Map) {
        rawErrors.forEach((key, value) {
          if (value is List) errors['$key'] = value.map((v) => '$v').toList();
        });
      }
      final data = body['data'];

      return ApiFailure(
        code: body['code'] as String,
        status: status,
        message: body['message'] is String ? body['message'] as String : null,
        fieldErrors: errors,
        data: data is Map ? data.cast<String, Object?>() : const {},
      );
    }

    return ApiFailure(
      code: status == 401 ? ApiErrorCode.unauthenticated : ApiErrorCode.serverError,
      status: status,
    );
  }

  /// Machine-readable code (see [ApiErrorCode]).
  final String code;

  /// HTTP status.
  final int status;

  /// Server message, already translated by Accept-Language.
  final String? message;

  /// Field validation errors.
  final Map<String, List<String>> fieldErrors;

  /// Extra payload (e.g. `retry_after`, `challenge_token`).
  final Map<String, Object?> data;

  /// Whether the stored session must be discarded.
  bool get endsSession => ApiErrorCode.sessionEnding.contains(code);

  /// First error for a field, if any.
  String? fieldError(String field) => fieldErrors[field]?.firstOrNull;

  @override
  String toString() => 'ApiFailure($status $code)';
}

/// The request was cancelled by the app.
final class CancelledFailure extends AppFailure {
  const new();
}

/// Anything else (parse errors, platform errors). Shown as a generic error with retry.
final class UnknownFailure extends AppFailure {
  const new([this.cause]);

  final Object? cause;

  @override
  String toString() => 'UnknownFailure';
}
