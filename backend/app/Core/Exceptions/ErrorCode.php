<?php

namespace App\Core\Exceptions;

/**
 * Machine-readable error codes (api-map.md). Apps translate them locally;
 * the server message comes from lang/{ar,en}/errors.php.
 */
enum ErrorCode: string
{
    case ValidationFailed = 'VALIDATION_FAILED';
    case Unauthenticated = 'UNAUTHENTICATED';
    case Forbidden = 'FORBIDDEN';
    case NotFound = 'NOT_FOUND';
    case MethodNotAllowed = 'METHOD_NOT_ALLOWED';
    case RateLimited = 'RATE_LIMITED';
    case ServerError = 'SERVER_ERROR';
    case ServiceUnavailable = 'SERVICE_UNAVAILABLE';
    case OtpInvalid = 'OTP_INVALID';
    case OtpExpired = 'OTP_EXPIRED';
    case OtpTooManyAttempts = 'OTP_TOO_MANY_ATTEMPTS';
    case InvalidCredentials = 'INVALID_CREDENTIALS';
    case TwoFactorRequired = 'TWO_FACTOR_REQUIRED';
    case TwoFactorInvalid = 'TWO_FACTOR_INVALID';
    case TwoFactorEnrollmentRequired = 'TWO_FACTOR_ENROLLMENT_REQUIRED';
    case SalonSelectionRequired = 'SALON_SELECTION_REQUIRED';
    case NoActiveMembership = 'NO_ACTIVE_MEMBERSHIP';
    case MembershipInactive = 'MEMBERSHIP_INACTIVE';
    case SalonSuspended = 'SALON_SUSPENDED';
    case FeatureNotAvailable = 'FEATURE_NOT_AVAILABLE';
    case RefreshTokenInvalid = 'REFRESH_TOKEN_INVALID';
    case RefreshTokenReused = 'REFRESH_TOKEN_REUSED';
    case ChallengeExpired = 'CHALLENGE_EXPIRED';
    case IdempotencyKeyRequired = 'IDEMPOTENCY_KEY_REQUIRED';
    case IdempotencyKeyInvalid = 'IDEMPOTENCY_KEY_INVALID';
    case IdempotencyKeyReused = 'IDEMPOTENCY_KEY_REUSED';
    case IdempotencyInProgress = 'IDEMPOTENCY_IN_PROGRESS';
    case LastActiveBranch = 'LAST_ACTIVE_BRANCH';
    case LastActiveOwner = 'LAST_ACTIVE_OWNER';
    case CannotChangeOwnAccess = 'CANNOT_CHANGE_OWN_ACCESS';
    case InvitationInvalid = 'INVITATION_INVALID';
    case InvitationAccountMismatch = 'INVITATION_ACCOUNT_MISMATCH';
    case AlreadyMember = 'ALREADY_MEMBER';
    case RoleNotAssignable = 'ROLE_NOT_ASSIGNABLE';
    case ScheduleRangesOverlap = 'SCHEDULE_RANGES_OVERLAP';
    case TimeOffNotPending = 'TIME_OFF_NOT_PENDING';
    case TimeOffOverlaps = 'TIME_OFF_OVERLAPS';
    case ServiceUnavailableAtBranch = 'SERVICE_UNAVAILABLE_AT_BRANCH';
    case BarberNotEligible = 'BARBER_NOT_ELIGIBLE';
    case CatalogSelectionInvalid = 'CATALOG_SELECTION_INVALID';
    case CategoryNotEmpty = 'CATEGORY_NOT_EMPTY';
    case BookingSlotTaken = 'BOOKING_SLOT_TAKEN';
    case BookingOutsideHours = 'BOOKING_OUTSIDE_HOURS';
    case BookingLeadTime = 'BOOKING_LEAD_TIME';
    case BookingTooFarAhead = 'BOOKING_TOO_FAR_AHEAD';
    case BookingInPast = 'BOOKING_IN_PAST';
    case BookingInvalidTransition = 'BOOKING_INVALID_TRANSITION';
    case BookingCancelWindowPassed = 'BOOKING_CANCEL_WINDOW_PASSED';
    case BookingNotStarted = 'BOOKING_NOT_STARTED';

    public function status(): int
    {
        return match ($this) {
            self::ValidationFailed, self::OtpInvalid, self::OtpExpired, self::TwoFactorInvalid,
            self::IdempotencyKeyReused, self::IdempotencyKeyInvalid, self::InvalidCredentials,
            self::LastActiveBranch, self::LastActiveOwner, self::CannotChangeOwnAccess, self::InvitationAccountMismatch,
            self::AlreadyMember, self::ScheduleRangesOverlap, self::TimeOffNotPending, self::TimeOffOverlaps,
            self::ServiceUnavailableAtBranch, self::BarberNotEligible, self::CatalogSelectionInvalid, self::CategoryNotEmpty,
            self::BookingOutsideHours, self::BookingLeadTime, self::BookingTooFarAhead, self::BookingInPast,
            self::BookingCancelWindowPassed, self::BookingNotStarted => 422,
            self::BookingSlotTaken, self::BookingInvalidTransition => 409,
            self::InvitationInvalid => 410,
            self::RoleNotAssignable => 403,
            self::Unauthenticated, self::RefreshTokenInvalid, self::RefreshTokenReused,
            self::ChallengeExpired, self::MembershipInactive => 401,
            self::Forbidden, self::NoActiveMembership, self::SalonSuspended, self::FeatureNotAvailable,
            self::TwoFactorEnrollmentRequired => 403,
            self::NotFound => 404,
            self::MethodNotAllowed => 405,
            self::IdempotencyInProgress, self::SalonSelectionRequired, self::TwoFactorRequired => 409,
            self::IdempotencyKeyRequired => 428,
            self::RateLimited, self::OtpTooManyAttempts => 429,
            self::ServiceUnavailable => 503,
            self::ServerError => 500,
        };
    }

    public function message(): string
    {
        return __('errors.'.$this->value);
    }
}
