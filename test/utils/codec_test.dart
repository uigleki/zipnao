import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zipnao/domain/models/source_encoding.dart';
import 'package:zipnao/utils/codec.dart';

void main() {
  group('decodeBytes', () {
    group('UTF-8', () {
      test('decodes valid UTF-8', () {
        final bytes = utf8.encode('测试文本');
        final result = decodeBytes(
          Uint8List.fromList(bytes),
          SourceEncoding.utf8,
        );
        expect(result, '测试文本');
      });

      test('handles malformed UTF-8 gracefully', () {
        // Invalid UTF-8 sequence
        final bytes = Uint8List.fromList([0xFF, 0xFE]);
        final result = decodeBytes(bytes, SourceEncoding.utf8);
        expect(result, isNotNull); // allowMalformed: true
      });
    });

    group('GBK', () {
      test('decodes valid GBK', () {
        // "测试" in GBK: B2 E2 CA D4
        final bytes = Uint8List.fromList([0xB2, 0xE2, 0xCA, 0xD4]);
        final result = decodeBytes(bytes, SourceEncoding.gbk);
        expect(result, '测试');
      });
    });

    group('Shift_JIS', () {
      test('decodes valid Shift_JIS', () {
        // "日本" in Shift_JIS: 93 FA 96 7B
        final bytes = Uint8List.fromList([0x93, 0xFA, 0x96, 0x7B]);
        final result = decodeBytes(bytes, SourceEncoding.shiftJis);
        expect(result, '日本');
      });
    });

    group('empty input', () {
      test('returns empty string for empty bytes', () {
        final bytes = Uint8List(0);
        for (final encoding in SourceEncoding.values) {
          final result = decodeBytes(bytes, encoding);
          expect(
            result,
            isEmpty,
            reason: '${encoding.label} should handle empty input',
          );
        }
      });
    });
  });
}
