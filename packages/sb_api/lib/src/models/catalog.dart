import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sb_api/src/models/converters.dart';
import 'package:sb_api/src/models/localized.dart';
import 'package:sb_api/src/models/money.dart';

part 'catalog.freezed.dart';
part 'catalog.g.dart';

@freezed
abstract class ServiceAddon with _$ServiceAddon {
  const factory({required String id, @LocalizedConverter() required LocalizedText name, required Money price, @Default(0) int extraMinutes}) =
      _ServiceAddon;

  factory fromJson(Map<String, Object?> json) => _$ServiceAddonFromJson(json);
}

/// A bookable service at a branch, with the branch price (computed by the server).
@freezed
abstract class CatalogService with _$CatalogService {
  const factory({
    required String id,
    @LocalizedConverter() required LocalizedText name,
    required int durationMinutes,
    String? category,
    @LocalizedOrNullConverter() LocalizedText? description,
    String? imageUrl,
    Money? price,
    @Default([]) List<ServiceAddon> addons,
  }) = _CatalogService;

  factory fromJson(Map<String, Object?> json) => _$CatalogServiceFromJson(json);
}

@freezed
abstract class ServiceBundle with _$ServiceBundle {
  const factory({
    required String id,
    @LocalizedConverter() required LocalizedText name,
    required Money price,
    required int durationMinutes,
    @Default([]) List<String> services,
    @LocalizedOrNullConverter() LocalizedText? description,
  }) = _ServiceBundle;

  factory fromJson(Map<String, Object?> json) => _$ServiceBundleFromJson(json);
}

@freezed
abstract class ServiceMenu with _$ServiceMenu {
  const factory({@Default([]) List<CatalogService> services, @Default([]) List<ServiceBundle> bundles}) = _ServiceMenu;

  factory fromJson(Map<String, Object?> json) => _$ServiceMenuFromJson(json);
}

@freezed
abstract class BarberRating with _$BarberRating {
  const factory({required double average, required int count}) = _BarberRating;

  factory fromJson(Map<String, Object?> json) => _$BarberRatingFromJson(json);
}

@freezed
abstract class BarberProfile with _$BarberProfile {
  const factory({
    required String id,
    @LocalizedConverter() required LocalizedText displayName,
    @LocalizedOrNullConverter() LocalizedText? bio,
    @Default([]) List<String> specialties,
    int? yearsExperience,
    String? photoUrl,
    BarberRating? rating,
  }) = _BarberProfile;

  factory fromJson(Map<String, Object?> json) => _$BarberProfileFromJson(json);
}

/// A free start time; [barbers] are the public ids free at that time.
@freezed
abstract class Slot with _$Slot {
  const factory({@UtcDateTimeConverter() required DateTime startsAt, required String time, @Default([]) List<String> barbers}) = _Slot;

  factory fromJson(Map<String, Object?> json) => _$SlotFromJson(json);
}

@freezed
abstract class SlotDay with _$SlotDay {
  const factory({required String date, required String timezone, @Default([]) List<Slot> slots}) = _SlotDay;

  factory fromJson(Map<String, Object?> json) => _$SlotDayFromJson(json);
}

@freezed
abstract class QuoteLine with _$QuoteLine {
  const factory({
    required String type,
    @LocalizedConverter() required LocalizedText name,
    required Money total,
    @Default(0) int durationMinutes,
  }) = _QuoteLine;

  factory fromJson(Map<String, Object?> json) => _$QuoteLineFromJson(json);
}

/// The server's price for a selection. The summary step shows exactly this (rule 1).
@freezed
abstract class Quote with _$Quote {
  const factory({
    required String currency,
    required Money subtotal,
    required Money discount,
    required Money tax,
    required Money total,
    required int durationMinutes,
    @Default(false) bool pricesIncludeTax,
    @Default([]) List<QuoteLine> lines,
  }) = _Quote;

  factory fromJson(Map<String, Object?> json) => _$QuoteFromJson(json);
}
