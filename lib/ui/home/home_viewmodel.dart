import 'package:flutter/foundation.dart';

import '../../data/repositories/file_repository.dart';
import '../../data/repositories/frequency_repository.dart';
import '../../data/services/encoding_detector.dart';
import '../../data/services/text_converter.dart';
import '../../data/services/zip_extractor.dart';
import '../../domain/models/encoding_result.dart';
import '../../domain/models/file_info.dart';

/// ViewModel for the home screen.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required FrequencyRepository frequencyRepository,
    required FileRepository fileRepository,
    required ZipExtractor zipExtractor,
    required TextConverter textConverter,
  }) : _frequencyRepository = frequencyRepository,
       _fileRepository = fileRepository,
       _zipExtractor = zipExtractor,
       _textConverter = textConverter {
    _init();
  }

  final FrequencyRepository _frequencyRepository;
  final FileRepository _fileRepository;
  final ZipExtractor _zipExtractor;
  final TextConverter _textConverter;

  // State
  FileInfo? _fileInfo;
  String _outputPath = '';
  List<EncodingResult> _results = [];
  int _selectedIndex = 0;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  FileInfo? get fileInfo => _fileInfo;
  String get outputPath => _outputPath;
  List<EncodingResult> get results => List.unmodifiable(_results);
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  bool get hasFile => _fileInfo != null;
  bool get canProcess => hasFile && _results.isNotEmpty && !_isLoading;
  bool get isZip => _fileInfo?.isZip ?? false;
  String get actionLabel => isZip ? 'Extract' : 'Fix';

  EncodingResult? get selectedResult =>
      _results.isNotEmpty ? _results[_selectedIndex] : null;

  // Initialization
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _frequencyRepository.load();
    } catch (e) {
      _error = 'Failed to load frequency data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Commands
  Future<void> selectFile(String path) async {
    _fileInfo = FileInfo(path: path);
    _outputPath = _fileInfo!.defaultOutputPath;
    _results = [];
    _selectedIndex = 0;
    _error = null;
    _successMessage = null;
    notifyListeners();

    await _detectEncoding();
  }

  void clearFile() {
    _fileInfo = null;
    _outputPath = '';
    _results = [];
    _selectedIndex = 0;
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  void setOutputPath(String path) {
    _outputPath = path;
    notifyListeners();
  }

  void selectEncoding(int index) {
    if (index >= 0 && index < _results.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  Future<void> process() async {
    if (!canProcess || selectedResult == null) return;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (isZip) {
        await _extractZip();
      } else {
        await _convertText();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  // Private methods
  Future<void> _detectEncoding() async {
    if (_fileInfo == null || !_frequencyRepository.isLoaded) return;

    _isLoading = true;
    notifyListeners();

    try {
      final bytes = await _fileRepository.readForDetection(_fileInfo!.path);

      if (bytes.isEmpty) {
        _error = 'File is empty or cannot be read';
        return;
      }

      final detector = EncodingDetector(_frequencyRepository.data);
      _results = await detector.detect(bytes);
      _selectedIndex = 0;
    } catch (e) {
      _error = 'Failed to detect encoding: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _extractZip() async {
    final result = await _zipExtractor.extract(
      zipPath: _fileInfo!.path,
      outputDir: _outputPath,
      encoding: selectedResult!.encoding,
    );

    result.when(
      success: (count) => _successMessage = 'Extracted $count file(s)',
      failure: (error) => _error = error,
    );
  }

  Future<void> _convertText() async {
    final result = await _textConverter.convert(
      inputPath: _fileInfo!.path,
      outputPath: _outputPath,
      encoding: selectedResult!.encoding,
    );

    result.when(
      success: (path) => _successMessage = 'Saved to $path',
      failure: (error) => _error = error,
    );
  }
}
