import 'package:path/path.dart' as p;

/// Information about a selected file.
class FileInfo {
  const FileInfo({required this.path});

  final String path;

  String get name => p.basename(path);
  String get extension => p.extension(path).toLowerCase();
  String get directory => p.dirname(path);
  String get nameWithoutExtension => p.basenameWithoutExtension(path);

  bool get isZip => extension == '.zip';
  bool get isTxt => extension == '.txt';
  bool get isSupported => isZip || isTxt;

  /// Generate default output path based on file type.
  String get defaultOutputPath {
    if (isZip) {
      return p.join(directory, nameWithoutExtension);
    }
    return p.join(directory, '${nameWithoutExtension}_fixed$extension');
  }

  /// Check if a path has a supported extension.
  static bool isSupportedPath(String path) {
    final ext = p.extension(path).toLowerCase();
    return ext == '.zip' || ext == '.txt';
  }
}
