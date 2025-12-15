import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/source_encoding.dart';
import '../../utils/codec.dart';
import '../../utils/result.dart';

/// Service for extracting ZIP archives with encoding-corrected filenames.
class ZipExtractor {
  const ZipExtractor();

  /// Extract ZIP archive to target directory.
  /// Returns number of extracted files on success.
  Future<Result<int, String>> extract({
    required String zipPath,
    required String outputDir,
    required SourceEncoding encoding,
  }) async {
    try {
      final file = File(zipPath);
      if (!await file.exists()) {
        return const Failure('ZIP file does not exist');
      }

      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes, verify: true);

      final outDir = Directory(outputDir);
      if (!await outDir.exists()) {
        await outDir.create(recursive: true);
      }

      var count = 0;
      for (final entry in archive) {
        final decodedName = _decodeFilename(entry.name, encoding);
        final sanitizedName = _sanitizePath(decodedName);
        final outputPath = p.join(outputDir, sanitizedName);

        if (entry.isDirectory) {
          await Directory(outputPath).create(recursive: true);
        } else {
          final parentDir = Directory(p.dirname(outputPath));
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }
          await File(outputPath).writeAsBytes(entry.content as List<int>);
          count++;
        }
      }

      return Success(count);
    } on ArchiveException catch (e) {
      return Failure('Invalid or corrupted ZIP: ${e.message}');
    } on FileSystemException catch (e) {
      return Failure('File system error: ${e.message}');
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  String _decodeFilename(String rawName, SourceEncoding encoding) {
    final bytes = Uint8List.fromList(rawName.codeUnits);
    return decodeBytes(bytes, encoding) ?? rawName;
  }

  String _sanitizePath(String path) {
    return path
        .replaceAll(RegExp(r'^[/\\]+'), '')
        .replaceAll('..', '_')
        .replaceAll('\\', '/');
  }
}
