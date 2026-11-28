// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Home data for the current salon and branch.

@ProviderFor(home)
final homeProvider = HomeProvider._();

/// Home data for the current salon and branch.

final class HomeProvider
    extends
        $FunctionalProvider<
          AsyncValue<CustomerHome>,
          CustomerHome,
          FutureOr<CustomerHome>
        >
    with $FutureModifier<CustomerHome>, $FutureProvider<CustomerHome> {
  /// Home data for the current salon and branch.
  HomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeHash();

  @$internal
  @override
  $FutureProviderElement<CustomerHome> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CustomerHome> create(Ref ref) {
    return home(ref);
  }
}

String _$homeHash() => r'd7eb59e525c7f2a16ae51ea39deb9d117719fc72';

/// The branch the customer books at: their choice, else the salon's first branch.

@ProviderFor(activeBranch)
final activeBranchProvider = ActiveBranchProvider._();

/// The branch the customer books at: their choice, else the salon's first branch.

final class ActiveBranchProvider
    extends
        $FunctionalProvider<
          AsyncValue<SalonBranch?>,
          SalonBranch?,
          FutureOr<SalonBranch?>
        >
    with $FutureModifier<SalonBranch?>, $FutureProvider<SalonBranch?> {
  /// The branch the customer books at: their choice, else the salon's first branch.
  ActiveBranchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeBranchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeBranchHash();

  @$internal
  @override
  $FutureProviderElement<SalonBranch?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SalonBranch?> create(Ref ref) {
    return activeBranch(ref);
  }
}

String _$activeBranchHash() => r'd4cc9c0e599c84f905ef2c614d3999bb13d5ad1d';
