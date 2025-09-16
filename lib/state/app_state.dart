import 'dart:collection';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'undo_action.dart';

@immutable
class CategoryProgress {
  const CategoryProgress({
    required this.planned,
    required this.completed,
  });

  final int planned;
  final int completed;

  double get percent => planned == 0 ? 0 : completed / planned;
}

@immutable
class GoalProgress {
  const GoalProgress({
    required this.planned,
    required this.completed,
  });

  final int planned;
  final int completed;

  double get percent => planned == 0 ? 0 : completed / planned;
}

class AppState extends ChangeNotifier {
  AppState() {
    _seed();
  }

  final List<CategoryModel> _categories = <CategoryModel>[];
  final List<GoalModel> _goals = <GoalModel>[];
  final List<ActivityModel> _activities = <ActivityModel>[];

  int _currentWeek = 1;

  int get currentWeek => _currentWeek;

  UnmodifiableListView<CategoryModel> get categories =>
      UnmodifiableListView<CategoryModel>(_categories);

  CategoryModel? categoryById(String id) =>
      _categories.firstWhereOrNull((category) => category.id == id);

  GoalModel? goalById(String id) =>
      _goals.firstWhereOrNull((goal) => goal.id == id);

  List<GoalModel> goalsForCategory(String categoryId) => _goals
      .where((goal) => goal.categoryId == categoryId)
      .toList(growable: false);

  List<ActivityModel> activitiesForGoal(String goalId) => _activities
      .where((activity) => activity.goalId == goalId)
      .toList(growable: false);

  CategoryProgress progressForCategory(String categoryId) {
    final goalIds = _goals
        .where((goal) => goal.categoryId == categoryId)
        .map((goal) => goal.id)
        .toSet();
    if (goalIds.isEmpty) {
      return const CategoryProgress(planned: 0, completed: 0);
    }
    var planned = 0;
    var completed = 0;
    for (final activity in _activities) {
      if (!goalIds.contains(activity.goalId)) {
        continue;
      }
      if (activity.plannedWeeks.contains(_currentWeek)) {
        planned += 1;
      }
      if (activity.completedWeeks.contains(_currentWeek)) {
        completed += 1;
      }
    }
    return CategoryProgress(planned: planned, completed: completed);
  }

  GoalProgress progressForGoal(String goalId) {
    final activities = activitiesForGoal(goalId);
    if (activities.isEmpty) {
      return const GoalProgress(planned: 0, completed: 0);
    }
    var planned = 0;
    var completed = 0;
    for (final activity in activities) {
      if (activity.plannedWeeks.contains(_currentWeek)) {
        planned += 1;
      }
      if (activity.completedWeeks.contains(_currentWeek)) {
        completed += 1;
      }
    }
    return GoalProgress(planned: planned, completed: completed);
  }

  void setCurrentWeek(int week) {
    final clamped = math.max(1, math.min(12, week));
    if (clamped == _currentWeek) {
      return;
    }
    _currentWeek = clamped;
    notifyListeners();
  }

  void incrementWeek() => setCurrentWeek(_currentWeek + 1);

  void decrementWeek() => setCurrentWeek(_currentWeek - 1);

  void toggleActivityPlanned(String activityId) {
    final activity =
        _activities.firstWhereOrNull((item) => item.id == activityId);
    if (activity == null) {
      return;
    }
    if (activity.plannedWeeks.contains(_currentWeek)) {
      activity.plannedWeeks.remove(_currentWeek);
      activity.completedWeeks.remove(_currentWeek);
    } else {
      activity.plannedWeeks.add(_currentWeek);
    }
    notifyListeners();
  }

  void toggleActivityDone(String activityId) {
    final activity =
        _activities.firstWhereOrNull((item) => item.id == activityId);
    if (activity == null) {
      return;
    }
    if (activity.completedWeeks.contains(_currentWeek)) {
      activity.completedWeeks.remove(_currentWeek);
    } else {
      activity.plannedWeeks.add(_currentWeek);
      activity.completedWeeks.add(_currentWeek);
    }
    notifyListeners();
  }

  GoalModel? addGoal(String categoryId, String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final goal = GoalModel(
      id: _generateId('goal'),
      categoryId: categoryId,
      title: trimmed,
    );
    _goals.add(goal);
    notifyListeners();
    return goal;
  }

  ActivityModel? addActivity(String goalId, String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final activity = ActivityModel(
      id: _generateId('act'),
      goalId: goalId,
      title: trimmed,
    );
    _activities.add(activity);
    notifyListeners();
    return activity;
  }

