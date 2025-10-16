import 'package:task_management_app/core/usecase.dart';
import 'package:task_management_app/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.signOut();
  }
}
