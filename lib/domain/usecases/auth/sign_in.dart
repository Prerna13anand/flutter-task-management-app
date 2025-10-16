import 'package:equatable/equatable.dart';
import 'package:task_management_app/core/usecase.dart';
import 'package:task_management_app/domain/repositories/auth_repository.dart';

class SignIn implements UseCase<void, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<void> call(SignInParams params) async {
    return await repository.signIn(params.email, params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