  UndoAction? removeGoal(String goalId) {
    final index = _goals.indexWhere((goal) => goal.id == goalId);
    if (index == -1) {
      return null;
    }
    final goal = _goals.removeAt(index);
    final removedActivities = _activities
        .where((activity) => activity.goalId == goalId)
        .map((activity) => activity.copy())
        .toList(growable: false);
    _activities.removeWhere((activity) => activity.goalId == goalId);
    notifyListeners();
    return UndoAction.goal(
      goal: goal,
      goalIndex: index,
      activities: removedActivities,
    );
  }

  UndoAction? removeActivity(String activityId) {
    final index =
        _activities.indexWhere((activity) => activity.id == activityId);
    if (index == -1) {
      return null;
    }
    final removed = _activities.removeAt(index);
    notifyListeners();
    return UndoAction.activity(
      activity: removed.copy(),
      activityIndex: index,
    );
  }

  void undo(UndoAction? action) {
    if (action == null) {
      return;
    }
    switch (action.type) {
      case UndoType.goal:
        final goal = action.goal;
        if (goal == null) {
          return;
        }
        if (_goals.any((existing) => existing.id == goal.id)) {
          return;
        }
        final index = action.goalIndex ?? _goals.length;
        final safeIndex = math.min(math.max(index, 0), _goals.length);
        _goals.insert(safeIndex, goal);
        for (final activity in action.activities) {
          if (_activities.any((existing) => existing.id == activity.id)) {
            continue;
          }
          _activities.add(activity.copy());
        }
        notifyListeners();
        break;
      case UndoType.activity:
        final activity = action.activity;
        if (activity == null) {
          return;
        }
        if (_activities.any((existing) => existing.id == activity.id)) {
          return;
        }
        final index = action.activityIndex ?? _activities.length;
        final safeIndex = math.min(math.max(index, 0), _activities.length);
        _activities.insert(safeIndex, activity.copy());
        notifyListeners();
        break;
    }
  }

  String _generateId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  void _seed() {
    _categories.addAll(const <CategoryModel>[
      CategoryModel(
        id: 'cat-health',
        name: 'Hälsa',
        color: Color(0xFFB9FBC0),
      ),
      CategoryModel(
        id: 'cat-family',
        name: 'Familj',
        color: Color(0xFFFFE0B2),
      ),
      CategoryModel(
        id: 'cat-career',
        name: 'Karriär',
        color: Color(0xFFD0BCFF),
      ),
    ]);

    _goals.addAll(const <GoalModel>[
      GoalModel(
        id: 'goal-run',
        categoryId: 'cat-health',
        title: 'Springa 5 km utan stopp',
      ),
      GoalModel(
        id: 'goal-strength',
        categoryId: 'cat-health',
        title: 'Bygga vardagsstyrka',
      ),
      GoalModel(
        id: 'goal-family',
        categoryId: 'cat-family',
        title: 'Familjekväll varje vecka',
      ),
      GoalModel(
        id: 'goal-learning',
        categoryId: 'cat-career',
        title: 'Skapa demo-app i Flutter',
      ),
    ]);

    _activities.addAll(<ActivityModel>[
      ActivityModel(
        id: 'act-intervals',
        goalId: 'goal-run',
        title: 'Intervaller 20 min',
        plannedWeeks: {1, 2, 3},
        completedWeeks: {1},
      ),
      ActivityModel(
        id: 'act-longrun',
        goalId: 'goal-run',
        title: 'Långpass söndag',
        plannedWeeks: {1, 2},
        completedWeeks: {1},
      ),
      ActivityModel(
        id: 'act-strength-home',
        goalId: 'goal-strength',
        title: 'Hemma styrka 30 min',
        plannedWeeks: {1, 2, 3},
        completedWeeks: {1},
      ),
      ActivityModel(
        id: 'act-mobility',
        goalId: 'goal-strength',
        title: 'Rörlighet & stretch',
        plannedWeeks: {1, 2},
      ),
      ActivityModel(
        id: 'act-family-night',
        goalId: 'goal-family',
        title: 'Fredagsmys utan skärmar',
        plannedWeeks: {1, 2, 3},
        completedWeeks: {1},
      ),
      ActivityModel(
        id: 'act-walk',
        goalId: 'goal-family',
        title: 'Söndagspromenad',
        plannedWeeks: {1, 2},
      ),
      ActivityModel(
        id: 'act-learning',
        goalId: 'goal-learning',
        title: 'Animation-kurs 45 min',
        plannedWeeks: {1},
      ),
    ]);
  }
}
