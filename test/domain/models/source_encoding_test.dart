import 'package:flutter_test/flutter_test.dart';
import 'package:zipnao/domain/models/source_encoding.dart';

void main() {
  group('SourceEncoding', () {
    test('has correct labels', () {
      expect(SourceEncoding.utf8.label, 'UTF-8');
      expect(SourceEncoding.gbk.label, 'GBK');
      expect(SourceEncoding.big5.label, 'Big5');
      expect(SourceEncoding.shiftJis.label, 'Shift_JIS');
      expect(SourceEncoding.eucJp.label, 'EUC-JP');
      expect(SourceEncoding.eucKr.label, 'EUC-KR');
    });

    test('has correct language associations', () {
      expect(SourceEncoding.utf8.language, isNull);
      expect(SourceEncoding.gbk.language, 'zh');
      expect(SourceEncoding.big5.language, 'zh');
      expect(SourceEncoding.shiftJis.language, 'ja');
      expect(SourceEncoding.eucJp.language, 'ja');
      expect(SourceEncoding.eucKr.language, 'ko');
    });

    test('contains all expected values', () {
      expect(SourceEncoding.values, hasLength(6));
    });
  });
}
