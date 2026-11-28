// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceAddon _$ServiceAddonFromJson(Map<String, dynamic> json) =>
    _ServiceAddon(
      id: json['id'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
      price: Money.fromJson(json['price'] as Map<String, dynamic>),
      extraMinutes: (json['extra_minutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ServiceAddonToJson(_ServiceAddon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': const LocalizedConverter().toJson(instance.name),
      'price': instance.price.toJson(),
      'extra_minutes': instance.extraMinutes,
    };

_CatalogService _$CatalogServiceFromJson(Map<String, dynamic> json) =>
    _CatalogService(
      id: json['id'] as String,
      name: const LocalizedConverter().fromJson(json['name']),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      category: json['category'] as String?,
      description: const LocalizedOrNullConverter().fromJson(
        json['description'],
      ),
      imageUrl: json['image_url'] as String?,
      price: json['price'] == null
          ? null
          : Money.fromJson(json['price'] as Map<String, dynamic>),
      addons:
          (json['addons'] as List<dynamic>?)
              ?.map((e) => ServiceAddon.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CatalogServiceToJson(
  _CatalogService instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': const LocalizedConverter().toJson(instance.name),
  'duration_minutes': instance.durationMinutes,
  'category': instance.category,
  'description': const LocalizedOrNullConverter().toJson(instance.description),
  'image_url': instance.imageUrl,
  'price': instance.price?.toJson(),
  'addons': instance.addons.map((e) => e.toJson()).toList(),
};

_ServiceBundle _$ServiceBundleFromJson(
  Map<String, dynamic> json,
) => _ServiceBundle(
  id: json['id'] as String,
  name: const LocalizedConverter().fromJson(json['name']),
  price: Money.fromJson(json['price'] as Map<String, dynamic>),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  description: const LocalizedOrNullConverter().fromJson(json['description']),
);

Map<String, dynamic> _$ServiceBundleToJson(
  _ServiceBundle instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': const LocalizedConverter().toJson(instance.name),
  'price': instance.price.toJson(),
  'duration_minutes': instance.durationMinutes,
  'services': instance.services,
  'description': const LocalizedOrNullConverter().toJson(instance.description),
};

_ServiceMenu _$ServiceMenuFromJson(Map<String, dynamic> json) => _ServiceMenu(
  services:
      (json['services'] as List<dynamic>?)
          ?.map((e) => CatalogService.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bundles:
      (json['bundles'] as List<dynamic>?)
          ?.map((e) => ServiceBundle.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ServiceMenuToJson(_ServiceMenu instance) =>
    <String, dynamic>{
      'services': instance.services.map((e) => e.toJson()).toList(),
      'bundles': instance.bundles.map((e) => e.toJson()).toList(),
    };

_BarberRating _$BarberRatingFromJson(Map<String, dynamic> json) =>
    _BarberRating(
      average: (json['average'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$BarberRatingToJson(_BarberRating instance) =>
    <String, dynamic>{'average': instance.average, 'count': instance.count};

_BarberProfile _$BarberProfileFromJson(Map<String, dynamic> json) =>
    _BarberProfile(
      id: json['id'] as String,
      displayName: const LocalizedConverter().fromJson(json['display_name']),
      bio: const LocalizedOrNullConverter().fromJson(json['bio']),
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      yearsExperience: (json['years_experience'] as num?)?.toInt(),
      photoUrl: json['photo_url'] as String?,
      rating: json['rating'] == null
          ? null
          : BarberRating.fromJson(json['rating'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BarberProfileToJson(_BarberProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': const LocalizedConverter().toJson(instance.displayName),
      'bio': const LocalizedOrNullConverter().toJson(instance.bio),
      'specialties': instance.specialties,
      'years_experience': instance.yearsExperience,
      'photo_url': instance.photoUrl,
      'rating': instance.rating?.toJson(),
    };

_Slot _$SlotFromJson(Map<String, dynamic> json) => _Slot(
  startsAt: const UtcDateTimeConverter().fromJson(json['starts_at'] as String),
  time: json['time'] as String,
  barbers:
      (json['barbers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$SlotToJson(_Slot instance) => <String, dynamic>{
  'starts_at': const UtcDateTimeConverter().toJson(instance.startsAt),
  'time': instance.time,
  'barbers': instance.barbers,
};

_SlotDay _$SlotDayFromJson(Map<String, dynamic> json) => _SlotDay(
  date: json['date'] as String,
  timezone: json['timezone'] as String,
  slots:
      (json['slots'] as List<dynamic>?)
          ?.map((e) => Slot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SlotDayToJson(_SlotDay instance) => <String, dynamic>{
  'date': instance.date,
  'timezone': instance.timezone,
  'slots': instance.slots.map((e) => e.toJson()).toList(),
};

_QuoteLine _$QuoteLineFromJson(Map<String, dynamic> json) => _QuoteLine(
  type: json['type'] as String,
  name: const LocalizedConverter().fromJson(json['name']),
  total: Money.fromJson(json['total'] as Map<String, dynamic>),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$QuoteLineToJson(_QuoteLine instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': const LocalizedConverter().toJson(instance.name),
      'total': instance.total.toJson(),
      'duration_minutes': instance.durationMinutes,
    };

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  currency: json['currency'] as String,
  subtotal: Money.fromJson(json['subtotal'] as Map<String, dynamic>),
  discount: Money.fromJson(json['discount'] as Map<String, dynamic>),
  tax: Money.fromJson(json['tax'] as Map<String, dynamic>),
  total: Money.fromJson(json['total'] as Map<String, dynamic>),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  pricesIncludeTax: json['prices_include_tax'] as bool? ?? false,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => QuoteLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'currency': instance.currency,
  'subtotal': instance.subtotal.toJson(),
  'discount': instance.discount.toJson(),
  'tax': instance.tax.toJson(),
  'total': instance.total.toJson(),
  'duration_minutes': instance.durationMinutes,
  'prices_include_tax': instance.pricesIncludeTax,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
};
