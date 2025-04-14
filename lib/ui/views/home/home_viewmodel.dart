import 'package:tasker/app/app.bottomsheets.dart';
import 'package:tasker/app/app.dialogs.dart';
import 'package:tasker/app/app.locator.dart';
import 'package:tasker/app/app.router.dart';
import 'package:tasker/models/task_model.dart';
import 'package:tasker/service/task_service.dart';
import 'package:tasker/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tasker/utils/task_categories.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();
  final TaskService _taskService;

  HomeViewModel(this._taskService);

  List<Task> get tasks => _taskService.tasks;

  Future<void> initialise() async {
    setBusy(true);
    await _taskService.loadTasks();
    setBusy(false);
  }

  Future<void> addTask({
    required String title,
    required String note,
    required String time,
    required String date,
    required TaskCategories category,
  }) async {
    await _taskService.createTask(
      title: title,
      note: note,
      time: time,
      date: date,
      category: category,
    );
  }

  //update
  Future<void> updateTask(
    int id, {
    String? title,
    String? note,
    String? time,
    String? date,
    TaskCategories? category,
    bool? isCompleted,
  }) async {
    await _taskService.updateTask(
      id,
      title: title,
      note: note,
      time: time,
      date: date,
      category: category,
      isCompleted: isCompleted,
    );
    notifyListeners();
  }

  //delete
  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    notifyListeners();
  }

  Future<bool?> navigateToCreateTask() async {
    final result = await _navigationService.navigateToCreateTaskViewView();
    return result as bool?;
  }

  Future<void> navigateToTaskSummary() async {
    await _navigationService
        .navigateToTaskSummaryView(); 
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: '',
      description: '',
    );
  }

  Future<void> reloadTasks() async {
    await _taskService.loadTasks();
    notifyListeners();
  }

  //show delete confirmation dialog
  Future<void> showDeleteConfirmation(int taskId) async {
    final response = await _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Confirm Delete',
      description: 'Are you sure you want to delete this task?',
      customData: {'isDeleteConfirmation': true}, // Flag to show Yes/No buttons
    );

    if (response != null && response.confirmed) {
      await deleteTask(taskId); // Delete the task if "Yes" is clicked
      notifyListeners(); // Update UI after deletion
    }
    // If "No" is clicked or dialog is dismissed, do nothing (returns to home screen)
  }

  //method for summary data
  int get totalTasks => tasks.length;

  double get completePercentage {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((task) => task.isCompleted).length;
    return (completedCount / tasks.length) * 100;
  }

  int get highPriorityCount {
    return tasks.where((task) => task.category == TaskCategories.high).length;
  }
}
