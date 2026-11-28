// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingBarber _$BookingBarberFromJson(Map<String, dynamic> json) =>
    _BookingBarber(
      id: json['id'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
    );

Map<String, dynamic> _$BookingBarberToJson(_BookingBarber instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': const LocalizedConverter().toJson(instance.name),
    };

_BookingItem _$BookingItemFromJson(Map<String, dynamic> json) => _BookingItem(
  type: json['type'] as String,
  name: const LocalizedConverter().fromJson(json['name']),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  total: Money.fromJson(json['total'] as Map<String, dynamic>),
  service: json['service'] as String?,
);

Map<String, dynamic> _$BookingItemToJson(_BookingItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': const LocalizedConverter().toJson(instance.name),
      'duration_minutes': instance.durationMinutes,
      'total': instance.total.toJson(),
      'service': instance.service,
    };

_BookingHistoryEntry _$BookingHistoryEntryFromJson(Map<String, dynamic> json) =>
    _BookingHistoryEntry(
      to: json['to'] as String,
      at: const UtcDateTimeConverter().fromJson(json['at'] as String),
      from: json['from'] as String?,
      actor: json['actor'] as String?,
      reason: json['reason'] as String?,
      rescheduled: json['rescheduled'] as bool? ?? false,
    );

Map<String, dynamic> _$BookingHistoryEntryToJson(
  _BookingHistoryEntry instance,
) => <String, dynamic>{
  'to': instance.to,
  'at': const UtcDateTimeConverter().toJson(instance.at),
  'from': instance.from,
  'actor': instance.actor,
  'reason': instance.reason,
  'rescheduled': instance.rescheduled,
};

_BookingBranch _$BookingBranchFromJson(Map<String, dynamic> json) =>
    _BookingBranch(
      id: json['id'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
      address: const LocalizedConverter().fromJson(json['address']),
      timezone: json['timezone'] as String,
      location: json['location'] == null
          ? null
          : GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$BookingBranchToJson(_BookingBranch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': const LocalizedConverter().toJson(instance.name),
      'address': const LocalizedConverter().toJson(instance.address),
      'timezone': instance.timezone,
      'location': instance.location?.toJson(),
      'phone': instance.phone,
    };

_BookingSalon _$BookingSalonFromJson(Map<String, dynamic> json) =>
    _BookingSalon(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
    );

Map<String, dynamic> _$BookingSalonToJson(_BookingSalon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': const LocalizedConverter().toJson(instance.name),
    };

_BookingReviewSummary _$BookingReviewSummaryFromJson(
  Map<String, dynamic> json,
) => _BookingReviewSummary(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$BookingReviewSummaryToJson(
  _BookingReviewSummary instance,
) => <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};

_BookingPolicy _$BookingPolicyFromJson(Map<String, dynamic> json) =>
    _BookingPolicy(
      cancellationWindowMinutes:
          (json['cancellation_window_minutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BookingPolicyToJson(_BookingPolicy instance) =>
    <String, dynamic>{
      'cancellation_window_minutes': instance.cancellationWindowMinutes,
    };

_CustomerBooking _$CustomerBookingFromJson(
  Map<String, dynamic> json,
) => _CustomerBooking(
  id: json['id'] as String,
  status: $enumDecode(
    _$BookingStatusEnumMap,
    json['status'],
    unknownValue: BookingStatus.unknown,
  ),
  startsAt: const UtcDateTimeConverter().fromJson(json['starts_at'] as String),
  endsAt: const UtcDateTimeConverter().fromJson(json['ends_at'] as String),
  total: Money.fromJson(json['total'] as Map<String, dynamic>),
  barber: json['barber'] == null
      ? null
      : BookingBarber.fromJson(json['barber'] as Map<String, dynamic>),
  branch: json['branch'] == null
      ? null
      : BookingBranch.fromJson(json['branch'] as Map<String, dynamic>),
  salon: json['salon'] == null
      ? null
      : BookingSalon.fromJson(json['salon'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => BookingItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  canChange: json['can_change'] as bool? ?? false,
  canReview: json['can_review'] as bool? ?? false,
  review: json['review'] == null
      ? null
      : BookingReviewSummary.fromJson(json['review'] as Map<String, dynamic>),
  history: (json['history'] as List<dynamic>?)
      ?.map((e) => BookingHistoryEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  policy: json['policy'] == null
      ? null
      : BookingPolicy.fromJson(json['policy'] as Map<String, dynamic>),
  customerNotes: json['customer_notes'] as String?,
  cancelReason: json['cancel_reason'] as String?,
);

Map<String, dynamic> _$CustomerBookingToJson(_CustomerBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'starts_at': const UtcDateTimeConverter().toJson(instance.startsAt),
      'ends_at': const UtcDateTimeConverter().toJson(instance.endsAt),
      'total': instance.total.toJson(),
      'barber': instance.barber?.toJson(),
      'branch': instance.branch?.toJson(),
      'salon': instance.salon?.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'can_change': instance.canChange,
      'can_review': instance.canReview,
      'review': instance.review?.toJson(),
      'history': instance.history?.map((e) => e.toJson()).toList(),
      'policy': instance.policy?.toJson(),
      'customer_notes': instance.customerNotes,
      'cancel_reason': instance.cancelReason,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.arrived: 'arrived',
  BookingStatus.inService: 'in_service',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.noShow: 'no_show',
  BookingStatus.unknown: 'unknown',
};
