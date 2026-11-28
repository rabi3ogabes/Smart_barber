import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/booking.dart';
import 'package:sb_api/src/models/catalog.dart';
import 'package:sb_core/sb_core.dart';

/// Customer bookings across salons. Writes that can be retried carry an Idempotency-Key (rule 6):
/// the caller creates the key once per user intent and reuses it for every retry.
class BookingRepository {
  const new(this._api);

  final Dio _api;

  Future<Result<Quote>> quote(BookingSelection selection) => Result.guard(() async {
    return Quote.fromJson(envelopeData(await _api.post<dynamic>('/customer/quotes', data: selection.toQuery())));
  });

  /// Creates the booking. A taken slot fails with 409 `BOOKING_SLOT_TAKEN` and `data.alternatives`.
  Future<Result<CustomerBooking>> create(BookingSelection selection, DateTime startsAt, {required String idempotencyKey, String? notes}) =>
      Result.guard(() async {
        final res = await _api.post<dynamic>(
          '/customer/bookings',
          data: {...selection.toQuery(), 'starts_at': startsAt.toUtc().toIso8601String(), 'notes': ?notes},
          options: Idempotency.options(idempotencyKey),
        );
        return CustomerBooking.fromJson(envelopeData(res));
      });

  Future<Result<BookingPage>> list({required bool upcoming, String? cursor}) => Result.guard(() async {
    final res = await _api.get<dynamic>('/customer/bookings', queryParameters: {'scope': upcoming ? 'upcoming' : 'past', 'cursor': ?cursor});
    final meta = (res.data is Map ? (res.data as Map)['meta'] : null) as Map<dynamic, dynamic>?;
    return BookingPage(items: envelopeList(res).map(CustomerBooking.fromJson).toList(), nextCursor: meta?['next_cursor'] as String?);
  });

  Future<Result<CustomerBooking>> show(String id) => Result.guard(() async {
    return CustomerBooking.fromJson(envelopeData(await _api.get<dynamic>('/customer/bookings/$id')));
  });

  Future<Result<CustomerBooking>> reschedule(String id, DateTime startsAt, {required String idempotencyKey, String? barber}) =>
      Result.guard(() async {
        final res = await _api.post<dynamic>(
          '/customer/bookings/$id/reschedule',
          data: {'starts_at': startsAt.toUtc().toIso8601String(), 'barber': ?barber},
          options: Idempotency.options(idempotencyKey),
        );
        return CustomerBooking.fromJson(envelopeData(res));
      });

  Future<Result<CustomerBooking>> cancel(String id, {required String idempotencyKey, String? reason}) => Result.guard(() async {
    final res = await _api.post<dynamic>('/customer/bookings/$id/cancel', data: {'reason': ?reason}, options: Idempotency.options(idempotencyKey));
    return CustomerBooking.fromJson(envelopeData(res));
  });

  /// "Rate your visit". Completed bookings only, once.
  Future<Result<void>> review(String id, {required int rating, required String idempotencyKey, String? comment}) => Result.guard(() async {
    await _api.post<dynamic>(
      '/customer/bookings/$id/review',
      data: {'rating': rating, 'comment': ?comment},
      options: Idempotency.options(idempotencyKey),
    );
  });

  /// The booking as an iCalendar file, for "Add to calendar".
  Future<Result<Uint8List>> calendarFile(String id) => Result.guard(() async {
    final res = await _api.get<List<int>>('/customer/bookings/$id/calendar.ics', options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(res.data ?? const []);
  });
}
