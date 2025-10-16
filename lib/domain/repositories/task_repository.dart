import 'package:task_management_app/domain/entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}
