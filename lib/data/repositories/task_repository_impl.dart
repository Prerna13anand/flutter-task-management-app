import 'package:task_management_app/data/datasources/task_remote_data_source.dart';
import 'package:task_management_app/data/models/task_model.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Task>> getTasks() {
    return remoteDataSource.getTasks().map((models) {
      return models.map((model) => model as Task).toList();
    });
  }

  @override
  Future<void> addTask(Task task) {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
    return remoteDataSource.addTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
    return remoteDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return remoteDataSource.deleteTask(taskId);
  }
}
