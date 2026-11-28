// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_registration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in tests; Firebase when the build is configured, otherwise disabled.

@ProviderFor(pushService)
final pushServiceProvider = PushServiceProvider._();

/// Overridden in tests; Firebase when the build is configured, otherwise disabled.

final class PushServiceProvider
    extends $FunctionalProvider<PushService, PushService, PushService>
    with $Provider<PushService> {
  /// Overridden in tests; Firebase when the build is configured, otherwise disabled.
  PushServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushServiceHash();

  @$internal
  @override
  $ProviderElement<PushService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushService create(Ref ref) {
    return pushService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushService>(value),
    );
  }
}

String _$pushServiceHash() => r'f688ca8b2f361cd68bde9e7abc0464a18b59697a';

/// While signed in: registers the device token (and its refreshes) with the API, and opens the
/// booking a tapped notification points to. Kept alive by the app widget.

@ProviderFor(PushRegistration)
final pushRegistrationProvider = PushRegistrationProvider._();

/// While signed in: registers the device token (and its refreshes) with the API, and opens the
/// booking a tapped notification points to. Kept alive by the app widget.
final class PushRegistrationProvider
    extends $NotifierProvider<PushRegistration, bool> {
  /// While signed in: registers the device token (and its refreshes) with the API, and opens the
  /// booking a tapped notification points to. Kept alive by the app widget.
  PushRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationHash();

  @$internal
  @override
  PushRegistration create() => PushRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pushRegistrationHash() => r'6986989b6bc2ff3348d9dba2a7c63eed0d685f30';

/// While signed in: registers the device token (and its refreshes) with the API, and opens the
/// booking a tapped notification points to. Kept alive by the app widget.

abstract class _$PushRegistration extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
