import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management_app/domain/entities/user.dart';
import 'package:task_management_app/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignOutRequested>(_onSignOutRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  void _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) {
    _userSubscription?.cancel();
    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    try {
      // FIX: Pass parameters correctly
      await _authRepository.signIn(event.email, event.password);
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    try {
      // FIX: Pass parameters correctly
      await _authRepository.signUp(event.email, event.password);
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
