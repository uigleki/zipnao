import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../home_viewmodel.dart';

/// Button to execute extract/fix action.
class ProcessButton extends StatelessWidget {
  const ProcessButton({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) {
      return FilledButton.tonal(
        onPressed: null,
        child: SizedBox(
          height: IconSize.small,
          width: IconSize.small,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: vm.canProcess ? vm.process : null,
      icon: Icon(vm.isZip ? Icons.unarchive : Icons.build),
      label: Text(vm.actionLabel),
    );
  }
}
