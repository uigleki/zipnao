import 'package:flutter_test/flutter_test.dart';
import 'package:zipnao/domain/models/frequency_data.dart';

void main() {
  group('FrequencyData', () {
    late FrequencyData data;

    setUp(() {
      data = const FrequencyData({
        'zh': {'中': 0.8, '文': 0.6},
        'ja': {'日': 0.7, '本': 0.5, '中': 0.3},
        'ko': {'한': 0.9, '국': 0.4},
      });
    });

    group('getFrequency with specific language', () {
      test('returns frequency for existing character', () {
        expect(data.getFrequency('中', language: 'zh'), 0.8);
        expect(data.getFrequency('日', language: 'ja'), 0.7);
      });

      test('returns 0 for non-existing character', () {
        expect(data.getFrequency('X', language: 'zh'), 0.0);
      });

      test('returns 0 for non-existing language', () {
        expect(data.getFrequency('中', language: 'en'), 0.0);
      });
    });

    group('getFrequency without language (max across all)', () {
      test('returns max frequency across languages', () {
        // '中' exists in zh (0.8) and ja (0.3), should return 0.8
        expect(data.getFrequency('中'), 0.8);
      });

      test('returns 0 for non-existing character', () {
        expect(data.getFrequency('X'), 0.0);
      });
    });
  });
}
