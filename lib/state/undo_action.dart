import 'package:flutter/material.dart';

import '../models/models.dart';

enum UndoType { goal, activity }

@immutable
class UndoAction {
  const UndoAction.goal({
    required this.goal,
    required this.goalIndex,
    required this.activities,
  })  : type = UndoType.goal,
        activity = null,
        activityIndex = null;

  const UndoAction.activity({
    required this.activity,
    required this.activityIndex,
  })  : type = UndoType.activity,
        goal = null,
        goalIndex = null,
        activities = const <ActivityModel>[];

  final UndoType type;
  final GoalModel? goal;
  final int? goalIndex;
  final List<ActivityModel> activities;
  final ActivityModel? activity;
  final int? activityIndex;
}
