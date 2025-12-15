import 'package:flutter/services.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

import '../../domain/models/frequency_data.dart';
import '../../utils/constants.dart';

/// Repository for loading CJK character frequency data.
class FrequencyRepository {
  FrequencyData? _cache;

  bool get isLoaded => _cache != null;

  FrequencyData get data {
    if (_cache == null) {
      throw StateError('Frequency data not loaded. Call load() first.');
    }
    return _cache!;
  }

  Future<FrequencyData> load() async {
    if (_cache != null) return _cache!;

    final bytes = await rootBundle.load('assets/data/cjk_freq.msgpack');
    final raw = deserialize(bytes.buffer.asUint8List()) as Map;

    final frequencies = <String, Map<String, double>>{};
    for (final lang in DetectionConfig.languages) {
      frequencies[lang] = _parseMap(raw[lang]);
    }

    _cache = FrequencyData(frequencies);
    return _cache!;
  }

  Map<String, double> _parseMap(dynamic raw) {
    if (raw == null) return {};
    return (raw as Map).map(
      (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
    );
  }
}
