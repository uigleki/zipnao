import 'source_encoding.dart';

/// Result of encoding detection for a single encoding.
class EncodingResult {
  const EncodingResult({
    required this.encoding,
    required this.score,
    required this.preview,
  });

  final SourceEncoding encoding;
  final double score;
  final String preview;
}
