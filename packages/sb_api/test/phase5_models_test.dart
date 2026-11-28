import 'package:flutter_test/flutter_test.dart';
import 'package:sb_api/sb_api.dart';

void main() {
  test('empty translations sent as [] parse as empty text', () {
    final s = CatalogService.fromJson({
      'id': 'S1',
      'name': {'ar': 'قص', 'en': 'Cut'},
      'description': <Object?>[],
      'duration_minutes': 30,
      'price': {'amount': 6000, 'currency': 'QAR', 'formatted': 'QAR 60.00'},
      'addons': <Object?>[],
    });
    expect(s.description, isEmpty);
    expect(s.price!.amount, 6000);
  });

  test('branch week accepts a map keyed by weekday', () {
    final b = SalonBranch.fromJson({
      'id': 'B1',
      'name': {'en': 'West Bay'},
      'address': <Object?>[],
      'timezone': 'Asia/Qatar',
      'week': {
        '0': [
          {'start': '10:00', 'end': '22:00'},
        ],
        '5': <Object?>[],
      },
    });
    expect(b.week, hasLength(7));
    expect(b.week![0].single.end, '22:00');
    expect(b.week![5], isEmpty);
  });

  test('unknown booking statuses never crash an older app', () {
    final b = CustomerBooking.fromJson({
      'id': 'K1',
      'status': 'teleported',
      'starts_at': '2026-11-28T08:00:00Z',
      'ends_at': '2026-11-28T08:30:00Z',
      'total': {'amount': 6000, 'currency': 'QAR', 'formatted': 'QAR 60.00'},
      'items': <Object?>[],
    });
    expect(b.status, BookingStatus.unknown);
    expect(b.startsAt.isUtc, isTrue);
  });

  test('the selection sends ids only, with "any" for no barber', () {
    const sel = BookingSelection(branch: 'B1', services: ['S1']);
    expect(sel.toQuery(), {'branch': 'B1', 'services': ['S1'], 'addons': <String>[], 'bundles': <String>[], 'barber': 'any'});
  });
}
