import 'package:flutter/material.dart';

@immutable
class GoalModel {
  const GoalModel({
    required this.id,
    required this.categoryId,
    required this.title,
  });

  final String id;
  final String categoryId;
  final String title;
}
