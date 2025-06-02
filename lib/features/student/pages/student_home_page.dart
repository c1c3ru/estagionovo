// lib/features/student/presentation/pages/student_home_page.dart
import 'package:estagio/domain/entities/student.dart';
import 'package:estagio/domain/entities/time_log.dart';
import 'package:estagio/features/auth/bloc/auth_bloc.dart';
import 'package:estagio/features/auth/bloc/auth_state.dart' as auth_state;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart'; // Para formatação de datas

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
// Assumindo que StudentAppDrawer e StudentBottomNavBar estão em shared/widgets

import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
// Importe o AuthBloc para obter o ID do usuário logado

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late StudentBloc _studentBloc;
  late AuthBloc _authBloc;
  String? _currentUserId;
  TimeLogEntity? _activeTimeLog;

  @override
  void initState() {
    super.initState();
    _studentBloc = Modular.get<StudentBloc>();
    _authBloc = Modular.get<AuthBloc>(); // Obter o AuthBloc global

    // Ouve o AuthBloc para obter o ID do usuário e carregar dados
    // ou dispara o evento de carregamento se o usuário já estiver disponível.
    final currentAuthState = _authBloc.state;
    if (currentAuthState is auth_state.AuthSuccess) {
      _currentUserId = currentAuthState.user.id;
      if (_currentUserId != null) {
        _studentBloc.add(
          LoadStudentDashboardDataEvent(userId: _currentUserId!),
        );
        _studentBloc.add(
          FetchActiveTimeLogEvent(userId: _currentUserId!),
        ); // Busca log ativo
      }
    }

    // Adiciona um listener para o AuthBloc caso o estado mude depois do initState
    _authBloc.stream.listen((authState) {
      if (mounted && authState is auth_state.AuthSuccess) {
        if (_currentUserId != authState.user.id) {
          setState(() {
            _currentUserId = authState.user.id;
          });
          if (_currentUserId != null) {
            _studentBloc.add(
              LoadStudentDashboardDataEvent(userId: _currentUserId!),
            );
            _studentBloc.add(FetchActiveTimeLogEvent(userId: _currentUserId!));
          }
        }
      } else if (mounted && authState is auth_state.AuthUnauthenticated) {
        // Se deslogado, pode querer limpar o estado ou não fazer nada aqui,
        // pois o AuthGuard deve redirecionar.
        setState(() {
          _currentUserId = null;
        });
      }
    });
  }

  Future<void> _refreshDashboard() async {
    if (_currentUserId != null) {
      _studentBloc.add(LoadStudentDashboardDataEvent(userId: _currentUserId!));
      _studentBloc.add(FetchActiveTimeLogEvent(userId: _currentUserId!));
    }
  }

  void _performCheckIn() {
    if (_currentUserId != null) {
      // Pode adicionar um diálogo para notas aqui, se desejar
      _studentBloc.add(StudentCheckInEvent(userId: _currentUserId!));
    }
  }

  void _performCheckOut() {
    if (_currentUserId != null && _activeTimeLog != null) {
      // Pode adicionar um diálogo para descrição aqui
      _studentBloc.add(
        StudentCheckOutEvent(
          userId: _currentUserId!,
          activeTimeLogId: _activeTimeLog!.id,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum check-in ativo encontrado para finalizar.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.studentDashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: _refreshDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notificações',
            onPressed: () {
              // TODO: Navegar para a tela de notificações
            },
          ),
        ],
      ),
      drawer: const StudentAppDrawer(
        currentIndex: 0,
      ), // Ajuste o currentIndex conforme necessário
      bottomNavigationBar: const StudentBottomNavBar(
        currentIndex: 0,
      ), // Ajuste o currentIndex
      body: BlocConsumer<StudentBloc, StudentState>(
        bloc: _studentBloc,
        listener: (context, state) {
          if (state is StudentOperationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
          } else if (state is StudentTimeLogOperationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            // Após check-in/check-out, busca o novo estado do log ativo
            if (_currentUserId != null) {
              _studentBloc.add(
                FetchActiveTimeLogEvent(userId: _currentUserId!),
              );
              // Recarregar dados do dashboard para atualizar estatísticas
              _studentBloc.add(
                LoadStudentDashboardDataEvent(userId: _currentUserId!),
              );
            }
          } else if (state is ActiveTimeLogFetched) {
            setState(() {
              _activeTimeLog = state.activeTimeLog;
            });
          }
        },
        builder: (context, state) {
          if (state is StudentLoading &&
              state is! StudentDashboardLoadSuccess) {
            // Mostra loading apenas se não houver dados de dashboard anteriores
            // ou se for um loading específico de uma operação que não seja o load inicial.
            // Para o load inicial, queremos mostrar o loading até StudentDashboardLoadSuccess.
            if (state is! StudentDashboardLoadSuccess &&
                _studentBloc.state is! StudentDashboardLoadSuccess) {
              return const LoadingIndicator();
            }
          }

          if (state is StudentDashboardLoadSuccess) {
            _activeTimeLog = state
                .timeStats
                .activeTimeLog; // Atualiza o log ativo localmente
            return _buildDashboardContent(context, state);
          }

          if (state is StudentOperationFailure &&
              _studentBloc.state is! StudentDashboardLoadSuccess) {
            return _buildErrorState(context, state.message);
          }

          // Estado inicial ou se _currentUserId for nulo
          if (_currentUserId == null && state is! StudentLoading) {
            return const Center(
              child: Text('A aguardar informações do utilizador...'),
            );
          }

          // Fallback para loading se nenhum outro estado corresponder e estivermos à espera do dashboard
          return const LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorOccurred,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: AppStrings.tryAgain,
              onPressed: _refreshDashboard,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    StudentDashboardLoadSuccess state,
  ) {
    final theme = Theme.of(context);
    final student = state.student;
    final timeStats = state.timeStats;
    // final contracts = state.contracts; // Se for usar informações de contrato

    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: ListView(
        // Usar ListView em vez de SingleChildScrollView para RefreshIndicator funcionar melhor
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildWelcomeCard(context, student),
          const SizedBox(height: 24),
          _buildCheckInOutSection(context, theme),
          const SizedBox(height: 24),
          Text(
            AppStrings.status,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatsGrid(context, student, timeStats),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context,
            AppStrings.weeklySummary,
            null,
          ), // Sem ação "Ver todos"
          const SizedBox(height: 8),
          _buildWeeklySummaryCard(context, student, timeStats),
          const SizedBox(height: 24),
          _buildSectionHeader(context, AppStrings.recentTimeLogs, () {
            Modular.to.pushNamed('/student/time-log');
          }),
          const SizedBox(height: 8),
          _buildRecentTimeLogs(context, timeStats.recentLogs),
          const SizedBox(height: 24),
          // TODO: Adicionar widget de Colegas Online se implementado
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, StudentEntity student) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage:
                  student.profilePictureUrl != null &&
                      student.profilePictureUrl!.isNotEmpty
                  ? NetworkImage(student.profilePictureUrl!)
                  : null,
              child:
                  student.profilePictureUrl == null ||
                      student.profilePictureUrl!.isEmpty
                  ? Text(
                      student.fullName.isNotEmpty
                          ? student.fullName[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${student.fullName.split(" ").first}!', // Apenas o primeiro nome
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.course,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: theme.colorScheme.primary),
              tooltip: 'Editar Perfil',
              onPressed: () => Modular.to.pushNamed('/student/profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInOutSection(BuildContext context, ThemeData theme) {
    bool isCheckedIn = _activeTimeLog != null;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isCheckedIn ? 'Check-in ativo desde:' : 'Pronto para começar?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (isCheckedIn && _activeTimeLog != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  DateUtil.formatTimeOfDay(
                    _activeTimeLog!.checkInTime,
                  ), // Usando DateUtil
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            AppButton(
              text: isCheckedIn ? AppStrings.checkOut : AppStrings.checkIn,
              onPressed: isCheckedIn ? _performCheckOut : _performCheckIn,
              backgroundColor: isCheckedIn
                  ? AppColors.warning
                  : AppColors.success,
              icon: isCheckedIn ? Icons.logout_outlined : Icons.login_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    StudentEntity student,
    StudentTimeStats timeStats,
  ) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildInfoCard(
          context,
          Icons.pie_chart_outline,
          'Progresso Total',
          '${student.progressPercentage.toStringAsFixed(1)}%',
          theme.colorScheme.primary,
        ),
        _buildInfoCard(
          context,
          Icons.timer_outlined,
          'Horas Restantes',
          '${student.remainingHours.toStringAsFixed(1)} h',
          student.isOnTrack ? AppColors.success : AppColors.warning,
        ),
        _buildInfoCard(
          context,
          Icons.calendar_today_outlined,
          'Dias no Contrato',
          '${student.daysRemainingInContract} dias',
          theme.colorScheme.tertiary, // Exemplo de outra cor
        ),
        _buildInfoCard(
          context,
          Icons.track_changes_outlined,
          'Meta Semanal',
          '${student.weeklyHoursTarget.toStringAsFixed(1)} h',
          theme.colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback? onViewAllPressed,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onViewAllPressed != null)
          TextButton(
            onPressed: onViewAllPressed,
            child: const Text('Ver todos'),
          ),
      ],
    );
  }

  Widget _buildWeeklySummaryCard(
    BuildContext context,
    StudentEntity student,
    StudentTimeStats timeStats,
  ) {
    final theme = Theme.of(context);
    final progress = student.weeklyHoursTarget > 0
        ? (timeStats.hoursThisWeek / student.weeklyHoursTarget).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.hoursThisWeek,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      timeStats.hoursThisWeek.toStringAsFixed(1) + ' h',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.weeklyTarget,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${student.weeklyHoursTarget.toStringAsFixed(1)} h',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (student.weeklyHoursTarget > 0)
              ClipRRect(
                // Para arredondar o LinearProgressIndicator
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.primaryContainer.withAlpha(
                    100,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0
                        ? AppColors.success
                        : theme.colorScheme.primary,
                  ),
                  minHeight: 12,
                ),
              )
            else
              Text(
                'Meta semanal não definida.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 8),
            if (student.weeklyHoursTarget > 0)
              Text(
                progress >= 1.0
                    ? AppStrings.weeklyTargetAchieved
                    : '${(student.weeklyHoursTarget - timeStats.hoursThisWeek).clamp(0, student.weeklyHoursTarget).toStringAsFixed(1)} ${AppStrings.hoursRemainingThisWeek}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: progress >= 1.0 ? AppColors.success : theme.hintColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTimeLogs(
    BuildContext context,
    List<TimeLogEntity> recentLogs,
  ) {
    final theme = Theme.of(context);
    if (recentLogs.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.history_toggle_off_outlined,
                  size: 48,
                  color: theme.hintColor,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noRecentTimeLogs,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: AppStrings.logTime,
                  icon: Icons.add_alarm_outlined,
                  type: AppButtonType.outlined,
                  onPressed: () => Modular.to.pushNamed('/student/time-log'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentLogs.length,
      itemBuilder: (context, index) {
        final log = recentLogs[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: log.approved
                  ? AppColors.statusActive.withAlpha(50)
                  : theme.colorScheme.secondaryContainer,
              child: Icon(
                log.approved
                    ? Icons.check_circle_outline
                    : Icons.hourglass_empty_outlined,
                color: log.approved
                    ? AppColors.statusActive
                    : theme.colorScheme.onSecondaryContainer,
                size: 20,
              ),
            ),
            title: Text(
              '${log.hoursLogged?.toStringAsFixed(1) ?? "-"} horas - ${DateUtil.formatDate(log.logDate)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              log.description != null && log.description!.isNotEmpty
                  ? log.description!
                  : 'Sem descrição',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: theme.hintColor,
            ),
            onTap: () {
              // TODO: Navegar para detalhes do log de tempo ou permitir edição
              // Modular.to.pushNamed('/student/time-log-details', arguments: log.id);
            },
          ),
        );
      },
    );
  }
}

// Classe DateUtil (se você não a tiver em core/utils/date_utils.dart)
// É melhor importá-la de lá. Este é apenas um placeholder se não existir.
class DateUtil {
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return '';
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm').format(dt);
  }
}
