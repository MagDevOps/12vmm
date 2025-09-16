import 'package:flutter/material.dart';

import '../models/activity_model.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({
    super.key,
    required this.activity,
    required this.isPlanned,
    required this.isDone,
    required this.onTogglePlanned,
    required this.onToggleDone,
    required this.onRemove,
  });

  final ActivityModel activity;
  final bool isPlanned;
  final bool isDone;
  final VoidCallback onTogglePlanned;
  final VoidCallback onToggleDone;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilterChip(
                        label: const Text('Planerad'),
                        selected: isPlanned,
                        onSelected: (_) => onTogglePlanned(),
                      ),
                      FilterChip(
                        label: const Text('Klar'),
                        selected: isDone,
                        onSelected: (_) => onToggleDone(),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Radera aktivitet',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
