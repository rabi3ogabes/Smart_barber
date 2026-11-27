import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/l10n/generated/sb_localizations.dart';

/// Translated, user-facing text for a failure. Server codes map to local strings; an unknown
/// code falls back to the server's (already translated) message, never a raw exception.
String failureMessage(SbLocalizations l, AppFailure failure) {
  return switch (failure) {
    NetworkFailure(issue: NetworkIssue.offline) => l.errorNetworkOffline,
    NetworkFailure(issue: NetworkIssue.timeout) => l.errorNetworkTimeout,
    CancelledFailure() || UnknownFailure() => l.errorGeneric,
    ApiFailure(:final code, :final message) => switch (code) {
      ApiErrorCode.validationFailed => l.errorValidation,
      ApiErrorCode.unauthenticated => l.errorUnauthenticated,
      ApiErrorCode.forbidden => l.errorForbidden,
      ApiErrorCode.notFound => l.errorNotFound,
      ApiErrorCode.rateLimited => l.errorRateLimited,
      ApiErrorCode.serviceUnavailable => l.errorServiceUnavailable,
      ApiErrorCode.otpInvalid => l.errorOtpInvalid,
      ApiErrorCode.otpExpired => l.errorOtpExpired,
      ApiErrorCode.otpTooManyAttempts => l.errorOtpTooManyAttempts,
      ApiErrorCode.invalidCredentials => l.errorInvalidCredentials,
      ApiErrorCode.twoFactorInvalid => l.errorTwoFactorInvalid,
      ApiErrorCode.twoFactorEnrollmentRequired => l.errorTwoFactorEnrollment,
      ApiErrorCode.noActiveMembership => l.errorNoActiveMembership,
      ApiErrorCode.membershipInactive => l.errorMembershipInactive,
      ApiErrorCode.salonSuspended => l.errorSalonSuspended,
      ApiErrorCode.featureNotAvailable => l.errorFeatureNotAvailable,
      ApiErrorCode.refreshTokenInvalid || ApiErrorCode.refreshTokenReused => l.errorSessionEnded,
      ApiErrorCode.challengeExpired => l.errorChallengeExpired,
      ApiErrorCode.idempotencyInProgress => l.errorRequestInProgress,
      ApiErrorCode.serverError => l.errorGeneric,
      _ => (message == null || message.isEmpty) ? l.errorGeneric : message,
    },
  };
}
