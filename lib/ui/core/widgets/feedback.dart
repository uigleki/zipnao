import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants.dart';

/// Show success message via SnackBar.
void showSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: FeedbackConfig.snackBarDuration,
      showCloseIcon: true,
    ),
  );
}

/// Show error message via MaterialBanner with copy option.
void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        leading: const Icon(Icons.error_outline),
        padding: const EdgeInsets.all(Spacing.lg),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              showSuccess(context, 'Copied to clipboard');
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
}
