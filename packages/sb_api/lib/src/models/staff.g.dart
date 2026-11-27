// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffUser _$StaffUserFromJson(Map<String, dynamic> json) => _StaffUser(
  id: json['id'] as String,
  name: json['name'] as String,
  locale: json['locale'] as String,
  twoFactorEnabled: json['two_factor_enabled'] as bool,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$StaffUserToJson(_StaffUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locale': instance.locale,
      'two_factor_enabled': instance.twoFactorEnabled,
      'email': instance.email,
      'phone': instance.phone,
    };

_SalonSummary _$SalonSummaryFromJson(Map<String, dynamic> json) =>
    _SalonSummary(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: _localized(json['name']),
      currency: json['currency'] as String,
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$SalonSummaryToJson(_SalonSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'currency': instance.currency,
      'timezone': instance.timezone,
    };

_BranchSummary _$BranchSummaryFromJson(Map<String, dynamic> json) =>
    _BranchSummary(id: json['id'] as String, name: _localized(json['name']));

Map<String, dynamic> _$BranchSummaryToJson(_BranchSummary instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_StaffMe _$StaffMeFromJson(Map<String, dynamic> json) => _StaffMe(
  user: StaffUser.fromJson(json['user'] as Map<String, dynamic>),
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  branches: (json['branches'] as List<dynamic>)
      .map((e) => BranchSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  salon: json['salon'] == null
      ? null
      : SalonSummary.fromJson(json['salon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StaffMeToJson(_StaffMe instance) => <String, dynamic>{
  'user': instance.user.toJson(),
  'roles': instance.roles,
  'permissions': instance.permissions,
  'branches': instance.branches.map((e) => e.toJson()).toList(),
  'features': instance.features,
  'salon': instance.salon?.toJson(),
};

_MembershipOption _$MembershipOptionFromJson(Map<String, dynamic> json) =>
    _MembershipOption(
      salon: json['salon'] as String,
      slug: json['slug'] as String,
      name: _localized(json['name']),
    );

Map<String, dynamic> _$MembershipOptionToJson(_MembershipOption instance) =>
    <String, dynamic>{
      'salon': instance.salon,
      'slug': instance.slug,
      'name': instance.name,
    };
