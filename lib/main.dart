import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/window_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowInitializer.initialize();
  runApp(const App());
}
