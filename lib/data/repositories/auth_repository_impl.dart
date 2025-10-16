import 'package:task_management_app/data/datasources/auth_remote_data_source.dart';
import 'package:task_management_app/domain/entities/user.dart';
import 'package:task_management_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<User?> get user {
    return remoteDataSource.userStream.map((firebaseUser) {
      return firebaseUser == null
          ? null
          : User(id: firebaseUser.uid, email: firebaseUser.email);
    });
  }

  // This now correctly overrides the interface
  @override
  Future<void> signIn(String email, String password) async {
    await remoteDataSource.signIn(email, password);
  }

  // This now correctly overrides the interface
  @override
  Future<void> signUp(String email, String password) async {
    await remoteDataSource.signUp(email, password);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
