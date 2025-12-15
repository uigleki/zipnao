import 'dart:convert';
import 'dart:typed_data';

import 'package:big5_utf8_converter/big5_utf8_converter.dart';
import 'package:charset/charset.dart';

import '../domain/models/source_encoding.dart';

final _big5Decoder = Big5Decoder();

/// Decode bytes using the specified encoding.
/// Returns null if decoding fails.
String? decodeBytes(Uint8List bytes, SourceEncoding encoding) {
  try {
    return switch (encoding) {
      SourceEncoding.utf8 => utf8.decode(bytes, allowMalformed: true),
      SourceEncoding.gbk => gbk.decode(bytes),
      SourceEncoding.big5 => _big5Decoder.convert(bytes),
      SourceEncoding.shiftJis => shiftJis.decode(bytes),
      SourceEncoding.eucJp => eucJp.decode(bytes),
      SourceEncoding.eucKr => eucKr.decode(bytes),
    };
  } catch (_) {
    return null;
  }
}
