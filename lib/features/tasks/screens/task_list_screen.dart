import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../providers/task_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

/// Task filter enum
enum TaskFilter {
  all,
  pending,
  overdue,
  completed,
}

/// Task list screen dengan ListView.builder dan filter functionality
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskFilter _selectedFilter = TaskFilter.all;

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks) {
    switch (_selectedFilter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return tasks
            .where((task) => task.status == TaskStatus.pending)
            .toList();
      case TaskFilter.overdue:
        return tasks
            .where((task) => task.status == TaskStatus.overdue)
            .toList();
      case TaskFilter.completed:
        return tasks
            .where((task) => task.status == TaskStatus.completed)
            .toList();
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case TaskFilter.all:
        return AppStrings.noTasksAll;
      case TaskFilter.pending:
        return AppStrings.noTasksPending;
      case TaskFilter.overdue:
        return AppStrings.noTasksOverdue;
      case TaskFilter.completed:
        return AppStrings.noTasksCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myTasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          return tasks.isEmpty
              ? _buildEmptyState(context)
              : _buildTaskList(tasks);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        tooltip: AppStrings.addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks) {
    final filteredTasks = _getFilteredTasks(tasks);
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: filteredTasks.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return _buildDismissibleTaskCard(context, task);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDismissibleTaskCard(BuildContext context, TaskModel task) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      confirmDismiss: (direction) => _showDeleteConfirmation(context, task),
      onDismissed: (direction) => _deleteTask(context, task.id),
      child: InkWell(
        onTap: () => _navigateToDetail(context, task),
        borderRadius: BorderRadius.circular(12),
        child: TaskCard(task: task),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 32),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, TaskModel task) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteTask),
        content: Text(AppStrings.deleteTaskConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _deleteTask(BuildContext context, String taskId) async {
    final taskProvider = context.read<TaskProvider>();
    await taskProvider.deleteTask(taskId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.taskDeleted),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToDetail(BuildContext context, TaskModel task) {
    Navigator.pushNamed(context, AppRoutes.taskDetail, arguments: task);
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addTask);
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TaskFilter.values.map((filter) {
            final isSelected = _selectedFilter == filter;
            final label = _getFilterLabel(filter);
            final color = _getFilterColor(filter);

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: color.withOpacity(0.1),
                selectedColor: color.withOpacity(0.2),
                checkmarkColor: color,
                labelStyle: TextStyle(
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? color
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.3),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getFilterLabel(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return AppStrings.filterAll;
      case TaskFilter.pending:
        return AppStrings.filterPending;
      case TaskFilter.overdue:
        return AppStrings.filterOverdue;
      case TaskFilter.completed:
        return AppStrings.filterCompleted;
    }
  }

  Color _getFilterColor(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return Theme.of(context).colorScheme.primary;
      case TaskFilter.pending:
        return AppColors.statusPending;
      case TaskFilter.overdue:
        return AppColors.statusOverdue;
      case TaskFilter.completed:
        return AppColors.statusCompleted;
    }
  }

  void _logout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }
}
