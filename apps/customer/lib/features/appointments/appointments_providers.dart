import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';

part 'appointments_providers.g.dart';

/// Upcoming or past bookings, loaded a page at a time.
@riverpod
class BookingList extends _$BookingList {
  String? _cursor;
  bool _loadingMore = false;

  @override
  Future<List<CustomerBooking>> build({required bool upcoming}) async {
    final page = (await ref.watch(bookingRepositoryProvider).list(upcoming: upcoming)).orThrow;
    _cursor = page.nextCursor;
    return page.items;
  }

  bool get hasMore => _cursor != null;

  Future<void> loadMore() async {
    final current = state.value;
    if (_cursor == null || _loadingMore || current == null) return;
    _loadingMore = true;
    final result = await ref.read(bookingRepositoryProvider).list(upcoming: upcoming, cursor: _cursor);
    _loadingMore = false;
    final page = result.valueOrNull;
    if (page == null) return; // keep what is shown; the next scroll retries
    _cursor = page.nextCursor;
    state = AsyncData([...current, ...page.items]);
  }
}

@riverpod
Future<CustomerBooking> bookingDetail(Ref ref, String id) async => (await ref.watch(bookingRepositoryProvider).show(id)).orThrow;
