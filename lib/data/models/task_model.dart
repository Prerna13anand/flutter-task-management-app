import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management_app/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required Priority priority,
    required bool isCompleted,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          priority: priority,
          isCompleted: isCompleted,
        );

  factory TaskModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TaskModel(
      id: snap.id,
      title: snapshot['title'],
      description: snapshot['description'],
      dueDate: (snapshot['dueDate'] as Timestamp).toDate(),
      priority: Priority.values
          .firstWhere((e) => e.toString() == snapshot['priority']),
      isCompleted: snapshot['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority.toString(),
      'isCompleted': isCompleted,
    };
  }
}
