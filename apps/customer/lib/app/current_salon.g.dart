// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_salon.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The salon the app is open on, remembered across launches (Phase 5: "remember the last salon").
/// The chosen branch is remembered per salon. Only ids and display data are kept here.

@ProviderFor(CurrentSalon)
final currentSalonProvider = CurrentSalonProvider._();

/// The salon the app is open on, remembered across launches (Phase 5: "remember the last salon").
/// The chosen branch is remembered per salon. Only ids and display data are kept here.
final class CurrentSalonProvider
    extends $NotifierProvider<CurrentSalon, SalonCard?> {
  /// The salon the app is open on, remembered across launches (Phase 5: "remember the last salon").
  /// The chosen branch is remembered per salon. Only ids and display data are kept here.
  CurrentSalonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSalonProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSalonHash();

  @$internal
  @override
  CurrentSalon create() => CurrentSalon();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonCard? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonCard?>(value),
    );
  }
}

String _$currentSalonHash() => r'5e3466762c7b885341dec2c4351f42f3e80a2c3c';

/// The salon the app is open on, remembered across launches (Phase 5: "remember the last salon").
/// The chosen branch is remembered per salon. Only ids and display data are kept here.

abstract class _$CurrentSalon extends $Notifier<SalonCard?> {
  SalonCard? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SalonCard?, SalonCard?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SalonCard?, SalonCard?>,
              SalonCard?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The branch chosen for the current salon (null = the server's default branch).

@ProviderFor(CurrentBranch)
final currentBranchProvider = CurrentBranchProvider._();

/// The branch chosen for the current salon (null = the server's default branch).
final class CurrentBranchProvider
    extends $NotifierProvider<CurrentBranch, String?> {
  /// The branch chosen for the current salon (null = the server's default branch).
  CurrentBranchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBranchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBranchHash();

  @$internal
  @override
  CurrentBranch create() => CurrentBranch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentBranchHash() => r'0f843457beb1fd709d6adf9189e53f3e7f0fb207';

/// The branch chosen for the current salon (null = the server's default branch).

abstract class _$CurrentBranch extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
