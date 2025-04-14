import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tasker/app/app.locator.dart';
import 'package:tasker/models/task_model.dart';
import 'package:tasker/service/task_service.dart';
import 'package:tasker/utils/task_categories.dart';

class TaskSummaryViewModel extends BaseViewModel {
  final TaskService _taskService = locator<TaskService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<Task> get tasks => _taskService.tasks;

  int get totalTasks => tasks.length;

  double get completedPercentage {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((task) => task.isCompleted).length;
    return (completedCount / tasks.length) * 100;
  }

  int get highPriorityCount =>
      tasks.where((task) => task.category == TaskCategories.high).length;

  void navigateBack() {
    _navigationService.back();
  }
}
