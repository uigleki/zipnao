import 'package:flutter/foundation.dart';

import '../../domain/models/encoding_result.dart';
import '../../domain/models/frequency_data.dart';
import '../../domain/models/source_encoding.dart';
import '../../utils/codec.dart';
import '../../utils/constants.dart';

/// Parameters for isolate computation.
class _DetectionParams {
  const _DetectionParams({required this.bytes, required this.frequencyData});

  final Uint8List bytes;
  final FrequencyData frequencyData;
}

/// Service for detecting the most likely encoding of byte data.
class EncodingDetector {
  const EncodingDetector(this._frequencyData);

  final FrequencyData _frequencyData;

  /// Detect encodings and return results sorted by score (descending).
  /// When scores are equal, UTF-8 comes first.
  Future<List<EncodingResult>> detect(Uint8List bytes) {
    final params = _DetectionParams(
      bytes: bytes,
      frequencyData: _frequencyData,
    );
    return compute(_detectInIsolate, params);
  }
}

List<EncodingResult> _detectInIsolate(_DetectionParams params) {
  final results = <EncodingResult>[];

  for (final encoding in SourceEncoding.values) {
    final result = _analyzeEncoding(encoding, params);
    results.add(result);
  }

  // Sort by score descending, UTF-8 first when tied
  results.sort((a, b) {
    final cmp = b.score.compareTo(a.score);
    if (cmp != 0) return cmp;
    if (a.encoding == SourceEncoding.utf8) return -1;
    if (b.encoding == SourceEncoding.utf8) return 1;
    return a.encoding.index.compareTo(b.encoding.index);
  });

  return results;
}

EncodingResult _analyzeEncoding(
  SourceEncoding encoding,
  _DetectionParams params,
) {
  final decoded = decodeBytes(params.bytes, encoding);

  if (decoded == null || decoded.isEmpty) {
    return EncodingResult(encoding: encoding, score: 0, preview: '');
  }

  final filtered = filterForCjk(decoded);

  final score = filtered.isEmpty
      ? 0.0
      : _calculateScore(filtered, encoding.language, params.frequencyData);

  return EncodingResult(encoding: encoding, score: score, preview: filtered);
}

double _calculateScore(
  String text,
  String? language,
  FrequencyData frequencyData,
) {
  var total = 0.0;
  var count = 0;

  for (final rune in text.runes) {
    final char = String.fromCharCode(rune);
    final freq = frequencyData.getFrequency(char, language: language);
    if (freq > 0) {
      total += freq;
      count++;
    }
  }

  return count > 0 ? total / count : 0;
}
