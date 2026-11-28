import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbarber_customer/app/app.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/app/router.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/push/push_registration.dart';
import 'package:smartbarber_customer/features/push/push_service.dart';

import 'fake_api.dart';
import 'helpers.dart';

/// Server-shaped JSON, as the Laravel API returns it (snake_case, Money objects, translations).
Map<String, Object?> money(int amount) => {'amount': amount, 'currency': 'QAR', 'formatted': 'QAR ${(amount / 100).toStringAsFixed(2)}'};

const salonId = '01SALON0000000000000000000';
const branchId = '01BRANCH000000000000000000';
const haircutId = '01HAIRCUT00000000000000000';
const beardId = '01BEARD0000000000000000000';
const fadeAddonId = '01ADDON0000000000000000000';
const barberAId = '01BARBERA00000000000000000';
const bookingId = '01BOOKING00000000000000000';

final salonCard = <String, Object?>{
  'id': salonId,
  'slug': 'elite',
  'name': {'ar': 'صالون النخبة', 'en': 'Elite Barbers'},
  'logo_url': null,
  'currency': 'QAR',
  'branches_count': 1,
  'address': {'ar': 'الخليج الغربي', 'en': 'West Bay'},
};

final branchJson = <String, Object?>{
  'id': branchId,
  'name': {'ar': 'الخليج الغربي', 'en': 'West Bay'},
  'address': {'ar': 'برج ١، الدوحة', 'en': 'Tower 1, Doha'},
  'location': {'lat': 25.32, 'lng': 51.53},
  'phone': '+97444000000',
  'timezone': 'Asia/Qatar',
  'today': [
    {'start': '10:00', 'end': '22:00'},
  ],
};

final menuJson = <String, Object?>{
  'services': [
    {
      'id': haircutId,
      'category': null,
      'name': {'ar': 'قص الشعر', 'en': 'Haircut'},
      'description': <Object?>[],
      'image_url': null,
      'price': money(6000),
      'duration_minutes': 30,
      'addons': [
        {'id': fadeAddonId, 'name': {'ar': 'تدريج', 'en': 'Skin fade'}, 'price': money(1500), 'extra_minutes': 10},
      ],
    },
    {
      'id': beardId,
      'category': null,
      'name': {'ar': 'اللحية', 'en': 'Beard trim'},
      'description': <Object?>[],
      'image_url': null,
      'price': money(4000),
      'duration_minutes': 20,
      'addons': <Object?>[],
    },
  ],
  'bundles': <Object?>[],
};

final List<Map<String, Object?>> barbersJson = [
  {
    'id': barberAId,
    'display_name': {'ar': 'يوسف', 'en': 'Yousef'},
    'bio': <Object?>[],
    'specialties': ['fade', 'beard'],
    'years_experience': 8,
    'photo_url': null,
    'rating': {'average': 4.8, 'count': 52},
  },
];

/// Free times on 27 Nov 2026 (Qatar = UTC+3).
Map<String, Object?> slotsJson({List<String> times = const ['14:00', '14:30', '15:00']}) => {
  'date': '2026-11-27',
  'timezone': 'Asia/Qatar',
  'slots': [
    for (final t in times)
      {'starts_at': '2026-11-27T${(int.parse(t.split(':')[0]) - 3).toString().padLeft(2, '0')}:${t.split(':')[1]}:00Z', 'time': t, 'barbers': [barberAId]},
  ],
};

final quoteJson = <String, Object?>{
  'currency': 'QAR',
  'prices_include_tax': true,
  'lines': [
    {'type': 'service', 'id': haircutId, 'name': {'ar': 'قص الشعر', 'en': 'Haircut'}, 'total': money(6000), 'duration_minutes': 30},
  ],
  'subtotal': money(6000),
  'discount': money(0),
  'tax': money(0),
  'total': money(6000),
  'duration_minutes': 30,
  'buffer_minutes': 5,
};

