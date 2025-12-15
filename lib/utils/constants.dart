import 'dart:ui';

/// Application metadata.
abstract class AppConfig {
  static const name = 'zipnao';
}

/// Window configuration.
abstract class WindowConfig {
  static const minSize = Size(480, 560);
}

/// Encoding detection settings.
abstract class DetectionConfig {
  static const maxBytes = 10000;
  static const languages = ['zh', 'ja', 'ko'];
}

/// Encoding table layout.
abstract class TableConfig {
  static const encodingColumnWidth = 90.0;
  static const confidenceColumnWidth = 140.0;
  static const minWidth = 300.0;
}

/// Confidence indicator settings.
abstract class ConfidenceConfig {
  static const highThreshold = 0.9;
  static const mediumThreshold = 0.6;
  static const lowThreshold = 0.3;
  static const percentageLabelWidth = 45.0;
  static const barHeight = 6.0;
}

/// Feedback timing.
abstract class FeedbackConfig {
  static const snackBarDuration = Duration(seconds: 3);
}

/// Drop zone layout.
abstract class DropZoneConfig {
  static const height = 120.0;
}

/// Material Design 3 spacing scale (4dp grid).
abstract class Spacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Icon sizes.
abstract class IconSize {
  static const small = 20.0;
  static const medium = 32.0;
  static const large = 48.0;
}

/// Border configuration.
abstract class BorderConfig {
  static const radiusSmall = 2.0;
  static const radiusMedium = 12.0;
  static const radiusLarge = 16.0;
  static const widthDefault = 2.0;
  static const widthThick = 3.0;
}

/// Animation durations.
abstract class AnimationDuration {
  static const fast = Duration(milliseconds: 150);
  static const dataReveal = Duration(milliseconds: 800);
}

// ============================================================
// Encoding detection utilities
// ============================================================

/// Pattern to match characters unhelpful for CJK detection.
final _nonCjkPattern = RegExp(r'[a-zA-Z0-9\s\p{P}]', unicode: true);

/// Filter text for CJK analysis by removing ASCII noise.
String filterForCjk(String text) => text.replaceAll(_nonCjkPattern, '');
