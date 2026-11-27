/// Translatable server text `{"ar": "…", "en": "…"}` (erd.md, json·tr).
typedef LocalizedText = Map<String, String>;

/// Picks the text for [languageCode], falling back to the other language.
String localize(LocalizedText? text, String languageCode) {
  if (text == null || text.isEmpty) return '';
  return text[languageCode] ?? text['en'] ?? text['ar'] ?? text.values.first;
}

/// Parses a translatable value that may be a plain string or a map.
LocalizedText parseLocalized(Object? value) => switch (value) {
  final Map<dynamic, dynamic> m => m.map((k, v) => MapEntry('$k', '$v')),
  final String s => {'ar': s, 'en': s},
  _ => const {},
};
