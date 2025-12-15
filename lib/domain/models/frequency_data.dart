/// Character frequency data for CJK languages.
class FrequencyData {
  const FrequencyData(this.frequencies);

  /// Language code → character → frequency (public for isolate access)
  final Map<String, Map<String, double>> frequencies;

  /// Get frequency of a character in a specific language.
  /// If [language] is null, returns max frequency across all languages.
  double getFrequency(String char, {String? language}) {
    if (language != null) {
      return frequencies[language]?[char] ?? 0;
    }

    var max = 0.0;
    for (final langFreq in frequencies.values) {
      final freq = langFreq[char] ?? 0;
      if (freq > max) max = freq;
    }
    return max;
  }
}
