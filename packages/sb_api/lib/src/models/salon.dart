import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sb_api/src/models/converters.dart';
import 'package:sb_api/src/models/localized.dart';

part 'salon.freezed.dart';
part 'salon.g.dart';

/// The compact salon card (search, QR resolve, "my salons").
@freezed
abstract class SalonCard with _$SalonCard {
  const factory({
    required String id,
    required String slug,
    @LocalizedConverter() required LocalizedText name,
    required String currency,
    @Default(0) int branchesCount,
    String? logoUrl,
    @LocalizedOrNullConverter() LocalizedText? address,
    @UtcDateTimeOrNullConverter() DateTime? lastVisitAt,
  }) = _SalonCard;

  factory fromJson(Map<String, Object?> json) => _$SalonCardFromJson(json);
}

@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory({required double lat, required double lng}) = _GeoPoint;

  factory fromJson(Map<String, Object?> json) => _$GeoPointFromJson(json);
}

/// One opening range in branch-local wall time ("10:00"–"22:00").
@freezed
abstract class TimeRange with _$TimeRange {
  const factory({required String start, required String end}) = _TimeRange;

  factory fromJson(Map<String, Object?> json) => _$TimeRangeFromJson(json);
}

@freezed
abstract class BranchClosure with _$BranchClosure {
  const factory({required String startsOn, required String endsOn, @LocalizedOrNullConverter() LocalizedText? reason}) = _BranchClosure;

  factory fromJson(Map<String, Object?> json) => _$BranchClosureFromJson(json);
}

/// A branch with today's hours; [week] (0 = Sunday … 6 = Saturday) and [closures] on the detail call.
@freezed
abstract class SalonBranch with _$SalonBranch {
  const factory({
    required String id,
    @LocalizedConverter() required LocalizedText name,
    @LocalizedConverter() required LocalizedText address,
    required String timezone,
    GeoPoint? location,
    String? phone,
    @Default([]) List<TimeRange> today,
    @WeekConverter() List<List<TimeRange>>? week,
    @Default([]) List<BranchClosure> closures,
  }) = _SalonBranch;

  factory fromJson(Map<String, Object?> json) => _$SalonBranchFromJson(json);
}

/// The weekly schedule arrives as a list of 7 day lists, or a map keyed "0"…"6".
class WeekConverter implements JsonConverter<List<List<TimeRange>>?, Object?> {
  const new();

  @override
  List<List<TimeRange>>? fromJson(Object? json) {
    List<TimeRange> day(Object? d) =>
        d is List ? d.whereType<Map<dynamic, dynamic>>().map((m) => TimeRange.fromJson(m.cast<String, Object?>())).toList() : const [];
    return switch (json) {
      final List<dynamic> l => [for (var i = 0; i < 7; i++) if (i < l.length) day(l[i]) else const <TimeRange>[]],
      final Map<dynamic, dynamic> m => [for (var i = 0; i < 7; i++) day(m['$i'])],
      _ => null,
    };
  }

  @override
  Object? toJson(List<List<TimeRange>>? object) => object?.map((d) => d.map((r) => r.toJson()).toList()).toList();
}

/// Full salon profile (public).
@freezed
abstract class SalonProfile with _$SalonProfile {
  const factory({
    required String id,
    required String slug,
    @LocalizedConverter() required LocalizedText name,
    required String currency,
    String? logoUrl,
    String? coverUrl,
    @Default([]) List<String> features,
  }) = _SalonProfile;

  factory fromJson(Map<String, Object?> json) => _$SalonProfileFromJson(json);
}
