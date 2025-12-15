import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zipnao/data/services/encoding_detector.dart';
import 'package:zipnao/domain/models/frequency_data.dart';
import 'package:zipnao/domain/models/source_encoding.dart';

void main() {
  group('EncodingDetector', () {
    late EncodingDetector detector;

    setUp(() {
      // Create test frequency data
      const frequencyData = FrequencyData({
        'zh': {'中': 0.9, '文': 0.8, '测': 0.7, '试': 0.6},
        'ja': {'日': 0.85, '本': 0.75, '語': 0.65},
        'ko': {'한': 0.88, '국': 0.78, '어': 0.68},
      });
      detector = EncodingDetector(frequencyData);
    });

    test('returns results for all encodings', () async {
      final bytes = utf8.encode('测试中文');
      final results = await detector.detect(Uint8List.fromList(bytes));

      expect(results, hasLength(SourceEncoding.values.length));
    });

    test('results are sorted by score descending', () async {
      final bytes = utf8.encode('测试中文');
      final results = await detector.detect(Uint8List.fromList(bytes));

      for (var i = 0; i < results.length - 1; i++) {
        expect(
          results[i].score,
          greaterThanOrEqualTo(results[i + 1].score),
          reason: 'Results should be sorted by score descending',
        );
      }
    });

    test('UTF-8 encoded Chinese text scores high for UTF-8', () async {
      final bytes = utf8.encode('测试中文内容');
      final results = await detector.detect(Uint8List.fromList(bytes));

      final utf8Result = results.firstWhere(
        (r) => r.encoding == SourceEncoding.utf8,
      );
      expect(utf8Result.score, greaterThan(0));
    });

    test('GBK encoded text scores high for GBK', () async {
      // "测试" in GBK
      final bytes = Uint8List.fromList([0xB2, 0xE2, 0xCA, 0xD4]);
      final results = await detector.detect(bytes);

      final gbkResult = results.firstWhere(
        (r) => r.encoding == SourceEncoding.gbk,
      );
      expect(gbkResult.score, greaterThan(0));
    });

    test('handles empty input', () async {
      final results = await detector.detect(Uint8List(0));

      expect(results, hasLength(SourceEncoding.values.length));
      for (final result in results) {
        expect(result.score, 0);
        expect(result.preview, isEmpty);
      }
    });

    test('preview text excludes ASCII characters', () async {
      final bytes = utf8.encode('abc测试123');
      final results = await detector.detect(Uint8List.fromList(bytes));

      final utf8Result = results.firstWhere(
        (r) => r.encoding == SourceEncoding.utf8,
      );
      expect(utf8Result.preview, isNot(contains('abc')));
      expect(utf8Result.preview, isNot(contains('123')));
    });
  });
}
