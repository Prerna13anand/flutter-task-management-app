import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:task_management_app/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, super.email});

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }
}
