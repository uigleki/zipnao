import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/file_info.dart';
import '../../../utils/constants.dart';
import '../../home/home_viewmodel.dart';

/// Global drop target that wraps the entire app.
/// Shows overlay when dragging files over the window.
class AppDropTarget extends StatefulWidget {
  const AppDropTarget({super.key, required this.child});

  final Widget child;

  @override
  State<AppDropTarget> createState() => _AppDropTargetState();
}

class _AppDropTargetState extends State<AppDropTarget> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: _handleDrop,
      child: Stack(
        children: [widget.child, if (_isDragging) _buildOverlay(context)],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: colorScheme.primary.withValues(alpha: 0.08),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xxl,
                vertical: Spacing.xl,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(BorderConfig.radiusLarge),
                border: Border.all(
                  color: colorScheme.primary,
                  width: BorderConfig.widthDefault,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_download,
                    size: IconSize.large,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Drop to open',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDrop(DropDoneDetails details) {
    setState(() => _isDragging = false);

    if (details.files.isEmpty) return;

    final path = details.files.first.path;
    if (FileInfo.isSupportedPath(path)) {
      context.read<HomeViewModel>().selectFile(path);
    } else {
      _showUnsupportedError();
    }
  }

  void _showUnsupportedError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unsupported file type. Please use .zip or .txt'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
