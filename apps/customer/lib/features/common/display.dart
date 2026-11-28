import 'package:material_ui/material_ui.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

extension DisplayContext on BuildContext {
  String get lang => Localizations.localeOf(this).languageCode;

  String tr(LocalizedText? text) => localize(text, lang);
}

/// Duration as "45 min" / "1 h 15 min".
String durationLabel(AppLocalizations l, int minutes) {
  if (minutes < 60) return l.durationMinutes(minutes);
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? l.durationHours(h) : l.durationHoursMinutes(h, m);
}

/// Booking status → label and tone. Unknown statuses read as neutral.
(String, SbTone) statusLabel(AppLocalizations l, BookingStatus status) => switch (status) {
  BookingStatus.pending => (l.statusPending, SbTone.warning),
  BookingStatus.confirmed => (l.statusConfirmed, SbTone.success),
  BookingStatus.arrived => (l.statusArrived, SbTone.info),
  BookingStatus.inService => (l.statusInService, SbTone.info),
  BookingStatus.completed => (l.statusCompleted, SbTone.neutral),
  BookingStatus.cancelled => (l.statusCancelled, SbTone.error),
  BookingStatus.noShow => (l.statusNoShow, SbTone.error),
  BookingStatus.unknown => (l.statusUnknown, SbTone.neutral),
};

/// Opening ranges as "10:00–13:00 · 16:00–22:00" (branch wall time, from the server).
String hoursLabel(AppLocalizations l, List<TimeRange> ranges) =>
    ranges.isEmpty ? l.closedToday : ranges.map((r) => '${r.start}–${r.end}').join(' · ');

/// Round avatar with a photo or an initial; never a hard-coded colour.
class SbAvatar extends StatelessWidget {
  const new({required this.label, super.key, this.url, this.radius = 24});

  final String label;
  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = context.sbColors;
    final initial = label.trim().isEmpty ? '' : label.trim().characters.first.toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: c.accentSoft,
      foregroundImage: url == null ? null : NetworkImage(url!),
      child: initial.isEmpty
          ? Icon(Icons.person_rounded, color: c.accent, size: radius)
          : Text(initial, style: context.sbText.titleMedium?.copyWith(color: c.accent)),
    );
  }
}
