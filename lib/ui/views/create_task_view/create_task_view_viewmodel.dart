import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tasker/app/app.dialogs.dart';
import 'package:tasker/app/app.locator.dart';
import 'package:tasker/service/task_service.dart';
import 'package:tasker/utils/task_categories.dart';

class CreateTaskViewViewModel extends BaseViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  TaskCategories _selectedCategory = TaskCategories.low;

  final TaskService _taskService = locator<TaskService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  TaskCategories get selectedCategory => _selectedCategory;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  String get formatedTime => _formatTime(_selectedTime);

  CreateTaskViewViewModel() {
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  void updateCategory(TaskCategories category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      _selectedDate = pickedDate;
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      _selectedTime = pickedTime;
      notifyListeners();
    }
  }

  //helper method to format TimeOfDay to String
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat.jm().format(dt);
  }

  Future<void> saveTask() async {
    setBusy(true);
    try {
      if (titleController.text.trim().isEmpty) {
        await _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Please enter a title',
        );
        setBusy(false);
        return;
      }
      final timeString =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);

      await _taskService.createTask(
        title: titleController.text,
        note: noteController.text,
        time: timeString,
        date: dateString,
        category: _selectedCategory,
        isCompleted: false,
      );
      notifyListeners();
      _navigationService.back(result: true);
    } catch (e) {
      print('Error saving task: $e');
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
