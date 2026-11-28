import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sb_api/src/models/booking.dart';
import 'package:sb_api/src/models/converters.dart';
import 'package:sb_api/src/models/localized.dart';
import 'package:sb_api/src/models/money.dart';

part 'home.freezed.dart';
part 'home.g.dart';

@freezed
abstract class HomeSalon with _$HomeSalon {
  const factory({
    required String id,
    required String slug,
    @LocalizedConverter() required LocalizedText name,
    required String currency,
    @Default(0) int branchesCount,
    String? logoUrl,
    String? coverUrl,
    HomeBookingPolicy? bookingPolicy,
  }) = _HomeSalon;

  factory fromJson(Map<String, Object?> json) => _$HomeSalonFromJson(json);
}

@freezed
abstract class HomeBookingPolicy with _$HomeBookingPolicy {
  const factory({@Default(0) int leadTimeMinutes, @Default(30) int maxDaysAhead, @Default(0) int cancellationWindowMinutes}) =
      _HomeBookingPolicy;

  factory fromJson(Map<String, Object?> json) => _$HomeBookingPolicyFromJson(json);
}

/// "Book again": the last completed visit as a ready selection.
@freezed
abstract class BookAgain with _$BookAgain {
  const factory({
    required String booking,
    required String branch,
    @UtcDateTimeConverter() required DateTime lastVisitAt,
    BookingBarber? barber,
    @Default([]) List<String> services,
    @Default([]) List<String> addons,
    @Default([]) List<String> bundles,
    @Default([]) @LocalizedListConverter() List<LocalizedText> names,
  }) = _BookAgain;

  factory fromJson(Map<String, Object?> json) => _$BookAgainFromJson(json);
}

class LocalizedListConverter implements JsonConverter<List<LocalizedText>, Object?> {
  const new();

  @override
  List<LocalizedText> fromJson(Object? json) => json is List ? json.map(parseLocalized).toList() : const [];

  @override
  Object? toJson(List<LocalizedText> object) => object;
}

@freezed
abstract class ReviewPrompt with _$ReviewPrompt {
  const factory({
    required String booking,
    @UtcDateTimeConverter() required DateTime startsAt,
    @LocalizedOrNullConverter() LocalizedText? barber,
  }) = _ReviewPrompt;

  factory fromJson(Map<String, Object?> json) => _$ReviewPromptFromJson(json);
}

@freezed
abstract class PopularService with _$PopularService {
  const factory({
    required String id,
    @LocalizedConverter() required LocalizedText name,
    required int durationMinutes,
    Money? price,
    String? imageUrl,
  }) = _PopularService;

  factory fromJson(Map<String, Object?> json) => _$PopularServiceFromJson(json);
}

@freezed
abstract class HomeFeatures with _$HomeFeatures {
  const factory({@Default(false) bool aiStudio, @Default(false) bool loyalty}) = _HomeFeatures;

  factory fromJson(Map<String, Object?> json) => _$HomeFeaturesFromJson(json);
}

/// Everything the home screen shows, computed by the server.
@freezed
abstract class CustomerHome with _$CustomerHome {
  const factory({
    required HomeSalon salon,
    String? branch,
    CustomerBooking? nextAppointment,
    BookAgain? bookAgain,
    ReviewPrompt? reviewPrompt,
    @Default([]) List<PopularService> popularServices,
    @Default(HomeFeatures()) HomeFeatures features,
  }) = _CustomerHome;

  factory fromJson(Map<String, Object?> json) => _$CustomerHomeFromJson(json);
}

@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory({@Default(true) bool bookingUpdates, @Default(true) bool reminders, @Default(false) bool offers}) =
      _NotificationPreferences;

  factory fromJson(Map<String, Object?> json) => _$NotificationPreferencesFromJson(json);
}
