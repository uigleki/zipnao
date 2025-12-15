import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../core/widgets/feedback.dart';
import 'home_viewmodel.dart';
import 'widgets/encoding_table.dart';
import 'widgets/file_drop_zone.dart';
import 'widgets/output_path_field.dart';
import 'widgets/process_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<HomeViewModel>();
    _vm.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _vm.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_vm.error != null) {
      showError(context, _vm.error!);
      _vm.clearError();
    }

    if (_vm.successMessage != null) {
      showSuccess(context, _vm.successMessage!);
      _vm.clearSuccessMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConfig.name)),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FileDropZone(),
            const SizedBox(height: Spacing.lg),
            const OutputPathField(),
            const SizedBox(height: Spacing.lg),
            const Expanded(child: EncodingTable()),
            const SizedBox(height: Spacing.lg),
            const ProcessButton(),
          ],
        ),
      ),
    );
  }
}
