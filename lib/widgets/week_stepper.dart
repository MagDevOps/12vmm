import 'package:flutter/material.dart';

class WeekStepper extends StatelessWidget {
  const WeekStepper({
    super.key,
    required this.week,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int week;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Föregående vecka',
            icon: const Icon(Icons.chevron_left),
            onPressed: week > 1 ? onDecrement : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Vecka $week',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Nästa vecka',
            icon: const Icon(Icons.chevron_right),
            onPressed: week < 12 ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}
