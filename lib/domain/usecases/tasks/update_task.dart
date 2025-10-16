import 'package:equatable/equatable.dart';
import 'package:task_management_app/core/usecase.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

class UpdateTask implements UseCase<void, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<void> call(UpdateTaskParams params) {
    return repository.updateTask(params.task);
  }
}

class UpdateTaskParams extends Equatable {
  final Task task;

  const UpdateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
