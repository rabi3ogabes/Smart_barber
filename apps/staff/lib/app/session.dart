import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_staff/app/providers.dart';

part 'session.g.dart';

sealed class StaffSessionState {
  const new();
}

final class StaffSignedOut extends StaffSessionState {
  const new({this.expired = false});

  final bool expired;
}

final class StaffSignedInState extends StaffSessionState {
  const new(this.me);

  /// User, salon, roles, permissions (display only), branches, features.
  final StaffMe me;
}

/// Salon-bound staff session (ADR-002). Every token belongs to exactly one salon.
@Riverpod(keepAlive: true)
class StaffSession extends _$StaffSession {
  @override
  Future<StaffSessionState> build() async {
    final tokens = await ref.read(tokenStoreProvider).read();
    if (tokens == null) return const StaffSignedOut();
    return await _loadMe(onFailure: const StaffSignedOut());
  }

  /// Completes sign-in with salon-bound tokens; loads who the user is in that salon.
  Future<AppFailure?> signedIn(AuthTokens tokens) async {
    await ref.read(tokenStoreProvider).write(tokens);
    final result = await ref.read(staffAuthRepositoryProvider).me();
    switch (result) {
      case Ok(:final value):
        state = AsyncData(StaffSignedInState(value));
        return null;
      case Err(:final failure):
        await ref.read(tokenStoreProvider).clear();
        return failure;
    }
  }

  Future<void> logout() async {
    await ref.read(staffAuthRepositoryProvider).logout();
    await ref.read(tokenStoreProvider).clear();
    state = const AsyncData(StaffSignedOut());
  }

  void expired() => state = const AsyncData(StaffSignedOut(expired: true));

  Future<StaffSessionState> _loadMe({required StaffSessionState onFailure}) async {
    final result = await ref.read(staffAuthRepositoryProvider).me();
    switch (result) {
      case Ok(:final value):
        return StaffSignedInState(value);
      case Err(:final failure):
        if (failure is ApiFailure && (failure.endsSession || failure.status == 401 || failure.code == ApiErrorCode.salonSuspended)) {
          await ref.read(tokenStoreProvider).clear();
          return const StaffSignedOut(expired: true);
        }
        // Offline at start-up: the staff app needs live data, so ask to sign in again later.
        return onFailure;
    }
  }
}

/// The pending step of a multi-step sign-in (2FA challenge or salon selection).
@Riverpod(keepAlive: true)
class LoginFlow extends _$LoginFlow {
  @override
  StaffLoginStep? build() => null;

  // A setter is not used: Notifier state is set through a method by convention here.
  // ignore: use_setters_to_change_properties
  void set(StaffLoginStep? step) => state = step;
}
