import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:sb_ui/testing.dart';

void main() {
  setUpAll(loadSbTestFonts);

  test('maps server codes and network failures to translated text', () async {
    final ar = await SbLocalizations.delegate.load(const Locale('ar'));
    final en = await SbLocalizations.delegate.load(const Locale('en'));

    expect(failureMessage(en, const ApiFailure(code: 'OTP_INVALID', status: 422)), 'The code is incorrect.');
    expect(failureMessage(ar, const ApiFailure(code: 'OTP_INVALID', status: 422)), 'الرمز غير صحيح.');
    expect(failureMessage(en, const NetworkFailure(NetworkIssue.offline)), en.errorNetworkOffline);
    expect(failureMessage(en, const ApiFailure(code: 'SOMETHING_NEW', status: 400, message: 'Server text')), 'Server text');
    expect(failureMessage(en, const UnknownFailure('boom')), en.errorGeneric);
  });

  testWidgets('SbStateView renders every state and retries', (tester) async {
    var retried = 0;
    Future<void> pump(SbViewState<String> state) => tester.pumpWidget(
      sbTestApp(
        locale: const Locale('en'),
        child: Scaffold(body: SbStateView<String>(state: state, onRetry: () => retried++, builder: (_, v) => Text(v))),
      ),
    );

    await pump(const SbContent('hello'));
    expect(find.text('hello'), findsOneWidget);

    await pump(const SbEmpty());
    expect(find.text('Nothing here yet'), findsOneWidget);

    await pump(const SbNoPermission());
    expect(find.text('You don’t have access'), findsOneWidget);

    await pump(const SbFailed(NetworkFailure(NetworkIssue.offline)));
    expect(find.text('No internet connection. Check your connection and try again.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retried, 1);

    await pump(const SbLoading());
    expect(find.byType(SbSkeleton), findsWidgets);
  });

  testWidgets('uses the Arabic font and RTL direction in Arabic', (tester) async {
    await tester.pumpWidget(sbTestApp(child: const Scaffold(body: Text('مرحبا'))));
    final context = tester.element(find.text('مرحبا'));

    expect(Directionality.of(context), TextDirection.rtl);
    expect(Theme.of(context).textTheme.bodyLarge!.fontFamily, 'packages/sb_ui/IBM Plex Sans Arabic');
    expect(context.sbColors, SbColors.light);
  });

  testWidgets('buttons keep a 48 px touch target and block taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      sbTestApp(
        child: Scaffold(
          body: Center(child: SbButton(label: 'حفظ', loading: true, onPressed: () => taps++)),
        ),
      ),
    );
    expect(tester.getSize(find.byType(SbButton)).height, greaterThanOrEqualTo(48));
    await tester.tap(find.byType(SbButton));
    expect(taps, 0);
  });
}
