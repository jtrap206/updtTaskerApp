// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:tasker/utils/task_categories.dart';
import 'package:tasker/utils/task_keys.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String note;
  final String time;
  final String date;
  final TaskCategories category;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.note,
    required this.time,
    required this.date,
    required this.category,
    required this.isCompleted,
  });

  @override
  List<Object> get props {
    return [
      id ?? 0,
      title,
      note,
      time,
      date,
      isCompleted,
    ];
  }

  //converts task into JSON Map
  //used to save task in database
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      TaskKeys.id: id,
      TaskKeys.title: title,
      TaskKeys.note: note,
      TaskKeys.time: time,
      TaskKeys.date: date,
      TaskKeys.category: category.name,
      TaskKeys.isCompleted: isCompleted ? 1 : 0,
    };
  }

  //converts JSON Map into Task
  //used to get task from database
  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      id: map[TaskKeys.id],
      title: map[TaskKeys.title],
      note: map[TaskKeys.note],
      time: map[TaskKeys.time],
      date: map[TaskKeys.date],
      category: TaskCategories.stringToCategory(map[TaskKeys.category]),
      isCompleted: map[TaskKeys.isCompleted] == 1 ? true : false,
    );
  }

  //creates a new Task object that is a modification of orriginal task
  Task copyWith({
    int? id,
    String? title,
    String? note,
    String? time,
    String? date,
    TaskCategories? category,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      time: time ?? this.time,
      date: date ?? this.date,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
