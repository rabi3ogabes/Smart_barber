// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Restores the session at start-up and tracks sign-in / sign-out.
///
/// The last profile is cached so the app opens offline with the "offline" banner (flutter.md, Offline).

@ProviderFor(CustomerSession)
final customerSessionProvider = CustomerSessionProvider._();

/// Restores the session at start-up and tracks sign-in / sign-out.
///
/// The last profile is cached so the app opens offline with the "offline" banner (flutter.md, Offline).
final class CustomerSessionProvider
    extends $AsyncNotifierProvider<CustomerSession, CustomerSessionState> {
  /// Restores the session at start-up and tracks sign-in / sign-out.
  ///
  /// The last profile is cached so the app opens offline with the "offline" banner (flutter.md, Offline).
  CustomerSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerSessionHash();

  @$internal
  @override
  CustomerSession create() => CustomerSession();
}

String _$customerSessionHash() => r'34c8914c0767142ec0e28e27ee323e738d582f25';

/// Restores the session at start-up and tracks sign-in / sign-out.
///
/// The last profile is cached so the app opens offline with the "offline" banner (flutter.md, Offline).

abstract class _$CustomerSession extends $AsyncNotifier<CustomerSessionState> {
  FutureOr<CustomerSessionState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<CustomerSessionState>, CustomerSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CustomerSessionState>,
                CustomerSessionState
              >,
              AsyncValue<CustomerSessionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
