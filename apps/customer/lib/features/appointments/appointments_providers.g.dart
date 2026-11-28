// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Upcoming or past bookings, loaded a page at a time.

@ProviderFor(BookingList)
final bookingListProvider = BookingListFamily._();

/// Upcoming or past bookings, loaded a page at a time.
final class BookingListProvider
    extends $AsyncNotifierProvider<BookingList, List<CustomerBooking>> {
  /// Upcoming or past bookings, loaded a page at a time.
  BookingListProvider._({
    required BookingListFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'bookingListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingListHash();

  @override
  String toString() {
    return r'bookingListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingList create() => BookingList();

  @override
  bool operator ==(Object other) {
    return other is BookingListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingListHash() => r'b5c96142291981a1774582fc1d12e2fb044c7075';

/// Upcoming or past bookings, loaded a page at a time.

final class BookingListFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingList,
          AsyncValue<List<CustomerBooking>>,
          List<CustomerBooking>,
          FutureOr<List<CustomerBooking>>,
          bool
        > {
  BookingListFamily._()
    : super(
        retry: null,
        name: r'bookingListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Upcoming or past bookings, loaded a page at a time.

  BookingListProvider call({required bool upcoming}) =>
      BookingListProvider._(argument: upcoming, from: this);

  @override
  String toString() => r'bookingListProvider';
}

/// Upcoming or past bookings, loaded a page at a time.

abstract class _$BookingList extends $AsyncNotifier<List<CustomerBooking>> {
  late final _$args = ref.$arg as bool;
  bool get upcoming => _$args;

  FutureOr<List<CustomerBooking>> build({required bool upcoming});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<CustomerBooking>>, List<CustomerBooking>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CustomerBooking>>,
                List<CustomerBooking>
              >,
              AsyncValue<List<CustomerBooking>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(upcoming: _$args));
  }
}

@ProviderFor(bookingDetail)
final bookingDetailProvider = BookingDetailFamily._();

final class BookingDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CustomerBooking>,
          CustomerBooking,
          FutureOr<CustomerBooking>
        >
    with $FutureModifier<CustomerBooking>, $FutureProvider<CustomerBooking> {
  BookingDetailProvider._({
    required BookingDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailHash();

  @override
  String toString() {
    return r'bookingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CustomerBooking> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CustomerBooking> create(Ref ref) {
    final argument = this.argument as String;
    return bookingDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailHash() => r'2cc9e9d9c4ad5bb5604adcbe2e125c7b28cbf1ee';

final class BookingDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CustomerBooking>, String> {
  BookingDetailFamily._()
    : super(
        retry: null,
        name: r'bookingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingDetailProvider call(String id) =>
      BookingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'bookingDetailProvider';
}
