import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import 'time_log_page.dart';
import 'contract_page.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<StudentBloc>()
        .add(const LoadStudentDashboardDataEvent(userId: 'current-user-id'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.studentHome),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLogoutSuccess) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is StudentDashboardLoadSuccess) {
            final student = state.student;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<StudentBloc>().add(
                    const LoadStudentDashboardDataEvent(
                        userId: 'current-user-id'));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(student),
                    const SizedBox(height: 24),
                    _buildQuickActions(student),
                    const SizedBox(height: 24),
                    _buildStudentInfo(student),
                  ],
                ),
              ),
            );
          }

          if (state is StudentOperationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar dados',
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StudentBloc>().add(
                          const LoadStudentDashboardDataEvent(
                              userId: 'current-user-id'));
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildWelcomeCard(dynamic student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo!',
                        style: AppTextStyles.h6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Matrícula: ${student.registrationNumber}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.course,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Estudante',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(dynamic student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: AppTextStyles.h6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Registro de Horas',
                subtitle: 'Marcar ponto',
                icon: Icons.access_time,
                color: AppColors.success,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TimeLogPage(studentId: student.id),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'Contratos',
                subtitle: 'Ver contratos',
                icon: Icons.description,
                color: AppColors.info,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContractPage(studentId: student.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInfo(dynamic student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações do Estudante',
          style: AppTextStyles.h6,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  'Matrícula',
                  student.registrationNumber,
                  Icons.badge,
                ),
                const Divider(),
                _buildInfoRow(
                  'Curso',
                  student.course,
                  Icons.school,
                ),
                const Divider(),
                _buildInfoRow(
                  'Nome',
                  student.fullName,
                  Icons.person,
                ),
                const Divider(),
                _buildInfoRow(
                  'Turno das Aulas',
                  _getShiftText(student.classShift.value),
                  Icons.schedule,
                ),
                const Divider(),
                _buildInfoRow(
                  'Turno do Estágio',
                  _getShiftText(student.internshipShift1.value),
                  Icons.work,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption,
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getShiftText(String shift) {
    switch (shift) {
      case 'morning':
        return 'Manhã';
      case 'afternoon':
        return 'Tarde';
      case 'evening':
        return 'Noite';
      case 'full_time':
        return 'Integral';
      default:
        return shift;
    }
  }
}
