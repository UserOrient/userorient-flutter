/// Supported languages for the UserOrient SDK.
enum Language {
  az,
  de,
  en,
  es,
  fr,
  it,
  tr,
  ru,
  ar,
  uk,
  zh;

  /// Parse a language code string into a [Language].
  ///
  /// Handles full locale codes like `en-US`, `en_US`, or plain `en`.
  /// Falls back to [Language.en] for unsupported codes.
  static Language fromCode(String code) {
    final String base = code.split(RegExp(r'[-_]')).first.toLowerCase();

    try {
      return Language.values.where((Language l) {
        return l.name == base;
      }).first;
    } catch (e) {
      return Language.en;
    }
  }
}
