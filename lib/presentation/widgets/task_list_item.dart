import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/presentation/bloc/task/task_bloc.dart';
import 'package:task_management_app/presentation/widgets/add_task_sheet.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red.shade300;
      case Priority.medium:
        return Colors.orange.shade300;
      case Priority.low:
        return Colors.blue.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => showAddTaskSheet(context, task: task),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            context.read<TaskBloc>().add(ToggleTaskCompletionEvent(task));
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle:
            Text('Due: ${DateFormat('d MMM, yyyy').format(task.dueDate)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.priority.toString().split('.').last.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            // THIS IS THE FIX: A visible delete button for all platforms
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.grey.shade600),
              onPressed: () {
                context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(content: Text('"${task.title}" deleted')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
