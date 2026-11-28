// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalonCard _$SalonCardFromJson(Map<String, dynamic> json) => _SalonCard(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: const LocalizedConverter().fromJson(json['name']),
  currency: json['currency'] as String,
  branchesCount: (json['branches_count'] as num?)?.toInt() ?? 0,
  logoUrl: json['logo_url'] as String?,
  address: const LocalizedOrNullConverter().fromJson(json['address']),
  lastVisitAt: const UtcDateTimeOrNullConverter().fromJson(
    json['last_visit_at'] as String?,
  ),
);

Map<String, dynamic> _$SalonCardToJson(_SalonCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': const LocalizedConverter().toJson(instance.name),
      'currency': instance.currency,
      'branches_count': instance.branchesCount,
      'logo_url': instance.logoUrl,
      'address': const LocalizedOrNullConverter().toJson(instance.address),
      'last_visit_at': const UtcDateTimeOrNullConverter().toJson(
        instance.lastVisitAt,
      ),
    };

_GeoPoint _$GeoPointFromJson(Map<String, dynamic> json) => _GeoPoint(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$GeoPointToJson(_GeoPoint instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
};

_TimeRange _$TimeRangeFromJson(Map<String, dynamic> json) =>
    _TimeRange(start: json['start'] as String, end: json['end'] as String);

Map<String, dynamic> _$TimeRangeToJson(_TimeRange instance) =>
    <String, dynamic>{'start': instance.start, 'end': instance.end};

_BranchClosure _$BranchClosureFromJson(Map<String, dynamic> json) =>
    _BranchClosure(
      startsOn: json['starts_on'] as String,
      endsOn: json['ends_on'] as String,
      reason: const LocalizedOrNullConverter().fromJson(json['reason']),
    );

Map<String, dynamic> _$BranchClosureToJson(_BranchClosure instance) =>
    <String, dynamic>{
      'starts_on': instance.startsOn,
      'ends_on': instance.endsOn,
      'reason': const LocalizedOrNullConverter().toJson(instance.reason),
    };

_SalonBranch _$SalonBranchFromJson(Map<String, dynamic> json) => _SalonBranch(
  id: json['id'] as String,
  name: const LocalizedConverter().fromJson(json['name']),
  address: const LocalizedConverter().fromJson(json['address']),
  timezone: json['timezone'] as String,
  location: json['location'] == null
      ? null
      : GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
  phone: json['phone'] as String?,
  today:
      (json['today'] as List<dynamic>?)
          ?.map((e) => TimeRange.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  week: const WeekConverter().fromJson(json['week']),
  closures:
      (json['closures'] as List<dynamic>?)
          ?.map((e) => BranchClosure.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SalonBranchToJson(_SalonBranch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': const LocalizedConverter().toJson(instance.name),
      'address': const LocalizedConverter().toJson(instance.address),
      'timezone': instance.timezone,
      'location': instance.location?.toJson(),
      'phone': instance.phone,
      'today': instance.today.map((e) => e.toJson()).toList(),
      'week': const WeekConverter().toJson(instance.week),
      'closures': instance.closures.map((e) => e.toJson()).toList(),
    };

_SalonProfile _$SalonProfileFromJson(Map<String, dynamic> json) =>
    _SalonProfile(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
      currency: json['currency'] as String,
      logoUrl: json['logo_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SalonProfileToJson(_SalonProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': const LocalizedConverter().toJson(instance.name),
      'currency': instance.currency,
      'logo_url': instance.logoUrl,
      'cover_url': instance.coverUrl,
      'features': instance.features,
    };
