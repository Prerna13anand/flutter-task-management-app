import 'package:task_management_app/domain/entities/user.dart';

abstract class AuthRepository {
  // This stream will notify the app of authentication state changes.
  Stream<User?> get user;

  // FIX: Added email and password parameters
  Future<void> signIn(String email, String password);

  // FIX: Added email and password parameters
  Future<void> signUp(String email, String password);

  Future<void> signOut();
}
