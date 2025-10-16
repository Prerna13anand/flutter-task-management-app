part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class TasksUpdated extends TaskEvent {
  final List<Task> tasks;
  const TasksUpdated(this.tasks);
}

class AddTaskEvent extends TaskEvent {
  final Task task;
  const AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  const UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final Task task;
  const ToggleTaskCompletionEvent(this.task);
}

class UpdateFilterEvent extends TaskEvent {
  final TaskFilter filter;
  const UpdateFilterEvent(this.filter);
}

// THIS IS THE FIX: New event for priority filtering
class UpdatePriorityFilterEvent extends TaskEvent {
  final Priority? priority; // Can be null to clear the filter
  const UpdatePriorityFilterEvent(this.priority);
}
