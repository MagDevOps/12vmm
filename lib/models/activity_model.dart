import 'package:flutter/material.dart';

@immutable
class ActivityModel {
  ActivityModel({
    required this.id,
    required this.goalId,
    required this.title,
    Set<int>? plannedWeeks,
    Set<int>? completedWeeks,
  })  : plannedWeeks = plannedWeeks != null
            ? Set<int>.from(plannedWeeks)
            : <int>{},
        completedWeeks = completedWeeks != null
            ? Set<int>.from(completedWeeks)
            : <int>{};

  final String id;
  final String goalId;
  final String title;
  final Set<int> plannedWeeks;
  final Set<int> completedWeeks;

  ActivityModel copy() => ActivityModel(
        id: id,
        goalId: goalId,
        title: title,
        plannedWeeks: plannedWeeks,
        completedWeeks: completedWeeks,
      );
}
