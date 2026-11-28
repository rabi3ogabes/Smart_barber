// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Salons this account has booked with.

@ProviderFor(mySalons)
final mySalonsProvider = MySalonsProvider._();

/// Salons this account has booked with.

final class MySalonsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SalonCard>>,
          List<SalonCard>,
          FutureOr<List<SalonCard>>
        >
    with $FutureModifier<List<SalonCard>>, $FutureProvider<List<SalonCard>> {
  /// Salons this account has booked with.
  MySalonsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mySalonsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mySalonsHash();

  @$internal
  @override
  $FutureProviderElement<List<SalonCard>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SalonCard>> create(Ref ref) {
    return mySalons(ref);
  }
}

String _$mySalonsHash() => r'046b88b17568576de23306087cba844ed5ac79a8';

/// Active branches of a salon with today's hours.

@ProviderFor(salonBranches)
final salonBranchesProvider = SalonBranchesFamily._();

/// Active branches of a salon with today's hours.

final class SalonBranchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SalonBranch>>,
          List<SalonBranch>,
          FutureOr<List<SalonBranch>>
        >
    with
        $FutureModifier<List<SalonBranch>>,
        $FutureProvider<List<SalonBranch>> {
  /// Active branches of a salon with today's hours.
  SalonBranchesProvider._({
    required SalonBranchesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salonBranchesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonBranchesHash();

  @override
  String toString() {
    return r'salonBranchesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SalonBranch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SalonBranch>> create(Ref ref) {
    final argument = this.argument as String;
    return salonBranches(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SalonBranchesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonBranchesHash() => r'45d91ef20a2515ae0745fc512bf00b5940948b04';

/// Active branches of a salon with today's hours.

final class SalonBranchesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SalonBranch>>, String> {
  SalonBranchesFamily._()
    : super(
        retry: null,
        name: r'salonBranchesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Active branches of a salon with today's hours.

  SalonBranchesProvider call(String salon) =>
      SalonBranchesProvider._(argument: salon, from: this);

  @override
  String toString() => r'salonBranchesProvider';
}
