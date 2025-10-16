import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/presentation/bloc/task/task_bloc.dart';
import 'package:uuid/uuid.dart';

// The function now accepts an optional task for editing
void showAddTaskSheet(BuildContext context, {Task? task}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      // Pass the optional task to the sheet widget
      child: AddTaskSheet(task: task),
    ),
  );
}

class AddTaskSheet extends StatefulWidget {
  // Add a task property to the widget
  final Task? task;
  const AddTaskSheet({super.key, this.task});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late Priority _priority;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    // Check if a task was passed in (i.e., we are editing)
    _isEditing = widget.task != null;

    // Pre-fill the form fields if we are editing
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _priority = widget.task?.priority ?? Priority.low;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        // Create an updated task object
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _dueDate,
          priority: _priority,
        );
        // Dispatch the UpdateTask event
        context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
      } else {
        // Create a new task object
        final newTask = Task(
          id: const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _dueDate,
          priority: _priority,
          isCompleted: false,
        );
        // Dispatch the AddTask event
        context.read<TaskBloc>().add(AddTaskEvent(newTask));
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? 'Edit Task' : 'Add New Task',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                      'Due Date: ${DateFormat('d MMM, yyyy').format(_dueDate)}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Change'),
                ),
              ],
            ),
            DropdownButtonFormField<Priority>(
              value: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: Priority.values.map((Priority priority) {
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child:
                      Text(priority.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (Priority? newValue) {
                setState(() {
                  _priority = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text(_isEditing ? 'Update Task' : 'Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
