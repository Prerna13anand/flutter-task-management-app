part of 'auth_bloc.dart'; // FIX: Add this line

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

// This event is triggered by the user stream
class AuthUserChanged extends AuthEvent {
  final User? user;
  const AuthUserChanged(this.user);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});
}

class SignOutRequested extends AuthEvent {}
