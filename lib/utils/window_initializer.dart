import 'package:window_manager/window_manager.dart';

import 'constants.dart';

/// Initialize window settings for desktop platforms.
abstract class WindowInitializer {
  static Future<void> initialize() async {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(WindowConfig.minSize);
    await windowManager.setTitle(AppConfig.name);
  }
}
