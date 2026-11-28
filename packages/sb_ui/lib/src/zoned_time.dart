import 'package:intl/intl.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Shows server UTC instants in the branch's timezone (rule 5), whatever the phone's zone is.
abstract final class SbZonedTime {
  static bool _ready = false;

  static void _init() {
    if (_ready) return;
    tzdata.initializeTimeZones();
    _ready = true;
  }

  /// The wall-clock time in [timezone] for [utc]. Unknown zones fall back to UTC.
  static DateTime wallClock(DateTime utc, String timezone) {
    _init();
    try {
      final t = tz.TZDateTime.from(utc.toUtc(), tz.getLocation(timezone));
      return DateTime(t.year, t.month, t.day, t.hour, t.minute, t.second);
    } on Object {
      return utc.toUtc();
    }
  }

  /// Today's date (`YYYY-MM-DD`) in [timezone].
  static String today(DateTime nowUtc, String timezone) => isoDate(wallClock(nowUtc, timezone));

  static String isoDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// "Thu 27 Nov" / "الخميس ٢٧ نوفمبر".
  static String day(DateTime utc, String timezone, String locale) => DateFormat.MMMEd(_locale(locale)).format(wallClock(utc, timezone));

  /// "Thursday, 27 November 2026".
  static String longDay(DateTime utc, String timezone, String locale) => DateFormat.yMMMMEEEEd(_locale(locale)).format(wallClock(utc, timezone));

  /// "10:30" (24h, Gulf convention) in the branch timezone.
  static String time(DateTime utc, String timezone, String locale) => DateFormat.Hm(_locale(locale)).format(wallClock(utc, timezone));

  /// "Thu" / "الخميس".
  static String weekdayShort(DateTime utc, String timezone, String locale) => DateFormat.E(_locale(locale)).format(wallClock(utc, timezone));

  /// "27" / "٢٧".
  static String dayOfMonth(DateTime utc, String timezone, String locale) => DateFormat.d(_locale(locale)).format(wallClock(utc, timezone));

  static String _locale(String locale) => locale == 'ar' ? 'ar' : 'en_GB';
}
