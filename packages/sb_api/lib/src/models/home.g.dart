// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeSalon _$HomeSalonFromJson(Map<String, dynamic> json) => _HomeSalon(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: const LocalizedConverter().fromJson(json['name']),
  currency: json['currency'] as String,
  branchesCount: (json['branches_count'] as num?)?.toInt() ?? 0,
  logoUrl: json['logo_url'] as String?,
  coverUrl: json['cover_url'] as String?,
  bookingPolicy: json['booking_policy'] == null
      ? null
      : HomeBookingPolicy.fromJson(
          json['booking_policy'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$HomeSalonToJson(_HomeSalon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': const LocalizedConverter().toJson(instance.name),
      'currency': instance.currency,
      'branches_count': instance.branchesCount,
      'logo_url': instance.logoUrl,
      'cover_url': instance.coverUrl,
      'booking_policy': instance.bookingPolicy?.toJson(),
    };

_HomeBookingPolicy _$HomeBookingPolicyFromJson(Map<String, dynamic> json) =>
    _HomeBookingPolicy(
      leadTimeMinutes: (json['lead_time_minutes'] as num?)?.toInt() ?? 0,
      maxDaysAhead: (json['max_days_ahead'] as num?)?.toInt() ?? 30,
      cancellationWindowMinutes:
          (json['cancellation_window_minutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HomeBookingPolicyToJson(_HomeBookingPolicy instance) =>
    <String, dynamic>{
      'lead_time_minutes': instance.leadTimeMinutes,
      'max_days_ahead': instance.maxDaysAhead,
      'cancellation_window_minutes': instance.cancellationWindowMinutes,
    };

_BookAgain _$BookAgainFromJson(Map<String, dynamic> json) => _BookAgain(
  booking: json['booking'] as String,
  branch: json['branch'] as String,
  lastVisitAt: const UtcDateTimeConverter().fromJson(
    json['last_visit_at'] as String,
  ),
  barber: json['barber'] == null
      ? null
      : BookingBarber.fromJson(json['barber'] as Map<String, dynamic>),
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  addons:
      (json['addons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  bundles:
      (json['bundles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  names: json['names'] == null
      ? const []
      : const LocalizedListConverter().fromJson(json['names']),
);

Map<String, dynamic> _$BookAgainToJson(
  _BookAgain instance,
) => <String, dynamic>{
  'booking': instance.booking,
  'branch': instance.branch,
  'last_visit_at': const UtcDateTimeConverter().toJson(instance.lastVisitAt),
  'barber': instance.barber?.toJson(),
  'services': instance.services,
  'addons': instance.addons,
  'bundles': instance.bundles,
  'names': const LocalizedListConverter().toJson(instance.names),
};

_ReviewPrompt _$ReviewPromptFromJson(Map<String, dynamic> json) =>
    _ReviewPrompt(
      booking: json['booking'] as String,
      startsAt: const UtcDateTimeConverter().fromJson(
        json['starts_at'] as String,
      ),
      barber: const LocalizedOrNullConverter().fromJson(json['barber']),
    );

Map<String, dynamic> _$ReviewPromptToJson(_ReviewPrompt instance) =>
    <String, dynamic>{
      'booking': instance.booking,
      'starts_at': const UtcDateTimeConverter().toJson(instance.startsAt),
      'barber': const LocalizedOrNullConverter().toJson(instance.barber),
    };

_PopularService _$PopularServiceFromJson(Map<String, dynamic> json) =>
    _PopularService(
      id: json['id'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      price: json['price'] == null
          ? null
          : Money.fromJson(json['price'] as Map<String, dynamic>),
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$PopularServiceToJson(_PopularService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': const LocalizedConverter().toJson(instance.name),
      'duration_minutes': instance.durationMinutes,
      'price': instance.price?.toJson(),
      'image_url': instance.imageUrl,
    };

_HomeFeatures _$HomeFeaturesFromJson(Map<String, dynamic> json) =>
    _HomeFeatures(
      aiStudio: json['ai_studio'] as bool? ?? false,
      loyalty: json['loyalty'] as bool? ?? false,
    );

Map<String, dynamic> _$HomeFeaturesToJson(_HomeFeatures instance) =>
    <String, dynamic>{
      'ai_studio': instance.aiStudio,
      'loyalty': instance.loyalty,
    };

_CustomerHome _$CustomerHomeFromJson(Map<String, dynamic> json) =>
    _CustomerHome(
      salon: HomeSalon.fromJson(json['salon'] as Map<String, dynamic>),
      branch: json['branch'] as String?,
      nextAppointment: json['next_appointment'] == null
          ? null
          : CustomerBooking.fromJson(
              json['next_appointment'] as Map<String, dynamic>,
            ),
      bookAgain: json['book_again'] == null
          ? null
          : BookAgain.fromJson(json['book_again'] as Map<String, dynamic>),
      reviewPrompt: json['review_prompt'] == null
          ? null
          : ReviewPrompt.fromJson(
              json['review_prompt'] as Map<String, dynamic>,
            ),
      popularServices:
          (json['popular_services'] as List<dynamic>?)
              ?.map((e) => PopularService.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      features: json['features'] == null
          ? const HomeFeatures()
          : HomeFeatures.fromJson(json['features'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerHomeToJson(
  _CustomerHome instance,
) => <String, dynamic>{
  'salon': instance.salon.toJson(),
  'branch': instance.branch,
  'next_appointment': instance.nextAppointment?.toJson(),
  'book_again': instance.bookAgain?.toJson(),
  'review_prompt': instance.reviewPrompt?.toJson(),
  'popular_services': instance.popularServices.map((e) => e.toJson()).toList(),
  'features': instance.features.toJson(),
};

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  bookingUpdates: json['booking_updates'] as bool? ?? true,
  reminders: json['reminders'] as bool? ?? true,
  offers: json['offers'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'booking_updates': instance.bookingUpdates,
  'reminders': instance.reminders,
  'offers': instance.offers,
};
