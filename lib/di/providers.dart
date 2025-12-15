import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/file_repository.dart';
import '../data/repositories/frequency_repository.dart';
import '../data/services/text_converter.dart';
import '../data/services/zip_extractor.dart';
import '../ui/home/home_viewmodel.dart';

/// Dependency injection configuration.
class AppProviders {
  AppProviders._();

  static Widget wrap(Widget child) {
    return MultiProvider(
      providers: [
        // Repositories
        Provider<FrequencyRepository>(create: (_) => FrequencyRepository()),
        Provider<FileRepository>(create: (_) => const FileRepository()),

        // Services
        Provider<ZipExtractor>(create: (_) => const ZipExtractor()),
        Provider<TextConverter>(create: (_) => const TextConverter()),

        // ViewModel
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            frequencyRepository: context.read<FrequencyRepository>(),
            fileRepository: context.read<FileRepository>(),
            zipExtractor: context.read<ZipExtractor>(),
            textConverter: context.read<TextConverter>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
