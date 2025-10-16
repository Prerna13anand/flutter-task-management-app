import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

// This use case returns a stream, so it doesn't need the standard Future-based UseCase class.
// It's a simple wrapper around the repository method.
class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Stream<List<Task>> call() {
    return repository.getTasks();
  }
}
