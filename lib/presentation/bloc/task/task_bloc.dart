import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  StreamSubscription? _tasksSubscription;

  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(TasksLoadInProgress()) {
    on<LoadTasks>(_onLoadTasks);
    on<TasksUpdated>(_onTasksUpdated);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<UpdateFilterEvent>(_onUpdateFilter);
    // THIS IS THE FIX: Handle the new event
    on<UpdatePriorityFilterEvent>(_onUpdatePriorityFilter);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) {
    _tasksSubscription?.cancel();
    _tasksSubscription = _taskRepository.getTasks().listen(
          (tasks) => add(TasksUpdated(tasks)),
        );
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    emit(TasksLoadSuccess(allTasks: event.tasks));
  }

  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) {
    _taskRepository.addTask(event.task);
  }

  void _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) {
    _taskRepository.updateTask(event.task);
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) {
    _taskRepository.deleteTask(event.taskId);
  }

  void _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) {
    final updatedTask =
        event.task.copyWith(isCompleted: !event.task.isCompleted);
    _taskRepository.updateTask(updatedTask);
  }

  void _onUpdateFilter(UpdateFilterEvent event, Emitter<TaskState> emit) {
    final state = this.state;
    if (state is TasksLoadSuccess) {
      emit(state.copyWith(filter: event.filter));
    }
  }

  // THIS IS THE FIX: New handler for priority filtering
  void _onUpdatePriorityFilter(
      UpdatePriorityFilterEvent event, Emitter<TaskState> emit) {
    final state = this.state;
    if (state is TasksLoadSuccess) {
      // We pass a function to copyWith to handle setting/clearing the filter
      emit(state.copyWith(priorityFilter: () => event.priority));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
