import 'package:flutter/material.dart';

import 'di/providers.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/core/widgets/app_drop_target.dart';
import 'ui/home/home_screen.dart';
import 'utils/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrap(
      MaterialApp(
        title: AppConfig.name,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const AppDropTarget(child: HomeScreen()),
      ),
    );
  }
}
