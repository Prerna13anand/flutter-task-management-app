import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/data/datasources/auth_remote_data_source.dart';
import 'package:task_management_app/data/datasources/task_remote_data_source.dart';
import 'package:task_management_app/data/repositories/auth_repository_impl.dart';
import 'package:task_management_app/data/repositories/task_repository_impl.dart';
import 'package:task_management_app/domain/repositories/auth_repository.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';
import 'package:task_management_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:task_management_app/presentation/bloc/task/task_bloc.dart';
import 'package:task_management_app/presentation/pages/home_page.dart';
import 'package:task_management_app/presentation/pages/login_page.dart';
import 'package:task_management_app/presentation/pages/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(),
        ),
        RepositoryProvider<TaskRemoteDataSource>(
          create: (context) => TaskRemoteDataSourceImpl(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<TaskRepository>(
          create: (context) => TaskRepositoryImpl(
            remoteDataSource: context.read<TaskRemoteDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthAppStarted()),
          ),
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Task Management App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: const Color(0xFFF3F5F9),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8A72E8),
              background: const Color(0xFFF3F5F9),
            ),
            textTheme: const TextTheme(
              displayLarge:
                  TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              titleLarge: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              bodyMedium: TextStyle(fontSize: 14.0),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A72E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          home: MultiBlocListener(
            listeners: [
              // Listener for success states
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Successfully logged in!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                  }
                },
              ),
              // Listener for failure states
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                },
              ),
            ],
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const HomePage();
                }
                if (state is Unauthenticated) {
                  return const LoginPage();
                }
                return const SplashPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
