/// Supported source encodings for CJK text detection.
///
/// Named [SourceEncoding] to avoid conflict with [dart:convert.Encoding].
enum SourceEncoding {
  utf8('UTF-8', null),
  gbk('GBK', 'zh'),
  big5('Big5', 'zh'),
  shiftJis('Shift_JIS', 'ja'),
  eucJp('EUC-JP', 'ja'),
  eucKr('EUC-KR', 'ko');

  const SourceEncoding(this.label, this.language);

  /// Display label for UI.
  final String label;

  /// Associated language code for frequency scoring.
  /// Null for UTF-8 (uses max across all languages).
  final String? language;
}
