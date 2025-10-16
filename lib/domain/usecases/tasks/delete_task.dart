import 'package:equatable/equatable.dart';
import 'package:task_management_app/core/usecase.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<void> call(DeleteTaskParams params) {
    return repository.deleteTask(params.id);
  }
}

class DeleteTaskParams extends Equatable {
  final String id;

  const DeleteTaskParams({required this.id});

  @override
  List<Object> get props => [id];
}
