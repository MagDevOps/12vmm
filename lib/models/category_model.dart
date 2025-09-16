import 'package:flutter/material.dart';

@immutable
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
  });

  final String id;
  final String name;
  final Color color;
}
