import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/encoding_result.dart';
import '../../../utils/constants.dart';
import '../home_viewmodel.dart';

/// Table displaying encoding detection results.
class EncodingTable extends StatelessWidget {
  const EncodingTable({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: vm.results.isEmpty
          ? _EmptyState(hasFile: vm.hasFile, isLoading: vm.isLoading)
          : _ResultsTable(results: vm.results, selectedIndex: vm.selectedIndex),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFile, required this.isLoading});

  final bool hasFile;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, message) = _content;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconSize.large, color: colorScheme.outline),
          const SizedBox(height: Spacing.md),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String) get _content {
    if (isLoading) {
      return (Icons.hourglass_empty, 'Detecting encoding...');
    }
    if (hasFile) {
      return (Icons.warning_amber, 'No encoding results');
    }
    return (Icons.table_chart_outlined, 'Select a file to detect encoding');
  }
}

class _ResultsTable extends StatelessWidget {
  const _ResultsTable({required this.results, required this.selectedIndex});

  final List<EncodingResult> results;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = context.read<HomeViewModel>();

    final maxScore = results
        .map((r) => r.score)
        .reduce((a, b) => a > b ? a : b);

    return DataTable2(
      columnSpacing: Spacing.lg,
      horizontalMargin: Spacing.lg,
      showCheckboxColumn: false,
      minWidth: TableConfig.minWidth,
      columns: const [
        DataColumn2(
          label: Text('Encoding'),
          fixedWidth: TableConfig.encodingColumnWidth,
        ),
        DataColumn2(
          label: Text('Confidence'),
          fixedWidth: TableConfig.confidenceColumnWidth,
        ),
        DataColumn2(label: Text('Preview')),
      ],
      rows: List.generate(results.length, (index) {
        final result = results[index];
        final isSelected = index == selectedIndex;

        return DataRow2(
          selected: isSelected,
          color: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primaryContainer;
            }
            return null;
          }),
          onTap: () => vm.selectEncoding(index),
          cells: [
            DataCell(Text(result.encoding.label)),
            DataCell(
              _ConfidenceIndicator(score: result.score, maxScore: maxScore),
            ),
            DataCell(Text(result.preview, overflow: TextOverflow.ellipsis)),
          ],
        );
      }),
    );
  }
}

class _ConfidenceIndicator extends StatelessWidget {
  const _ConfidenceIndicator({required this.score, required this.maxScore});

  final double score;
  final double maxScore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ratio = maxScore > 0 ? score / maxScore : 0.0;
    final percentage = (ratio * 100).round();
    final barColor = _getConfidenceColor(ratio);

    return Row(
      children: [
        SizedBox(
          width: ConfidenceConfig.percentageLabelWidth,
          child: TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: percentage),
            duration: AnimationDuration.dataReveal,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                '$value%',
                style: TextStyle(
                  fontWeight: percentage == 100
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: percentage == 100 ? barColor : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(BorderConfig.radiusSmall),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: AnimationDuration.dataReveal,
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(barColor),
                  minHeight: ConfidenceConfig.barHeight,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double ratio) {
    if (ratio >= ConfidenceConfig.highThreshold) {
      return Colors.green;
    }
    if (ratio >= ConfidenceConfig.mediumThreshold) {
      return Colors.lightGreen;
    }
    if (ratio >= ConfidenceConfig.lowThreshold) {
      return Colors.amber;
    }
    return Colors.grey;
  }
}
