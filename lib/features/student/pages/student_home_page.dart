import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../features/auth/bloc/auth_event.dart';
import '../../../features/auth/bloc/auth_state.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  void initState() {
    super.initState();
    print('🟢 StudentHomePage: initState chamado');
    // Carregar dados do dashboard
    context
        .read<StudentBloc>()
        .add(const LoadStudentDashboardDataEvent(userId: 'current-user-id'));
  }

  @override
  Widget build(BuildContext context) {
    print('🟢 StudentHomePage: BUILD chamado');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial do Estudante'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          print('🟢 StudentHomePage: BlocBuilder - Estado: $state');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Página Inicial do Estudante',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Estado atual: ${state.runtimeType}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                if (state is StudentLoading)
                  const CircularProgressIndicator()
                else if (state is StudentDashboardLoadSuccess)
                  Column(
                    children: [
                      Text(
                        'Bem-vindo, ${state.student.fullName}!',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Matrícula: ${state.student.registrationNumber}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Curso: ${state.student.course}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                else if (state is StudentOperationFailure)
                  Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erro: ${state.message}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  const Text(
                    'Carregando dados...',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
