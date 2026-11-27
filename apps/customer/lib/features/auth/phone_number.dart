/// Normalises what the user typed into E.164 (`+97455123456`).
///
/// Accepts Arabic-Indic digits, spaces and dashes; numbers without a country code get [defaultDialCode].
/// This is input formatting only — the server validates the number.
String? normalizePhone(String input, {String defaultDialCode = '+974'}) {
  const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
  const easternArabic = '۰۱۲۳۴۵۶۷۸۹';
  final buffer = StringBuffer();
  for (final rune in input.trim().runes) {
    final ch = String.fromCharCode(rune);
    final a = arabicIndic.indexOf(ch);
    final e = easternArabic.indexOf(ch);
    if (a >= 0) {
      buffer.write(a);
    } else if (e >= 0) {
      buffer.write(e);
    } else if (RegExp('[0-9+]').hasMatch(ch)) {
      buffer.write(ch);
    }
  }

  var digits = buffer.toString();
  if (digits.startsWith('00')) digits = '+${digits.substring(2)}';
  if (!digits.startsWith('+')) digits = '$defaultDialCode$digits';

  return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(digits) ? digits : null;
}
