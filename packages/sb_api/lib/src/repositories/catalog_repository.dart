import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/booking.dart';
import 'package:sb_api/src/models/catalog.dart';
import 'package:sb_core/sb_core.dart';

/// Branch menu, barbers and free times. Display only: the booking call re-checks everything.
class CatalogRepository {
  const new(this._api);

  final Dio _api;

  Future<Result<ServiceMenu>> menu(String branch) => Result.guard(() async {
    return ServiceMenu.fromJson(envelopeData(await _api.get<dynamic>('/branches/$branch/services')));
  });

  Future<Result<List<BarberProfile>>> barbers(String branch) => Result.guard(() async {
    return envelopeList(await _api.get<dynamic>('/branches/$branch/barbers')).map(BarberProfile.fromJson).toList();
  });

  /// Free start times on [date] (`YYYY-MM-DD`, branch-local) for the selection.
  Future<Result<SlotDay>> slots(BookingSelection selection, String date) => Result.guard(() async {
    final query = selection.toQuery()..remove('branch');
    return SlotDay.fromJson(
      envelopeData(
        await _api.get<dynamic>(
          '/branches/${selection.branch}/slots',
          queryParameters: {
            for (final MapEntry(:key, :value) in query.entries)
              if (value is List) '$key[]': value else key: value,
            'date': date,
          },
        ),
      ),
    );
  });
}
