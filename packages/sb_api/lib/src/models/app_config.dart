import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
abstract class AppConfig with _$AppConfig {
  const factory({
    required Map<String, String> minVersions,
    required bool maintenance,
    required List<String> locales,
    required String defaultLocale,
  }) = _AppConfig;

  factory fromJson(Map<String, Object?> json) => _$AppConfigFromJson(json);
}
