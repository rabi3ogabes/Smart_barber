import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sb_api/src/models/converters.dart';
import 'package:sb_api/src/models/localized.dart';
import 'package:sb_api/src/models/money.dart';
import 'package:sb_api/src/models/salon.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// Booking statuses (backend `BookingStatus`). Unknown values map to [unknown] so a newer server
/// never crashes an older app.
enum BookingStatus {
  pending,
  confirmed,
  arrived,
  @JsonValue('in_service')
  inService,
  completed,
  cancelled,
  @JsonValue('no_show')
  noShow,
  unknown;

  bool get isUpcoming => this == pending || this == confirmed || this == arrived || this == inService;
}

@freezed
abstract class BookingBarber with _$BookingBarber {
  const factory({required String id, @LocalizedConverter() required LocalizedText name}) = _BookingBarber;

  factory fromJson(Map<String, Object?> json) => _$BookingBarberFromJson(json);
}

@freezed
abstract class BookingItem with _$BookingItem {
  const factory({
    required String type,
    @LocalizedConverter() required LocalizedText name,
    required int durationMinutes,
    required Money total,
    String? service,
  }) = _BookingItem;

  factory fromJson(Map<String, Object?> json) => _$BookingItemFromJson(json);
}

@freezed
abstract class BookingHistoryEntry with _$BookingHistoryEntry {
  const factory({
    required String to,
    @UtcDateTimeConverter() required DateTime at,
    String? from,
    String? actor,
    String? reason,
    @Default(false) bool rescheduled,
  }) = _BookingHistoryEntry;

  factory fromJson(Map<String, Object?> json) => _$BookingHistoryEntryFromJson(json);
}

@freezed
abstract class BookingBranch with _$BookingBranch {
  const factory({
    required String id,
    @LocalizedConverter() required LocalizedText name,
    @LocalizedConverter() required LocalizedText address,
    required String timezone,
    GeoPoint? location,
    String? phone,
  }) = _BookingBranch;

  factory fromJson(Map<String, Object?> json) => _$BookingBranchFromJson(json);
}

@freezed
abstract class BookingSalon with _$BookingSalon {
  const factory({required String id, required String slug, @LocalizedConverter() required LocalizedText name}) = _BookingSalon;

  factory fromJson(Map<String, Object?> json) => _$BookingSalonFromJson(json);
}

@freezed
abstract class BookingReviewSummary with _$BookingReviewSummary {
  const factory({required int rating, String? comment}) = _BookingReviewSummary;

  factory fromJson(Map<String, Object?> json) => _$BookingReviewSummaryFromJson(json);
}

@freezed
abstract class BookingPolicy with _$BookingPolicy {
  const factory({@Default(0) int cancellationWindowMinutes}) = _BookingPolicy;

  factory fromJson(Map<String, Object?> json) => _$BookingPolicyFromJson(json);
}

/// A booking as the customer sees it. [canChange] and [canReview] are decided by the server.
@freezed
abstract class CustomerBooking with _$CustomerBooking {
  const factory({
    required String id,
    @JsonKey(unknownEnumValue: BookingStatus.unknown) required BookingStatus status,
    @UtcDateTimeConverter() required DateTime startsAt,
    @UtcDateTimeConverter() required DateTime endsAt,
    required Money total,
    BookingBarber? barber,
    BookingBranch? branch,
    BookingSalon? salon,
    @Default([]) List<BookingItem> items,
    @Default(false) bool canChange,
    @Default(false) bool canReview,
    BookingReviewSummary? review,
    List<BookingHistoryEntry>? history,
    BookingPolicy? policy,
    String? customerNotes,
    String? cancelReason,
  }) = _CustomerBooking;

  factory fromJson(Map<String, Object?> json) => _$CustomerBookingFromJson(json);
}

/// A page of bookings with the cursor for the next one.
@freezed
abstract class BookingPage with _$BookingPage {
  const factory({required List<CustomerBooking> items, String? nextCursor}) = _BookingPage;
}

/// What the customer picked in the stepper. Ids only — prices come from the server quote.
@freezed
abstract class BookingSelection with _$BookingSelection {
  const factory({
    required String branch,
    @Default([]) List<String> services,
    @Default([]) List<String> addons,
    @Default([]) List<String> bundles,
    /// Barber public id, or null for "any available".
    String? barber,
  }) = _BookingSelection;
}

extension BookingSelectionX on BookingSelection {
  bool get isEmpty => services.isEmpty && bundles.isEmpty;

  /// Body / query for quote, slots and create.
  Map<String, Object?> toQuery() => {
    'branch': branch,
    'services': services,
    'addons': addons,
    'bundles': bundles,
    'barber': barber ?? 'any',
  };
}
