import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_api/sb_api.dart';
import 'package:smartbarber_staff/app/router.dart';
import 'package:smartbarber_staff/app/session.dart';

import 'helpers.dart';

void main() {
  const out = AsyncData<StaffSessionState>(StaffSignedOut());
  const inside = AsyncData<StaffSessionState>(StaffSignedInState(testMe));

  test('waits on splash while the session loads', () {
    expect(staffRedirect(path: '/today', session: const AsyncLoading(), pendingStep: null), '/splash');
  });

  test('signed-out users only reach the pending sign-in step', () {
    expect(staffRedirect(path: '/today', session: out, pendingStep: null), '/login');
    expect(staffRedirect(path: '/login/2fa', session: out, pendingStep: null), '/login');
    expect(staffRedirect(path: '/login', session: out, pendingStep: const StaffTwoFactorRequired('c')), '/login/2fa');
    expect(
      staffRedirect(path: '/login/2fa', session: out, pendingStep: const StaffSalonSelectionRequired(selectionToken: 's', memberships: [])),
      '/login/salon',
    );
  });

  test('signed-in users go to Today and stay off the sign-in screens', () {
    expect(staffRedirect(path: '/login', session: inside, pendingStep: null), '/today');
    expect(staffRedirect(path: '/me', session: inside, pendingStep: null), isNull);
  });
}
