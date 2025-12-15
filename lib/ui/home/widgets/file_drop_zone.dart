import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/file_info.dart';
import '../../../utils/constants.dart';
import '../home_viewmodel.dart';

/// Drop zone for file selection (also responds to global drops).
class FileDropZone extends StatefulWidget {
  const FileDropZone({super.key});

  @override
  State<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = context.watch<HomeViewModel>();

    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) => _handleDrop(details, vm),
      child: InkWell(
        onTap: () => _pickFile(vm),
        borderRadius: BorderRadius.circular(BorderConfig.radiusMedium),
        child: AnimatedContainer(
          duration: AnimationDuration.fast,
          height: DropZoneConfig.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isDragging ? colorScheme.primary : colorScheme.outline,
              width: _isDragging
                  ? BorderConfig.widthThick
                  : BorderConfig.widthDefault,
            ),
            borderRadius: BorderRadius.circular(BorderConfig.radiusMedium),
            color: _isDragging
                ? colorScheme.primary.withValues(alpha: 0.08)
                : null,
          ),
          child: Center(
            child: vm.hasFile
                ? _SelectedFileContent(
                    fileInfo: vm.fileInfo!,
                    onClear: vm.clearFile,
                  )
                : _EmptyContent(isDragging: _isDragging),
          ),
        ),
      ),
    );
  }

  void _handleDrop(DropDoneDetails details, HomeViewModel vm) {
    setState(() => _isDragging = false);
    if (details.files.isEmpty) return;

    final path = details.files.first.path;
    if (FileInfo.isSupportedPath(path)) {
      vm.selectFile(path);
    } else {
      _showError();
    }
  }

  Future<void> _pickFile(HomeViewModel vm) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'txt'],
    );

    if (result != null && result.files.single.path != null) {
      vm.selectFile(result.files.single.path!);
    }
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unsupported file type. Please use .zip or .txt'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({required this.isDragging});

  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDragging
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.upload_file, size: IconSize.large, color: color),
        const SizedBox(height: Spacing.sm),
        Text(
          isDragging ? 'Drop to select' : 'Drop file here or click to select',
          style: TextStyle(
            color: color,
            fontWeight: isDragging ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          '.zip, .txt',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SelectedFileContent extends StatelessWidget {
  const _SelectedFileContent({required this.fileInfo, required this.onClear});

  final FileInfo fileInfo;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          fileInfo.isZip ? Icons.folder_zip : Icons.description,
          size: IconSize.medium,
          color: colorScheme.primary,
        ),
        const SizedBox(width: Spacing.md),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileInfo.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                fileInfo.directory,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.md),
        IconButton(
          onPressed: onClear,
          icon: const Icon(Icons.close),
          tooltip: 'Clear selection',
        ),
      ],
    );
  }
}
