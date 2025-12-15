import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:zipnao/domain/models/file_info.dart';

void main() {
  group('FileInfo', () {
    group('properties', () {
      test('extracts name from path', () {
        final path = p.join('folder', 'test.zip');
        final info = FileInfo(path: path);
        expect(info.name, 'test.zip');
      });

      test('extracts directory from path', () {
        final path = p.join('folder', 'subfolder', 'test.zip');
        final info = FileInfo(path: path);
        expect(info.directory, p.join('folder', 'subfolder'));
      });

      test('extracts extension correctly', () {
        final info = FileInfo(path: 'test.ZIP');
        expect(info.extension, '.zip');
      });

      test('extracts name without extension', () {
        final path = p.join('folder', 'test.zip');
        final info = FileInfo(path: path);
        expect(info.nameWithoutExtension, 'test');
      });
    });

    group('file type detection', () {
      test('isZip returns true for .zip files', () {
        const info = FileInfo(path: 'test.zip');
        expect(info.isZip, isTrue);
        expect(info.isTxt, isFalse);
      });

      test('isTxt returns true for .txt files', () {
        const info = FileInfo(path: 'test.txt');
        expect(info.isTxt, isTrue);
        expect(info.isZip, isFalse);
      });

      test('isSupported returns true for supported extensions', () {
        expect(const FileInfo(path: 'a.zip').isSupported, isTrue);
        expect(const FileInfo(path: 'a.txt').isSupported, isTrue);
        expect(const FileInfo(path: 'a.pdf').isSupported, isFalse);
      });

      test('handles case-insensitive extensions', () {
        expect(const FileInfo(path: 'a.ZIP').isZip, isTrue);
        expect(const FileInfo(path: 'a.TXT').isTxt, isTrue);
      });
    });

    group('defaultOutputPath', () {
      test('generates folder path for ZIP', () {
        final path = p.join('folder', 'archive.zip');
        final info = FileInfo(path: path);
        expect(info.defaultOutputPath, p.join('folder', 'archive'));
      });

      test('generates _fixed.txt path for TXT', () {
        final path = p.join('folder', 'doc.txt');
        final info = FileInfo(path: path);
        expect(info.defaultOutputPath, p.join('folder', 'doc_fixed.txt'));
      });
    });

    group('isSupportedPath', () {
      test('returns true for supported extensions', () {
        expect(FileInfo.isSupportedPath('test.zip'), isTrue);
        expect(FileInfo.isSupportedPath('test.txt'), isTrue);
        expect(FileInfo.isSupportedPath('test.ZIP'), isTrue);
      });

      test('returns false for unsupported extensions', () {
        expect(FileInfo.isSupportedPath('test.pdf'), isFalse);
        expect(FileInfo.isSupportedPath('test.rar'), isFalse);
        expect(FileInfo.isSupportedPath('test'), isFalse);
      });
    });
  });
}
