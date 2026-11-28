// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerAccount _$CustomerAccountFromJson(Map<String, dynamic> json) =>
    _CustomerAccount(
      id: json['id'] as String,
      phone: json['phone'] as String,
      locale: json['locale'] as String,
      profileComplete: json['profile_complete'] as bool,
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$CustomerAccountToJson(_CustomerAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'locale': instance.locale,
      'profile_complete': instance.profileComplete,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
    };

_OtpSent _$OtpSentFromJson(Map<String, dynamic> json) => _OtpSent(
  expiresIn: (json['expires_in'] as num).toInt(),
  retryAfter: (json['retry_after'] as num).toInt(),
);

Map<String, dynamic> _$OtpSentToJson(_OtpSent instance) => <String, dynamic>{
  'expires_in': instance.expiresIn,
  'retry_after': instance.retryAfter,
};
