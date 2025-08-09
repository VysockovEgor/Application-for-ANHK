import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../pages/tasks_page/task_data.dart';

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(_loadInitial());

  static List<Task> _loadInitial() {
    final Map<String, dynamic> tasksMap = json.decode(tasksJson);
    List<Task> tasks = [];

    tasksMap.forEach((practiceName, practiceData) {
      (practiceData as Map<String, dynamic>).forEach((originalKey, taskData) {
        tasks.add(Task.fromJson(
            taskData as Map<String, dynamic>, practiceName, originalKey));
      });
    });

    return tasks;
  }

  void markAsSolved(String originalKey, String practiceName) {
    state = [
      for (final task in state)
        if (task.originalKey == originalKey &&
            task.practiceName == practiceName)
          task.copyWith(isSolved: true)
        else
          task
    ];
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
