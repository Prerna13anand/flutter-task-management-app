import 'package:equatable/equatable.dart';
import 'package:task_management_app/core/usecase.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

class AddTask implements UseCase<void, AddTaskParams> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<void> call(AddTaskParams params) {
    return repository.addTask(params.task);
  }
}

class AddTaskParams extends Equatable {
  final Task task;

  const AddTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
