import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:stacked/stacked.dart';

import 'package:tasker/models/task_model.dart';
import 'package:tasker/utils/task_categories.dart';

//Service class handling all data operations
class TaskService with ListenableServiceMixin {
  static const _fileName = 'tasks.json';
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  Timer? _syncTimer; // Timer to sync data periodically
  final logger = Logger();

  static const MethodChannel _channel =
      MethodChannel('com.example.tasker/reminders');

  TaskService() {
    listenToReactiveValues([_tasks]);
    loadTasks();
    _startSync();
  }

  void _startSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      loadTasks();
    });
  }

  //gets local path of the app
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //represents the local storage file by combining
  //local path and file name
  //this is where the data is stored
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  //ensures json file is created
  Future<void> _initializeFile() async {
    final file = await _localFile;
    if (!await file.exists()) {
      await file.writeAsString(json.encode([]));
    }
  }

  Future<void> loadTasks() async {
    try {
      await _initializeFile();
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      final newTasks = jsonList.map((json) => Task.fromJson(json)).toList();
      // Only update if tasks have changed to avoid unnecessary rebuilds
      if (!_areTasksEqual(_tasks, newTasks)) {
        _tasks = newTasks;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading tasks: $e');
      _tasks = [];
      notifyListeners();
    }
  }

  Future<void> createTask({
    required String title,
    required String note,
    required String time,
    required String date,
    required TaskCategories category,
    bool isCompleted = false,
  }) async {
    final newId = _tasks.isEmpty ? 1 : (_tasks.last.id ?? 0) + 1;
    final newTask = Task(
      id: newId,
      title: title,
      note: note,
      time: time,
      date: date,
      category: category,
      isCompleted: isCompleted,
    );
    print("--------------------------------------------------");
    print(newTask.toString());
    _tasks.add(newTask);
    await _saveTasks();
    if(!isCompleted){
      await _setAndroidReminder(newTask);
    } 
      notifyListeners();
  }

  Future<void> updateTask(
    int id, {
    String? title,
    String? note,
    String? time,
    String? date,
    TaskCategories? category,
    bool? isCompleted,
  }) async {
    final index = _tasks.indexWhere((task) => task.id == id); //find task by ID
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(
        title: title,
        note: note,
        time: time,
        date: date,
        category: category,
        isCompleted: isCompleted,
      );
      _tasks[index] = updatedTask;
      await _saveTasks();
      if(isCompleted == true){
        await _cancelAndroidReminder(id);
      }else if (time != null || date != null){
        await _setAndroidReminder(updatedTask);
      }

      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    await _cancelAndroidReminder(id);
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    try {
      final file = await _localFile;
      final jsonList = _tasks.map((task) => task.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
      print(await file.readAsString());
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Helper method to compare task lists
  bool _areTasksEqual(List<Task> oldTasks, List<Task> newTasks) {
    if (oldTasks.length != newTasks.length) return false;
    for (int i = 0; i < oldTasks.length; i++) {
      if (oldTasks[i].id != newTasks[i].id ||
          oldTasks[i].title != newTasks[i].title ||
          oldTasks[i].note != newTasks[i].note ||
          oldTasks[i].time != newTasks[i].time ||
          oldTasks[i].date != newTasks[i].date ||
          oldTasks[i].category != newTasks[i].category ||
          oldTasks[i].isCompleted != newTasks[i].isCompleted) {
        return false;
      }
    }
    return true;
  }

  // Method to set native Android reminder
  Future<void> _setAndroidReminder(Task task) async {
    try {
      // Combine date and time into a DateTime object
      final dateTimeString = '${task.date} ${task.time}';
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
      final dueDateTime = dateFormat.parse(dateTimeString);

      // Convert to milliseconds since epoch
      final dueTimeMillis = dueDateTime.millisecondsSinceEpoch;

      // Call the platform channel
      await _channel.invokeMethod('setReminder', {
        'id': task.id,
        'title': task.title,
        'dueTime': dueTimeMillis,
      });
      print('Reminder set for ${task.title} at $dueDateTime');
    } catch (e) {
      print('Error setting reminder: $e');
    }
  }

  //method to cancel native Android reminder
  Future<void> _cancelAndroidReminder(int id)async{
    try{
      await _channel.invokeMethod('cancelReminder', {'id': id});
      print('Reminder cancelled for task with ID: $id');
    }catch(e){
      logger.wtf('Error cancelling reminder: $e');
    }
  }

  // Clean up timer when service is disposed
  void dispose() {
    _syncTimer?.cancel();
  }
}
