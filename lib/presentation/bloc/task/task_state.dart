part of 'task_bloc.dart';

enum TaskFilter { all, completed, incomplete }

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TasksLoadInProgress extends TaskState {}

class TasksLoadSuccess extends TaskState {
  final List<Task> allTasks;
  final TaskFilter filter;
  // THIS IS THE FIX: Added a filter for priority
  final Priority? priorityFilter;

  const TasksLoadSuccess({
    this.allTasks = const [],
    this.filter = TaskFilter.all,
    this.priorityFilter,
  });

  // The getter now applies both filters
  List<Task> get filteredTasks {
    List<Task> tasks = allTasks.where((task) {
      switch (filter) {
        case TaskFilter.completed:
          return task.isCompleted;
        case TaskFilter.incomplete:
          return !task.isCompleted;
        case TaskFilter.all:
          return true;
      }
    }).toList();

    if (priorityFilter != null) {
      tasks = tasks.where((task) => task.priority == priorityFilter).toList();
    }
    return tasks;
  }

  TasksLoadSuccess copyWith({
    List<Task>? allTasks,
    TaskFilter? filter,
    // Add an optional way to clear or set the priority filter
    Priority? Function()? priorityFilter,
  }) {
    return TasksLoadSuccess(
      allTasks: allTasks ?? this.allTasks,
      filter: filter ?? this.filter,
      // Use the provided function to update the filter
      priorityFilter:
          priorityFilter != null ? priorityFilter() : this.priorityFilter,
    );
  }

  @override
  List<Object> get props => [allTasks, filter, priorityFilter ?? ''];
}
