/// Machine-readable error codes returned by the API (backend `App\Core\Exceptions\ErrorCode`).
/// Apps translate these locally; unknown codes fall back to the server message.
abstract final class ApiErrorCode {
  static const validationFailed = 'VALIDATION_FAILED';
  static const unauthenticated = 'UNAUTHENTICATED';
  static const forbidden = 'FORBIDDEN';
  static const notFound = 'NOT_FOUND';
  static const rateLimited = 'RATE_LIMITED';
  static const serverError = 'SERVER_ERROR';
  static const serviceUnavailable = 'SERVICE_UNAVAILABLE';
  static const otpInvalid = 'OTP_INVALID';
  static const otpExpired = 'OTP_EXPIRED';
  static const otpTooManyAttempts = 'OTP_TOO_MANY_ATTEMPTS';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
  static const twoFactorRequired = 'TWO_FACTOR_REQUIRED';
  static const twoFactorInvalid = 'TWO_FACTOR_INVALID';
  static const twoFactorEnrollmentRequired = 'TWO_FACTOR_ENROLLMENT_REQUIRED';
  static const salonSelectionRequired = 'SALON_SELECTION_REQUIRED';
  static const noActiveMembership = 'NO_ACTIVE_MEMBERSHIP';
  static const membershipInactive = 'MEMBERSHIP_INACTIVE';
  static const salonSuspended = 'SALON_SUSPENDED';
  static const featureNotAvailable = 'FEATURE_NOT_AVAILABLE';
  static const refreshTokenInvalid = 'REFRESH_TOKEN_INVALID';
  static const refreshTokenReused = 'REFRESH_TOKEN_REUSED';
  static const challengeExpired = 'CHALLENGE_EXPIRED';
  static const idempotencyKeyRequired = 'IDEMPOTENCY_KEY_REQUIRED';
  static const idempotencyKeyReused = 'IDEMPOTENCY_KEY_REUSED';
  static const idempotencyInProgress = 'IDEMPOTENCY_IN_PROGRESS';

  /// Codes after which the stored session is no longer usable and the user must sign in again.
  static const Set<String> sessionEnding = {unauthenticated, refreshTokenInvalid, refreshTokenReused, membershipInactive};
}
