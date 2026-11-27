import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbarber_customer/app/router.dart';
import 'package:smartbarber_customer/app/session.dart';
import 'package:smartbarber_customer/features/auth/phone_number.dart';

import 'helpers.dart';

void main() {
  group('normalizePhone', () {
    test('adds the Qatar code and strips spaces', () => expect(normalizePhone('5512 3456'), '+97455123456'));
    test('accepts Arabic-Indic digits', () => expect(normalizePhone('٥٥١٢٣٤٥٦'), '+97455123456'));
    test('keeps international numbers', () => expect(normalizePhone('00971501234567'), '+971501234567'));
    test('rejects garbage', () {
      expect(normalizePhone('12'), isNull);
      expect(normalizePhone('abc'), isNull);
    });
  });

  group('customerRedirect', () {
    Uri u(String s) => Uri.parse(s);
    const signedIn = AsyncData<CustomerSessionState>(SignedIn(testAccount));
    const signedOut = AsyncData<CustomerSessionState>(SignedOut());

    test('waits on splash while the session loads', () {
      expect(customerRedirect(uri: u('/home'), session: const AsyncLoading(), localeChosen: true), '/splash');
    });

    test('asks for a language on first launch', () {
      expect(customerRedirect(uri: u('/splash'), session: signedOut, localeChosen: false), '/language');
    });

    test('sends signed-out users to sign in and remembers where they were going', () {
      expect(customerRedirect(uri: u('/splash'), session: signedOut, localeChosen: true), '/login');
      expect(customerRedirect(uri: u('/appointments'), session: signedOut, localeChosen: true), '/login?from=%2Fappointments');
      expect(customerRedirect(uri: u('/login/code?phone=x'), session: signedOut, localeChosen: true), isNull);
    });

    test('takes signed-in users home or back to the intended route', () {
      expect(customerRedirect(uri: u('/login'), session: signedIn, localeChosen: true), '/home');
      expect(customerRedirect(uri: u('/login/code?from=/appointments'), session: signedIn, localeChosen: true), '/appointments');
      expect(customerRedirect(uri: u('/login?from=https://evil.example'), session: signedIn, localeChosen: true), '/home');
      expect(customerRedirect(uri: u('/profile'), session: signedIn, localeChosen: true), isNull);
    });

    test('maps the smartbarber:// scheme to app paths', () {
      expect(customerRedirect(uri: u('smartbarber://booking/01ABC'), session: signedIn, localeChosen: true), '/booking/01ABC');
    });
  });
}
