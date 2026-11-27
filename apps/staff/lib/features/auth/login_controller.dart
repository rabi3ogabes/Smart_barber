import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_staff/app/session.dart';

/// Applies the result of any sign-in step: tokens finish the sign-in, other steps become pending.
/// Returns a failure to show, or null.
Future<AppFailure?> applyLoginStep(WidgetRef ref, Result<StaffLoginStep> result) async {
  switch (result) {
    case Err(:final failure):
      if (failure is ApiFailure && failure.code == ApiErrorCode.challengeExpired) {
        ref.read(loginFlowProvider.notifier).set(null);
      }
      return failure;
    case Ok(value: StaffSignedIn(:final tokens)):
      final failure = await ref.read(staffSessionProvider.notifier).signedIn(tokens);
      ref.read(loginFlowProvider.notifier).set(null);
      return failure;
    case Ok(:final value):
      ref.read(loginFlowProvider.notifier).set(value);
      return null;
  }
}
