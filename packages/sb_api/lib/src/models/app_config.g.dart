// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
  minVersions: Map<String, String>.from(json['min_versions'] as Map),
  maintenance: json['maintenance'] as bool,
  locales: (json['locales'] as List<dynamic>).map((e) => e as String).toList(),
  defaultLocale: json['default_locale'] as String,
);

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'min_versions': instance.minVersions,
      'maintenance': instance.maintenance,
      'locales': instance.locales,
      'default_locale': instance.defaultLocale,
    };
