import 'dart:io';
import 'dart:typed_data';

import '../../utils/constants.dart';

/// Repository for reading file content for encoding detection.
class FileRepository {
  const FileRepository();

  /// Read bytes for encoding detection.
  Future<Uint8List> readForDetection(String path) async {
    final file = File(path);

    if (path.toLowerCase().endsWith('.zip')) {
      return _readZipFileNames(file);
    }
    return _readFileContent(file);
  }

  Future<Uint8List> _readZipFileNames(File file) async {
    final bytes = await file.readAsBytes();
    final nameBytes = <int>[];

    var offset = 0;
    while (offset < bytes.length - 4) {
      // Local file header signature: 0x04034b50 (little endian: 50 4B 03 04)
      if (bytes[offset] == 0x50 &&
          bytes[offset + 1] == 0x4B &&
          bytes[offset + 2] == 0x03 &&
          bytes[offset + 3] == 0x04) {
        final nameLength = bytes[offset + 26] | (bytes[offset + 27] << 8);
        final extraLength = bytes[offset + 28] | (bytes[offset + 29] << 8);
        final compressedSize =
            bytes[offset + 18] |
            (bytes[offset + 19] << 8) |
            (bytes[offset + 20] << 16) |
            (bytes[offset + 21] << 24);

        final nameStart = offset + 30;
        final nameEnd = nameStart + nameLength;

        if (nameEnd <= bytes.length) {
          nameBytes.addAll(bytes.sublist(nameStart, nameEnd));
          nameBytes.add(0x0A); // newline separator
        }

        offset = nameEnd + extraLength + compressedSize;
        if (nameBytes.length >= DetectionConfig.maxBytes) break;
      } else {
        offset++;
      }
    }

    final limit = nameBytes.length > DetectionConfig.maxBytes
        ? DetectionConfig.maxBytes
        : nameBytes.length;
    return Uint8List.fromList(nameBytes.sublist(0, limit));
  }

  Future<Uint8List> _readFileContent(File file) async {
    final raf = await file.open();
    try {
      final length = await raf.length();
      final bytesToRead = length > DetectionConfig.maxBytes
          ? DetectionConfig.maxBytes
          : length;
      return await raf.read(bytesToRead);
    } finally {
      await raf.close();
    }
  }
}
