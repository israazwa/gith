/// Task model untuk assignment tracking
class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final TaskCategory category; // NEW: tambahkan field category

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category, // NEW: tambahkan di constructor
    this.isCompleted = false,
  });

  /// Get task status based on completion and due date
  TaskStatus get status {
    if (isCompleted) return TaskStatus.completed;
    if (dueDate.isBefore(DateTime.now())) return TaskStatus.overdue;
    return TaskStatus.pending;
  }

  /// Dummy data generator untuk testing UI
  static List<TaskModel> getDummyTasks() {
    final now = DateTime.now();

    return [
      TaskModel(
        id: '1',
        title: 'Complete Math Assignment',
        description: 'Finish calculus homework chapter 5',
        dueDate: now.add(const Duration(days: 2)),
        priority: TaskPriority.high,
        category: TaskCategory.assignment, // NEW
        isCompleted: false,
      ),
      TaskModel(
        id: '2',
        title: 'Read History Chapter 3',
        description: 'Read about World War II and make notes',
        dueDate: now.add(const Duration(days: 5)),
        priority: TaskPriority.medium,
        category: TaskCategory.study, // NEW
        isCompleted: false,
      ),
      TaskModel(
        id: '3',
        title: 'Physics Lab Report',
        description: 'Write lab report for pendulum experiment',
        dueDate: now.subtract(const Duration(days: 1)),
        priority: TaskPriority.high,
        category: TaskCategory.assignment, // NEW
        isCompleted: false,
      ),
      TaskModel(
        id: '4',
        title: 'English Essay Draft',
        description: 'First draft of argumentative essay',
        dueDate: now.add(const Duration(days: 7)),
        priority: TaskPriority.low,
        category: TaskCategory.project, // NEW
        isCompleted: false,
      ),
      TaskModel(
        id: '5',
        title: 'Chemistry Quiz Prep',
        description: 'Study organic chemistry for quiz',
        dueDate: now.subtract(const Duration(days: 3)),
        priority: TaskPriority.medium,
        category: TaskCategory.study, // NEW
        isCompleted: true,
      ),
    ];
  }
}

/// Task priority levels
enum TaskPriority {
  low,
  medium,
  high,
}

/// Task status based on completion and due date
enum TaskStatus {
  completed,
  pending,
  overdue,
}

/// Task categories untuk organization
enum TaskCategory {
  study,
  assignment,
  project,
  personal,
}
