// lib/features/supervisor/presentation/widgets/dashboard_summary_cards.dart
import 'package:flutter/material.dart';
// Se precisar de navegação ou outros serviços

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart'; // Para cores dos ícones/cards
import '../bloc/supervisor_state.dart'; // Para SupervisorDashboardStats

class DashboardSummaryCards extends StatelessWidget {
  final SupervisorDashboardStats stats;

  const DashboardSummaryCards({
    super.key,
    required this.stats,
  });

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: backgroundColor ?? theme.cardColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(
                12.0), // Padding reduzido para cards menores
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 28, color: iconColor), // Ícone um pouco menor
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onTap != null
                        ? theme.colorScheme.primary
                        : null, // Cor diferente se for clicável
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Para tornar os cards responsivos em linha ou coluna dependendo da largura
    return LayoutBuilder(
      builder: (context, constraints) {
        bool useRow = constraints.maxWidth > 500; // Exemplo de breakpoint

        if (useRow) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStatCard(
                context: context,
                title: AppStrings.totalStudents,
                count: stats.totalStudents,
                icon: Icons.people_alt_outlined,
                iconColor: AppColors.primary,
                onTap: () {
                  // TODO: Navegar para a lista de todos os estudantes ou aplicar filtro
                  // Ex: Modular.to.pushNamed('/supervisor/students', arguments: {'filter': 'all'});
                },
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context: context,
                title: AppStrings.activeStudents,
                count: stats.activeStudents,
                icon: Icons.check_circle_outline,
                iconColor: AppColors.statusActive,
                onTap: () {
                  // TODO: Navegar para a lista de estudantes ativos ou aplicar filtro
                  // Ex: Modular.to.pushNamed('/supervisor/students', arguments: {'filter': 'active'});
                },
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context: context,
                title: AppStrings
                    .activeStudents, // Ou 'Expirados' se for mais apropriado
                count: stats.inactiveStudents,
                icon: Icons
                    .pause_circle_outline_outlined, // Ou Icons.cancel_outlined
                iconColor: AppColors.statusInactive,
                onTap: () {
                  // TODO: Navegar para a lista de estudantes inativos ou aplicar filtro
                },
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context: context,
                title: AppStrings.expiringContracts,
                count: stats.expiringContractsSoon,
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.statusPending, // Cor de aviso
                onTap: () {
                  // TODO: Navegar para a lista de contratos a vencer ou aplicar filtro
                },
              ),
            ],
          );
        } else {
          // Layout em grelha para telas menores
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8, // Ajuste para o tamanho desejado do card
            children: <Widget>[
              _buildStatCard(
                context: context,
                title: AppStrings.totalStudents,
                count: stats.totalStudents,
                icon: Icons.people_alt_outlined,
                iconColor: AppColors.primary,
                onTap: () {/* TODO */},
              ),
              _buildStatCard(
                context: context,
                title: AppStrings.activeStudents,
                count: stats.activeStudents,
                icon: Icons.check_circle_outline,
                iconColor: AppColors.statusActive,
                onTap: () {/* TODO */},
              ),
              _buildStatCard(
                context: context,
                title: AppStrings.activeStudents,
                count: stats.inactiveStudents,
                icon: Icons.pause_circle_outline_outlined,
                iconColor: AppColors.statusInactive,
                onTap: () {/* TODO */},
              ),
              _buildStatCard(
                context: context,
                title: AppStrings.expiringContracts,
                count: stats.expiringContractsSoon,
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.statusPending,
                onTap: () {/* TODO */},
              ),
            ],
          );
        }
      },
    );
  }
}