Map<String, Object?> bookingJson({String status = 'confirmed', bool canChange = true, bool canReview = false, String startsAt = '2026-11-28T08:00:00Z', Map<String, Object?>? review}) => {
  'id': bookingId,
  'status': status,
  'source': 'app',
  'starts_at': startsAt,
  'ends_at': startsAt.replaceFirst(':00:00Z', ':30:00Z'),
  'blocked_until': startsAt.replaceFirst(':00:00Z', ':35:00Z'),
  'barber': {'id': barberAId, 'name': {'ar': 'يوسف', 'en': 'Yousef'}},
  'items': [
    {'type': 'service', 'service': haircutId, 'name': {'ar': 'قص الشعر', 'en': 'Haircut'}, 'duration_minutes': 30, 'total': money(6000)},
  ],
  'subtotal': money(6000),
  'discount': money(0),
  'tax': money(0),
  'total': money(6000),
  'customer_notes': null,
  'cancel_reason': null,
  'reschedule_count': 0,
  'branch_name': {'ar': 'الخليج الغربي', 'en': 'West Bay'},
  'branch': {
    'id': branchId,
    'name': {'ar': 'الخليج الغربي', 'en': 'West Bay'},
    'address': {'ar': 'برج ١، الدوحة', 'en': 'Tower 1, Doha'},
    'location': {'lat': 25.32, 'lng': 51.53},
    'phone': '+97444000000',
    'timezone': 'Asia/Qatar',
  },
  'salon': {'id': salonId, 'slug': 'elite', 'name': {'ar': 'صالون النخبة', 'en': 'Elite Barbers'}},
  'can_change': canChange,
  'review': review,
  'can_review': canReview,
  'history': [
    {'from': null, 'to': status == 'cancelled' ? 'confirmed' : status, 'at': '2026-11-26T09:00:00Z', 'actor': 'customer_account', 'reason': null, 'rescheduled': false, 'meta': {'source': 'app'}},
  ],
  'policy': {'cancellation_window_minutes': 120},
};

Map<String, Object?> homeJson({Map<String, Object?>? next, bool bookAgain = true, bool aiStudio = false, bool reviewPrompt = false}) => {
  'salon': {
    ...salonCard,
    'cover_url': null,
    'booking_policy': {'lead_time_minutes': 30, 'max_days_ahead': 14, 'cancellation_window_minutes': 120},
  },
  'branch': branchId,
  'next_appointment': next,
  'book_again': bookAgain
      ? {
          'booking': '01PAST00000000000000000000',
          'branch': branchId,
          'barber': {'id': barberAId, 'name': {'ar': 'يوسف', 'en': 'Yousef'}},
          'services': [haircutId],
          'addons': <Object?>[],
          'bundles': <Object?>[],
          'names': [
            {'ar': 'قص الشعر', 'en': 'Haircut'},
          ],
          'last_visit_at': '2026-11-01T10:00:00Z',
        }
      : null,
  'review_prompt': reviewPrompt ? {'booking': '01PAST00000000000000000000', 'starts_at': '2026-11-20T10:00:00Z', 'barber': {'ar': 'يوسف', 'en': 'Yousef'}} : null,
  'popular_services': [
    {'id': haircutId, 'name': {'ar': 'قص الشعر', 'en': 'Haircut'}, 'duration_minutes': 30, 'price': money(6000), 'image_url': null},
    {'id': beardId, 'name': {'ar': 'اللحية', 'en': 'Beard trim'}, 'duration_minutes': 20, 'price': money(4000), 'image_url': null},
  ],
  'features': {'ai_studio': aiStudio, 'loyalty': false},
};

/// A fake API with the salon, branch, menu, barbers, slots, quote and home already answered.
FakeApi salonApi() => FakeApi()
  ..json('GET /customer/home', homeJson())
  ..json('GET /salons/elite/branches', [branchJson])
  ..json('GET /branches/$branchId/services', menuJson)
  ..json('GET /branches/$branchId/barbers', barbersJson)
  ..json('GET /branches/$branchId/slots', slotsJson())
  ..json('POST /customer/quotes', quoteJson)
  ..json('GET /customer/salons', [salonCard])
  ..json('GET /customer/bookings', <Object?>[], meta: {'next_cursor': null});

/// The whole app (real router, guards and screens), signed in, with [api] behind every repository.
Future<Widget> appWith(FakeApi api, {Locale locale = const Locale('ar'), bool salonChosen = true, List<Override> extra = const []}) async {
  SharedPreferences.setMockInitialValues({'sb.locale': locale.languageCode, if (salonChosen) 'sb.salon': jsonEncode(salonCard)});
  final prefs = await AppPreferences.load();
  return ProviderScope(
    retry: noProviderRetry,
    overrides: [
      preferencesProvider.overrideWithValue(prefs),
      envProvider.overrideWithValue(const AppEnv(flavor: Flavor.dev, apiBaseUrl: 'http://api.test/api/v1')),
      tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
      onlineProvider.overrideWithValue(const AsyncData(true)),
      clockProvider.overrideWithValue(() => DateTime.utc(2026, 11, 27, 10)),
      apiDioProvider.overrideWithValue(api.dio()),
      customerSessionProvider.overrideWith(SignedInSession.new),
      pushServiceProvider.overrideWithValue(const DisabledPushService()),
      ...extra,
    ],
    child: const CustomerApp(),
  );
}

/// The router of the app under test.
GoRouter routerOf(WidgetTester tester) => ProviderScope.containerOf(tester.element(find.byType(MaterialApp))).read(routerProvider);
