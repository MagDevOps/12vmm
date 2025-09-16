import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../state/undo_action.dart';
import '../widgets/empty_state.dart';
import 'activity_list_screen.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final category = state.categoryById(categoryId);
        if (category == null) {
          return const Scaffold(
            body: Center(child: Text('Kategori saknas')),
          );
        }
        final goals = state.goalsForCategory(categoryId);
        return Scaffold(
          appBar: AppBar(
            title: Text(category.name),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: goals.isEmpty
                  ? EmptyState(
                      key: const ValueKey('goal-empty'),
                      icon: Icons.flag_outlined,
                      title: 'Inga mål ännu',
                      subtitle:
                          'Skapa ett mål för den här kategorin eller välj ett exempel här nedanför.',
                      suggestions: const <String>[
                        'Starta morgonrutin',
                        '80% veckoträning',
                        'Mer energi till familjen',
                      ],
                      onSuggestionSelected: (suggestion) {
                        state.addGoal(categoryId, suggestion);
                      },
                    )
                  : ListView.separated(
                      key: ValueKey<int>(goals.length),
                      itemCount: goals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        final progress = state.progressForGoal(goal.id);
                        final ratioLabel = progress.planned == 0
                            ? 'Ingen aktivitet planerad'
                            : '${progress.completed}/${progress.planned} klara denna vecka';
                        return Card(
                          key: ValueKey<String>(goal.id),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            title: Text(
                              goal.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              ratioLabel,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  tooltip: 'Radera mål',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      _removeGoal(context, state, goal),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () => _openActivities(context, goal),
                          ),
                        );
                      },
                    ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showCreateGoalDialog(context),
            label: const Text('Nytt mål'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<void> _showCreateGoalDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lägg till mål'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Måltitel',
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
      final state = context.read<AppState>();
      state.addGoal(categoryId, result);
    }
  }

  void _openActivities(BuildContext context, GoalModel goal) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityListScreen(goalId: goal.id),
      ),
    );
  }

  void _removeGoal(BuildContext context, AppState state, GoalModel goal) {
    final undo = state.removeGoal(goal.id);
    if (undo == null) {
      return;
    }
    _showUndoSnackBar(
      context,
      message: '"${goal.title}" borttagen',
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
