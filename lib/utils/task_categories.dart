import 'package:flutter/material.dart';

enum TaskCategories {
  low(Icons.alarm_off_outlined, Colors.green),
  medium(Icons.alarm_on_outlined, Colors.yellow),
  high(Icons.alarm_add, Colors.red);

  static TaskCategories stringToCategory(String name) {
    try {
      return TaskCategories.values
          .firstWhere((category) => category.name == name);
    } catch (e) {
      return TaskCategories.low;
    }
  }

  final IconData icon;
  final Color color;
  const TaskCategories(this.icon, this.color);
}
