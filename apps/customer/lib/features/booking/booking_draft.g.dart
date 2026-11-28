// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_draft.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingDraft)
final bookingDraftProvider = BookingDraftProvider._();

final class BookingDraftProvider
    extends $NotifierProvider<BookingDraft, BookingDraftState> {
  BookingDraftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingDraftProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingDraftHash();

  @$internal
  @override
  BookingDraft create() => BookingDraft();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingDraftState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingDraftState>(value),
    );
  }
}

String _$bookingDraftHash() => r'4fe4482bea166a008bae390e4895322cbb3bc6c4';

abstract class _$BookingDraft extends $Notifier<BookingDraftState> {
  BookingDraftState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookingDraftState, BookingDraftState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingDraftState, BookingDraftState>,
              BookingDraftState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(branchMenu)
final branchMenuProvider = BranchMenuFamily._();

final class BranchMenuProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceMenu>,
          ServiceMenu,
          FutureOr<ServiceMenu>
        >
    with $FutureModifier<ServiceMenu>, $FutureProvider<ServiceMenu> {
  BranchMenuProvider._({
    required BranchMenuFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'branchMenuProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$branchMenuHash();

  @override
  String toString() {
    return r'branchMenuProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceMenu> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceMenu> create(Ref ref) {
    final argument = this.argument as String;
    return branchMenu(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchMenuProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$branchMenuHash() => r'4d71e8acd06fe2f496b6cb8673179b6fc6790140';

final class BranchMenuFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceMenu>, String> {
  BranchMenuFamily._()
    : super(
        retry: null,
        name: r'branchMenuProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BranchMenuProvider call(String branch) =>
      BranchMenuProvider._(argument: branch, from: this);

  @override
  String toString() => r'branchMenuProvider';
}

@ProviderFor(branchBarbers)
final branchBarbersProvider = BranchBarbersFamily._();

final class BranchBarbersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BarberProfile>>,
          List<BarberProfile>,
          FutureOr<List<BarberProfile>>
        >
    with
        $FutureModifier<List<BarberProfile>>,
        $FutureProvider<List<BarberProfile>> {
  BranchBarbersProvider._({
    required BranchBarbersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'branchBarbersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$branchBarbersHash();

  @override
  String toString() {
    return r'branchBarbersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BarberProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BarberProfile>> create(Ref ref) {
    final argument = this.argument as String;
    return branchBarbers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchBarbersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$branchBarbersHash() => r'00ad8ea345bff2a5925ce7e0d0653c31ecff68d1';

final class BranchBarbersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BarberProfile>>, String> {
  BranchBarbersFamily._()
    : super(
        retry: null,
        name: r'branchBarbersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BranchBarbersProvider call(String branch) =>
      BranchBarbersProvider._(argument: branch, from: this);

  @override
  String toString() => r'branchBarbersProvider';
}

/// Free times for the draft's selection on its date.

@ProviderFor(slots)
final slotsProvider = SlotsFamily._();

/// Free times for the draft's selection on its date.

final class SlotsProvider
    extends $FunctionalProvider<AsyncValue<SlotDay>, SlotDay, FutureOr<SlotDay>>
    with $FutureModifier<SlotDay>, $FutureProvider<SlotDay> {
  /// Free times for the draft's selection on its date.
  SlotsProvider._({
    required SlotsFamily super.from,
    required (BookingSelection, String) super.argument,
  }) : super(
         retry: null,
         name: r'slotsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$slotsHash();

  @override
  String toString() {
    return r'slotsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<SlotDay> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SlotDay> create(Ref ref) {
    final argument = this.argument as (BookingSelection, String);
    return slots(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SlotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$slotsHash() => r'942b1aab69e593581f7a7e37567c8b3ac07335e9';

/// Free times for the draft's selection on its date.

final class SlotsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<SlotDay>,
          (BookingSelection, String)
        > {
  SlotsFamily._()
    : super(
        retry: null,
        name: r'slotsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Free times for the draft's selection on its date.

  SlotsProvider call(BookingSelection selection, String date) =>
      SlotsProvider._(argument: (selection, date), from: this);

  @override
  String toString() => r'slotsProvider';
}

/// The server quote shown on the summary step.

@ProviderFor(quote)
final quoteProvider = QuoteFamily._();

/// The server quote shown on the summary step.

final class QuoteProvider
    extends $FunctionalProvider<AsyncValue<Quote>, Quote, FutureOr<Quote>>
    with $FutureModifier<Quote>, $FutureProvider<Quote> {
  /// The server quote shown on the summary step.
  QuoteProvider._({
    required QuoteFamily super.from,
    required BookingSelection super.argument,
  }) : super(
         retry: null,
         name: r'quoteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quoteHash();

  @override
  String toString() {
    return r'quoteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Quote> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Quote> create(Ref ref) {
    final argument = this.argument as BookingSelection;
    return quote(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quoteHash() => r'7de32b1456c0114487be04ecf833d11493e56a87';

/// The server quote shown on the summary step.

final class QuoteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Quote>, BookingSelection> {
  QuoteFamily._()
    : super(
        retry: null,
        name: r'quoteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The server quote shown on the summary step.

  QuoteProvider call(BookingSelection selection) =>
      QuoteProvider._(argument: selection, from: this);

  @override
  String toString() => r'quoteProvider';
}
