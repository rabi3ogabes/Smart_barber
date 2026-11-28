import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sb_api/sb_api.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Directions in the phone's maps app (Apple Maps on iOS, Google Maps elsewhere).
Future<void> openMaps(BuildContext context, GeoPoint at, String label) async {
  final q = Uri.encodeComponent(label);
  final uri = Platform.isIOS
      ? Uri.parse('https://maps.apple.com/?daddr=${at.lat},${at.lng}&q=$q')
      : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${at.lat},${at.lng}');
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showMessage(context, AppLocalizations.of(context).cannotOpenLink);
}

Future<void> callPhone(BuildContext context, String phone) async {
  final ok = await launchUrl(Uri(scheme: 'tel', path: phone));
  if (!ok && context.mounted) showMessage(context, AppLocalizations.of(context).cannotOpenLink);
}

/// Hands the booking's .ics file to the system share sheet, where "Add to Calendar" lives.
Future<void> shareCalendarFile(BuildContext context, List<int> bytes, String bookingId) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/booking-$bookingId.ics');
  await file.writeAsBytes(bytes, flush: true);
  await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'text/calendar')]));
}
