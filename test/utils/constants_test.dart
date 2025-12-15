import 'package:flutter_test/flutter_test.dart';
import 'package:zipnao/utils/constants.dart';

void main() {
  group('filterForCjk', () {
    test('removes ASCII letters', () {
      expect(filterForCjk('abc测试def'), '测试');
    });

    test('removes digits', () {
      expect(filterForCjk('123测试456'), '测试');
    });

    test('removes whitespace', () {
      expect(filterForCjk(' 测 试 '), '测试');
    });

    test('removes punctuation', () {
      expect(filterForCjk('测试。，！'), '测试');
      expect(filterForCjk('test.file,name!'), '');
    });

    test('preserves CJK characters', () {
      expect(filterForCjk('中文日本語한국어'), '中文日本語한국어');
    });

    test('handles empty string', () {
      expect(filterForCjk(''), '');
    });

    test('handles ASCII-only string', () {
      expect(filterForCjk('abc123'), '');
    });

    test('handles mixed content realistically', () {
      expect(filterForCjk('2024年报告'), '年报告');
    });
  });
}
