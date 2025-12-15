import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../home_viewmodel.dart';

/// Field for displaying and editing output path.
class OutputPathField extends StatefulWidget {
  const OutputPathField({super.key});

  @override
  State<OutputPathField> createState() => _OutputPathFieldState();
}

class _OutputPathFieldState extends State<OutputPathField> {
  late final HomeViewModel _vm;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _vm = context.read<HomeViewModel>();
    _controller = TextEditingController(text: _vm.outputPath);
    _vm.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _vm.removeListener(_onViewModelChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Sync controller when ViewModel changes externally (file selection, browse).
  void _onViewModelChanged() {
    if (_controller.text != _vm.outputPath) {
      _controller.text = _vm.outputPath;
    }
  }

  /// Sync ViewModel when user types.
  void _onTextChanged(String value) {
    _vm.setOutputPath(value);
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = context.select<HomeViewModel, bool>((vm) => vm.hasFile);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: hasFile,
            onChanged: _onTextChanged,
            decoration: const InputDecoration(
              labelText: 'Output path',
              hintText: 'Select a file first',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: Spacing.md),
        FilledButton.tonalIcon(
          onPressed: hasFile ? _selectPath : null,
          icon: const Icon(Icons.folder_open),
          label: const Text('Browse'),
        ),
      ],
    );
  }

  Future<void> _selectPath() async {
    if (_vm.isZip) {
      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select output folder',
        initialDirectory: _vm.fileInfo?.directory,
      );
      if (result != null) _vm.setOutputPath(result);
    } else {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save fixed file as',
        fileName: '${_vm.fileInfo?.nameWithoutExtension}_fixed.txt',
        initialDirectory: _vm.fileInfo?.directory,
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      if (result != null) _vm.setOutputPath(result);
    }
  }
}
