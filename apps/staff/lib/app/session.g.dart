// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Salon-bound staff session (ADR-002). Every token belongs to exactly one salon.

@ProviderFor(StaffSession)
final staffSessionProvider = StaffSessionProvider._();

/// Salon-bound staff session (ADR-002). Every token belongs to exactly one salon.
final class StaffSessionProvider
    extends $AsyncNotifierProvider<StaffSession, StaffSessionState> {
  /// Salon-bound staff session (ADR-002). Every token belongs to exactly one salon.
  StaffSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffSessionHash();

  @$internal
  @override
  StaffSession create() => StaffSession();
}

String _$staffSessionHash() => r'8ed775442b2f90a661ffbf9398b182189c9a93cc';

/// Salon-bound staff session (ADR-002). Every token belongs to exactly one salon.

abstract class _$StaffSession extends $AsyncNotifier<StaffSessionState> {
  FutureOr<StaffSessionState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<StaffSessionState>, StaffSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StaffSessionState>, StaffSessionState>,
              AsyncValue<StaffSessionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The pending step of a multi-step sign-in (2FA challenge or salon selection).

@ProviderFor(LoginFlow)
final loginFlowProvider = LoginFlowProvider._();

/// The pending step of a multi-step sign-in (2FA challenge or salon selection).
final class LoginFlowProvider
    extends $NotifierProvider<LoginFlow, StaffLoginStep?> {
  /// The pending step of a multi-step sign-in (2FA challenge or salon selection).
  LoginFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginFlowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginFlowHash();

  @$internal
  @override
  LoginFlow create() => LoginFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffLoginStep? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffLoginStep?>(value),
    );
  }
}

String _$loginFlowHash() => r'd1b7f0af542a0b8564c0c7ab1e79a3e2718c9d16';

/// The pending step of a multi-step sign-in (2FA challenge or salon selection).

abstract class _$LoginFlow extends $Notifier<StaffLoginStep?> {
  StaffLoginStep? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StaffLoginStep?, StaffLoginStep?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StaffLoginStep?, StaffLoginStep?>,
              StaffLoginStep?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
