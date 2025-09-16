import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/category_card.dart';
import 'goal_list_screen.dart';

class CategoryOverviewScreen extends StatelessWidget {
  const CategoryOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('12-veckors fokus'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: Consumer<AppState>(
              builder: (context, state, _) => Chip(
                backgroundColor: theme.colorScheme.primaryContainer,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                label: Text('Vecka ${state.currentWeek}'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, state, _) {
            final categories = state.categories;
            if (categories.isEmpty) {
              return const Center(
                child: Text('Lägg till en kategori för att komma igång'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final category = categories[index];
                final progress = state.progressForCategory(category.id);
                return CategoryCard(
                  key: ValueKey<String>(category.id),
                  category: category,
                  progress: progress,
                  onTap: () => _openGoals(context, category),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _openGoals(BuildContext context, CategoryModel category) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GoalListScreen(categoryId: category.id),
      ),
    );
  }
}
