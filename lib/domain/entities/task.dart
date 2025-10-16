import 'package:equatable/equatable.dart';

enum Priority { low, medium, high }

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  /// Creates a copy of this Task but with the given fields replaced with the new values.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, dueDate, priority, isCompleted];
}
