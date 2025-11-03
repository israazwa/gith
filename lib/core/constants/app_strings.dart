/// App string constants
///
/// NOTE: Strings akan ditambahkan progressively seiring tutorial:
/// - P4-5: App identity & basic actions
/// - P5-7: Task feature strings
/// - P6: Form validation messages
/// - P9: Authentication strings
/// - P13: Dashboard strings
/// - P14: Profile & settings strings
class AppStrings {
  AppStrings._(); // Prevent instantiation

  // ==================== App Identity ====================
  static const String appName = 'StudyTracker';
  static const String appTagline = 'Track Your Study Progress';

  // ==================== Common Actions ====================
  // Used across the app for buttons, dialogs, etc.
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String ok = 'OK';
  static const String confirm = 'Confirm';

  // ==================== Navigation Strings ====================
  static const String tasks = 'Tasks';
  static const String dashboard = 'Dashboard';
  static const String profile = 'Profile';

  // ==================== Task List Screen Strings ====================
  static const String myTasks = 'My Tasks';
  static const String noTasks = 'No tasks yet';
  static const String addTask = 'Add Task';

  // ==================== Priority Labels ====================
  static const String priorityHigh = 'High';
  static const String priorityMedium = 'Medium';
  static const String priorityLow = 'Low';

  // ==================== Status Labels ====================
  static const String statusCompleted = 'Completed';
  static const String statusPending = 'Pending';
  static const String statusOverdue = 'Overdue';

  // ==================== Task Actions ====================
  static const String deleteTask = 'Delete Task';
  static const String deleteTaskConfirm =
      'Are you sure you want to delete this task?';
  static const String taskDeleted = 'Task deleted';

  // ==================== Form Labels (P6) ====================
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Description';
  static const String taskDueDate = 'Due Date';
  static const String taskCategory = 'Category';
  static const String taskPriority = 'Priority';
  static const String selectDate = 'Select Date';
  static const String selectCategory = 'Select Category';

  // ==================== Validation Messages (P6) ====================
  static const String fieldRequired = 'This field is required';
  static const String titleMinLength = 'Title must be at least 3 characters';
  static const String descriptionMinLength =
      'Description must be at least 10 characters';
  static const String selectValidDate = 'Please select a valid date';
  static const String selectValidCategory = 'Please select a category';

  // ==================== Success Messages (P6) ====================
  static const String taskCreated = 'Task created successfully';
  static const String taskUpdated = 'Task updated successfully';
  static const String draftSaved = 'Draft saved';
  static const String draftLoaded = 'Draft loaded';

  // ==================== Edit Task strings ====================
  static const String editTask = 'Edit Task';

  // ==================== Category Labels (P6) ====================
  static const String categoryStudy = 'Study';
  static const String categoryAssignment = 'Assignment';
  static const String categoryProject = 'Project';
  static const String categoryPersonal = 'Personal';

  // ==================== TODO: Additional Strings ====================
  // Will be added progressively in future tutorials:

  // TODO P9: Add authentication strings
  // static const String login = 'Login';
  // static const String register = 'Register';
  // etc...

  // TODO P13: Add dashboard & analytics strings
  // TODO P14: Add profile & settings strings
}
