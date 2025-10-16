import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_app/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  TaskRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get _userId => _firebaseAuth.currentUser?.uid;

  CollectionReference<TaskModel> get _tasksCollection {
    if (_userId == null) throw Exception('User is not logged in');
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .withConverter<TaskModel>(
          fromFirestore: (snapshots, _) => TaskModel.fromSnapshot(snapshots),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  @override
  Stream<List<TaskModel>> getTasks() {
    // THIS IS THE FIX: Added .orderBy('dueDate')
    return _tasksCollection.orderBy('dueDate').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Future<void> addTask(TaskModel task) {
    return _tasksCollection.doc(task.id).set(task);
  }

  @override
  Future<void> updateTask(TaskModel task) {
    return _tasksCollection.doc(task.id).update(task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) {
    return _tasksCollection.doc(taskId).delete();
  }
}
