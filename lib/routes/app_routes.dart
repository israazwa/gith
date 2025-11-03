/// Route name constants untuk navigation
///
/// CATATAN: Hanya routes untuk P4-5 (splash, task list)
/// Routes untuk auth, detail, dll akan ditambahkan di pertemuan selanjutnya
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String taskList = '/tasks';
  static const String taskDetail = '/task-detail';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task'; // NEW

  // Routes lain akan ditambahkan sesuai kebutuhan:
  // - '/login' di Pertemuan 9 (Authentication)
  // - '/add-task' di Pertemuan 6 (Form)
  // - dst...
}
