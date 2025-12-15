import 'dart:convert';
import 'dart:io';

import '../../domain/models/source_encoding.dart';
import '../../utils/codec.dart';
import '../../utils/result.dart';

/// Service for converting text file encoding to UTF-8.
class TextConverter {
  const TextConverter();

  /// Convert text file to UTF-8.
  /// Returns output path on success.
  Future<Result<String, String>> convert({
    required String inputPath,
    required String outputPath,
    required SourceEncoding encoding,
  }) async {
    try {
      final inputFile = File(inputPath);
      if (!await inputFile.exists()) {
        return const Failure('Input file does not exist');
      }

      final bytes = await inputFile.readAsBytes();
      if (bytes.isEmpty) {
        return const Failure('Input file is empty');
      }

      final content = decodeBytes(bytes, encoding);
      if (content == null) {
        return Failure('Failed to decode with ${encoding.label}');
      }

      final outputDir = Directory(File(outputPath).parent.path);
      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      await File(
        outputPath,
      ).writeAsString(content, encoding: utf8, flush: true);
      return Success(outputPath);
    } on FileSystemException catch (e) {
      return Failure('File system error: ${e.message}');
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }
}
