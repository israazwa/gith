import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

/// Simple edit screen - focus on pre-filled form concept
class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late quill.QuillController _descriptionController;

  bool _isLoading = false;
  late DateTime _selectedDate;
  late TaskCategory _selectedCategory;
  late TaskPriority _selectedPriority;
  bool _showDescriptionError = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing task data
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = quill.QuillController.basic();
    _descriptionController.document.insert(0, widget.task.description);
    _selectedDate = widget.task.dueDate;
    _selectedCategory = widget.task.category;
    _selectedPriority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    // _descriptionController.dispose(); // Temporarily removed to fix assertion error
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editTask)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Title required' : null,
              ),
              const SizedBox(height: 16),

              // Description - Rich Text Editor
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    AppStrings.taskDescription,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onSurface.withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Quill Toolbar (formatting options)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: quill.QuillSimpleToolbar(
                      controller: _descriptionController,
                    ),
                  ),

                  // Quill Editor
                  Container(
                    height: 200, // Fixed height untuk editor
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.outline),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: quill.QuillEditor(
                      controller: _descriptionController,
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                    ),
                  ),

                  // Validation error message (if needed)
                  if (_showDescriptionError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        AppStrings.descriptionMinLength,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<TaskCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: TaskCategory.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<TaskPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: TaskPriority.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedPriority = v!),
              ),
              const SizedBox(height: 24),

              // Update Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTask() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate description
    final descriptionText =
        _descriptionController.document.toPlainText().trim();
    if (descriptionText.isEmpty) {
      setState(() => _showDescriptionError = true);
      return;
    } else {
      setState(() => _showDescriptionError = false);
    }

    setState(() => _isLoading = true);

    try {
      await context.read<TaskProvider>().updateTask(
            id: widget.task.id,
            title: _titleController.text.trim(),
            description: descriptionText,
            dueDate: _selectedDate,
            category: _selectedCategory,
            priority: _selectedPriority,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.taskUpdated),
          backgroundColor: AppColors.statusCompleted,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
