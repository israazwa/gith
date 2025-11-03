import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

/// Task provider untuk state management
/// Manages task list, CRUD operations, loading states
class TaskProvider extends ChangeNotifier {
  // Private task list
  List<TaskModel> _tasks = [];

  // Loading state
  bool _isLoading = false;

  // Error message
  String? _errorMessage;

  // Public getters
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get taskCount => _tasks.length;

  /// Initialize dengan dummy data
  TaskProvider() {
    _tasks = TaskModel.getDummyTasks();
  }

  /// Add new task
  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskCategory category,
    required TaskPriority priority,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Create new task
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        dueDate: dueDate,
        category: category,
        priority: priority,
        isCompleted: false,
      );

      // Add to list (latest first)
      _tasks.insert(0, newTask);

      notifyListeners();
    } catch (e) {
      _setError('Failed to add task: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Remove from list
      _tasks.removeWhere((task) => task.id == taskId);

      notifyListeners();
    } catch (e) {
      _setError('Failed to delete task: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Find task and toggle
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        final task = _tasks[index];
        _tasks[index] = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          category: task.category,
          priority: task.priority,
          isCompleted: !task.isCompleted,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to update task: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing task
  Future<void> updateTask({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskCategory category,
    required TaskPriority priority,
    bool? isCompleted,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Find task index
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index == -1) {
        throw Exception('Task not found');
      }

      // Get existing task to preserve completion status if not provided
      final existingTask = _tasks[index];

      // Update task
      _tasks[index] = TaskModel(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
        category: category,
        priority: priority,
        isCompleted: isCompleted ?? existingTask.isCompleted,
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to update task: $e');
      rethrow; // Rethrow for error handling di UI
    } finally {
      _setLoading(false);
    }
  }

  /// Get task by ID
  TaskModel? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
