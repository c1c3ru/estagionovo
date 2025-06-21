import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';

class SupervisorHomePage extends StatelessWidget {
  const SupervisorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Supervisor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.supervisor_account,
                            color: AppColors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bem-vindo, Supervisor!',
                                style: AppTextStyles.h6,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Prof. Maria Santos',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Cards
            Text(
              'Estatísticas',
              style: AppTextStyles.h6,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Estudantes',
                    value: '12',
                    icon: Icons.people,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Ativos Hoje',
                    value: '8',
                    icon: Icons.access_time,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Contratos',
                    value: '15',
                    icon: Icons.description,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Pendentes',
                    value: '3',
                    icon: Icons.pending,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Text(
              'Ações Rápidas',
              style: AppTextStyles.h6,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(
                        Icons.people,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text('Gerenciar Estudantes'),
                    subtitle: const Text('Visualizar e editar estudantes'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to students management
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondaryLight,
                      child: const Icon(
                        Icons.assessment,
                        color: AppColors.secondary,
                      ),
                    ),
                    title: const Text('Relatórios'),
                    subtitle: const Text('Visualizar relatórios de horas'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to reports
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.warning.withOpacity(0.2),
                      child: Icon(
                        Icons.description,
                        color: AppColors.warning,
                      ),
                    ),
                    title: const Text('Contratos'),
                    subtitle: const Text('Gerenciar contratos de estágio'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to contracts
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recent Activities
            Text(
              'Atividades Recentes',
              style: AppTextStyles.h6,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activities = [
                    {
                      'title': 'João Silva registrou entrada',
                      'time': '08:30',
                      'icon': Icons.login,
                      'color': AppColors.success,
                    },
                    {
                      'title': 'Maria Oliveira registrou saída',
                      'time': '17:45',
                      'icon': Icons.logout,
                      'color': AppColors.error,
                    },
                    {
                      'title': 'Novo contrato aprovado',
                      'time': '14:20',
                      'icon': Icons.check_circle,
                      'color': AppColors.primary,
                    },
                    {
                      'title': 'Pedro Santos atualizou perfil',
                      'time': '11:15',
                      'icon': Icons.person,
                      'color': AppColors.warning,
                    },
                  ];

                  final activity = activities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          (activity['color'] as Color).withOpacity(0.1),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      activity['title'] as String,
                      style: AppTextStyles.bodyMedium,
                    ),
                    subtitle: Text(
                      'Hoje às ${activity['time']}',
                      style: AppTextStyles.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Estudantes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                Text(
                  value,
                  style: AppTextStyles.h4.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
