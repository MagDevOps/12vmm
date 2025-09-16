import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../state/undo_action.dart';
import '../widgets/activity_row.dart';
import '../widgets/empty_state.dart';
import '../widgets/week_stepper.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({
    super.key,
    required this.goalId,
  });

  final String goalId;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final goal = state.goalById(goalId);
        if (goal == null) {
          return const Scaffold(
            body: Center(child: Text('Målet hittades inte')), 
          );
        }
        final activities = state.activitiesForGoal(goalId);
        final currentWeek = state.currentWeek;
        return Scaffold(
          appBar: AppBar(
            title: Text(goal.title),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Veckoplan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Markera vad som är planerat och klart den här veckan.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    WeekStepper(
                      week: currentWeek,
                      onDecrement: state.decrementWeek,
                      onIncrement: state.incrementWeek,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: activities.isEmpty
                      ? EmptyState(
                          key: const ValueKey('activity-empty'),
                          icon: Icons.checklist_rtl,
                          title: 'Inga aktiviteter planerade',
                          subtitle:
                              'Tips! Välj ett exempel nedan eller skapa din egen aktivitet. Du kan alltid lägga till fler senare.',
                          suggestions: const <String>[
                            '30 min bokläsning med barnen',
                            'Kvällspromenad tisdag',
                            'Planera veckans måltider',
                          ],
                          onSuggestionSelected: (suggestion) {
                            state.addActivity(goalId, suggestion);
                          },
                        )
                      : ListView.separated(
                          key: ValueKey<int>(activities.length),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            final isPlanned =
                                activity.plannedWeeks.contains(currentWeek);
                            final isDone =
                                activity.completedWeeks.contains(currentWeek);
                            return ActivityRow(
                              key: ValueKey<String>(activity.id),
                              activity: activity,
                              isPlanned: isPlanned,
                              isDone: isDone,
                              onTogglePlanned: () =>
                                  state.toggleActivityPlanned(activity.id),
                              onToggleDone: () =>
                                  state.toggleActivityDone(activity.id),
                              onRemove: () =>
                                  _removeActivity(context, state, activity),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemCount: activities.length,
                        ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showCreateActivityDialog(context),
            label: const Text('Ny aktivitet'),
            icon: const Icon(Icons.add_task),
          ),
        );
      },
    );
  }

  Future<void> _showCreateActivityDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lägg till aktivitet'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Aktivitet',
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Avbryt', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Spara'),
          ),
        ],
      ),
    );
    if (result != null) {
      context.read<AppState>().addActivity(goalId, result);
    }
  }

  void _removeActivity(
    BuildContext context,
    AppState state,
    ActivityModel activity,
  ) {
    final undo = state.removeActivity(activity.id);
    if (undo == null) {
      return;
    }
    _showUndoSnackBar(
      context,
      message: '"${activity.title}" borttagen',
      undo: undo,
    );
  }

  void _showUndoSnackBar(
    BuildContext context, {
    required String message,
    required UndoAction undo,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final state = context.read<AppState>();
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Ångra',
            onPressed: () => state.undo(undo),
          ),
        ),
      );
  }
}
