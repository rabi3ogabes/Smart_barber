import 'package:json_annotation/json_annotation.dart';
import 'package:sb_api/src/models/localized.dart';

/// Translatable server text. Laravel sends `[]` for an empty translation set, so lists map to `{}`.
class LocalizedConverter implements JsonConverter<LocalizedText, Object?> {
  const new();

  @override
  LocalizedText fromJson(Object? json) => parseLocalized(json);

  @override
  Object? toJson(LocalizedText object) => object;
}

/// Nullable variant of [LocalizedConverter].
class LocalizedOrNullConverter implements JsonConverter<LocalizedText?, Object?> {
  const new();

  @override
  LocalizedText? fromJson(Object? json) => json == null ? null : parseLocalized(json);

  @override
  Object? toJson(LocalizedText? object) => object;
}

/// UTC ISO-8601 instants from the API (rule 5); display code converts to the branch timezone.
class UtcDateTimeConverter implements JsonConverter<DateTime, String> {
  const new();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toUtc();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

/// Nullable variant of [UtcDateTimeConverter].
class UtcDateTimeOrNullConverter implements JsonConverter<DateTime?, String?> {
  const new();

  @override
  DateTime? fromJson(String? json) => json == null ? null : DateTime.parse(json).toUtc();

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
