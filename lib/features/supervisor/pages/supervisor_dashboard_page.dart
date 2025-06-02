// lib/features/supervisor/presentation/pages/supervisor_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart'; // Para formatação de datas, se necessário
import 'package:lottie/lottie.dart'; // Para animação de lista vazia

// Core
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Domain (para FilterStudentsParams e enums se usados diretamente no diálogo)
import '../../../../domain/repositories/i_supervisor_repository.dart'
    show FilterStudentsParams;

// Bloc
import '../bloc/supervisor_bloc.dart';
import '../bloc/supervisor_event.dart';
import '../bloc/supervisor_state.dart';

// Widgets Compartilhados e Específicos da Feature

import '../widgets/dashboard_summary_cards.dart'; // A ser criado
import '../widgets/student_list_widget.dart'; // A ser criado
import '../widgets/contract_gantt_chart.dart'; // A ser criado

// Charting library (exemplo, substitua pela sua escolha)
import 'package:syncfusion_flutter_charts/charts.dart';

class SupervisorDashboardPage extends StatefulWidget {
  const SupervisorDashboardPage({Key? key}) : super(key: key);

  @override
  State<SupervisorDashboardPage> createState() =>
      _SupervisorDashboardPageState();
}

class _SupervisorDashboardPageState extends State<SupervisorDashboardPage> {
  late SupervisorBloc _supervisorBloc;
  // Para o diálogo de filtro
  final _searchNameController = TextEditingController();
  String? _selectedCourseFilter;
  StudentStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _supervisorBloc = Modular.get<SupervisorBloc>();
    // Carrega os dados iniciais do dashboard
    _supervisorBloc.add(const LoadSupervisorDashboardDataEvent());
  }

  @override
  void dispose() {
    _searchNameController.dispose();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    _supervisorBloc.add(const LoadSupervisorDashboardDataEvent());
  }

  void _showFilterDialog() {
    // Reseta os campos do diálogo para os filtros atuais aplicados (se houver)
    // ou para os valores padrão se o estado atual não for o DashboardLoadSuccess.
    final currentState = _supervisorBloc.state;
    if (currentState is SupervisorDashboardLoadSuccess) {
      // TODO: Se os filtros aplicados estiverem guardados no estado do BLoC,
      // inicialize os controladores/variáveis do diálogo com eles.
      // Ex: _searchNameController.text = currentState.appliedFilters.name ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Usar StatefulBuilder para permitir que o estado do diálogo seja atualizado (ex: Dropdowns)
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filtrar Estudantes'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppTextField(
                      controller: _searchNameController,
                      labelText: 'Nome do Estudante',
                      prefixIcon: Icons.search,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCourseFilter,
                      decoration: const InputDecoration(
                        labelText: 'Curso',
                        prefixIcon: Icon(Icons.school_outlined),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Todos os Cursos'),
                      isExpanded: true,
                      items:
                          [
                                'Ciência da Computação',
                                'Engenharia de Software',
                                'Sistemas de Informação',
                                'Direito',
                                'Administração',
                              ] // Exemplo de lista de cursos
                              .map(
                                (course) => DropdownMenuItem(
                                  value: course,
                                  child: Text(course),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedCourseFilter = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<StudentStatus>(
                      value: _selectedStatusFilter,
                      decoration: const InputDecoration(
                        labelText: 'Status do Estudante',
                        prefixIcon: Icon(Icons.toggle_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Todos os Status'),
                      isExpanded: true,
                      items: StudentStatus.values
                          .where(
                            (status) => status != StudentStatus.unknown,
                          ) // Não mostrar 'unknown'
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.displayName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedStatusFilter = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(AppStrings.clearFilters),
                  onPressed: () {
                    setDialogState(() {
                      _searchNameController.clear();
                      _selectedCourseFilter = null;
                      _selectedStatusFilter = null;
                    });
                    // Dispara o evento de filtro com parâmetros nulos para limpar
                    _supervisorBloc.add(
                      FilterStudentsEvent(params: FilterStudentsParams()),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                ),
                AppButton(
                  text: AppStrings.applyFilters,
                  onPressed: () {
                    _supervisorBloc.add(
                      FilterStudentsEvent(
                        params: FilterStudentsParams(
                          name: _searchNameController.text.trim().isNotEmpty
                              ? _searchNameController.text.trim()
                              : null,
                          course: _selectedCourseFilter,
                          status: _selectedStatusFilter,
                        ),
                      ),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.supervisorDashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            tooltip: 'Filtrar Estudantes',
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Recarregar',
            onPressed: _refreshDashboard,
          ),
        ],
      ),
      drawer: const SupervisorAppDrawer(
        currentIndex: 0,
      ), // Ajuste o currentIndex
      bottomNavigationBar: const SupervisorBottomNavBar(
        currentIndex: 0,
      ), // Ajuste o currentIndex
      body: BlocConsumer<SupervisorBloc, SupervisorState>(
        bloc: _supervisorBloc,
        listener: (context, state) {
          if (state is SupervisorOperationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
          } else if (state is SupervisorOperationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is SupervisorInitial ||
              (state is SupervisorLoading &&
                  state.loadingMessage == null &&
                  state is! SupervisorDashboardLoadSuccess)) {
            // Mostra loading se for o estado inicial ou um loading genérico sem dados prévios de dashboard
            if (_supervisorBloc.state is! SupervisorDashboardLoadSuccess) {
              return const LoadingIndicator();
            }
          }

          if (state is SupervisorLoading &&
              state.loadingMessage != null &&
              _supervisorBloc.state is SupervisorDashboardLoadSuccess) {
            // Mostra um loading sutil (ex: no AppBar) se já temos dados e uma operação está em curso
            // Por agora, o RefreshIndicator já cobre isso.
          }

          if (state is SupervisorDashboardLoadSuccess) {
            return _buildDashboardContent(context, state);
          }

          if (state is SupervisorOperationFailure &&
              _supervisorBloc.state is! SupervisorDashboardLoadSuccess) {
            return _buildErrorStatePage(context, state.message);
          }

          // Fallback para loading se nenhum outro estado corresponder e estivermos à espera do dashboard
          // ou se o estado for um loading que não é o inicial mas não temos dados de dashboard.
          return const LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildErrorStatePage(BuildContext context, String message) {
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
    SupervisorDashboardLoadSuccess state,
  ) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: ListView(
        // Usar ListView para permitir scroll com RefreshIndicator
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Cartões de Resumo (Widget a ser criado)
          DashboardSummaryCards(stats: state.stats),
          const SizedBox(height: 24),

          // 2. Gráfico de Distribuição de Estudantes (Exemplo com SfCircularChart)
          _buildStudentDistributionChart(context, state.stats),
          const SizedBox(height: 24),

          // 3. Toggle de Visualização (Lista vs Gantt)
          _buildViewToggle(context, state.showGanttView),
          const SizedBox(height: 16),

          // 4. Conteúdo Principal (Lista de Estudantes ou Gráfico de Gantt)
          if (state.students.isEmpty &&
              !(_supervisorBloc.state is SupervisorLoading))
            _buildEmptyStudentList(context)
          else if (state.showGanttView)
            ContractGanttChart(
              contracts: state.contracts,
              students: state.students,
            ) // Widget a ser criado
          else
            StudentListWidget(students: state.students), // Widget a ser criado

          const SizedBox(height: 24),
          // TODO: Adicionar secção de Aprovações Pendentes, se desejado aqui
          // Ex: _buildPendingApprovalsSection(context)
        ],
      ),
    );
  }

  Widget _buildStudentDistributionChart(
    BuildContext context,
    SupervisorDashboardStats stats,
  ) {
    final theme = Theme.of(context);
    final List<ChartData> chartData = [
      if (stats.activeStudents > 0)
        ChartData(
          'Ativos',
          stats.activeStudents.toDouble(),
          AppColors.statusActive,
        ),
      if (stats.inactiveStudents > 0)
        ChartData(
          'Inativos',
          stats.inactiveStudents.toDouble(),
          AppColors.statusInactive,
        ),
      if (stats.expiringContractsSoon > 0)
        ChartData(
          'Vencendo',
          stats.expiringContractsSoon.toDouble(),
          AppColors.statusPending,
        ),
    ];

    if (chartData.isEmpty && stats.totalStudents == 0) {
      return const SizedBox.shrink();
    }
    if (chartData.isEmpty && stats.totalStudents > 0) {
      // Caso todos os estudantes não se encaixem nas categorias do gráfico (ex: todos "Concluídos")
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Total de Estudantes: ${stats.totalStudents}\n(Sem dados para o gráfico de distribuição atual)',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.studentDistribution,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: SfCircularChart(
                legend: const Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                series: <CircularSeries<ChartData, String>>[
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    pointColorMapper: (ChartData data, _) => data.color,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      connectorLineSettings: ConnectorLineSettings(
                        type: ConnectorType.line,
                        length: '10%',
                      ),
                    ),
                    dataLabelMapper: (ChartData data, _) =>
                        '${data.x}\n${data.y.toInt()}',
                    explode: true,
                    explodeIndex: 0, // Destaca a primeira fatia
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context, bool isGanttView) {
    final theme = Theme.of(context);
    return ToggleButtons(
      isSelected: [!isGanttView, isGanttView],
      onPressed: (index) {
        _supervisorBloc.add(
          ToggleDashboardViewEvent(showGanttView: index == 1),
        );
      },
      borderRadius: BorderRadius.circular(8.0),
      selectedBorderColor: theme.colorScheme.primary,
      selectedColor: theme.colorScheme.onPrimary,
      fillColor: theme.colorScheme.primary,
      color: theme.colorScheme.primary,
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: (MediaQuery.of(context).size.width - 48) / 2,
      ),
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list_alt),
              SizedBox(width: 8),
              Text(AppStrings.studentList),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart_rounded),
              SizedBox(width: 8),
              Text(AppStrings.ganttView),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStudentList(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/empty_folder.json', // Use uma animação apropriada
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.noStudentsFound,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou adicione novos estudantes.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Adicionar Estudante', // TODO: Implementar ação
              icon: Icons.add_circle_outline,
              onPressed: () {
                Modular.to.pushNamed('/supervisor/student-create');
              },
              type: AppButtonType.outlined,
            ),
          ],
        ),
      ),
    );
  }
}

// Classe auxiliar para dados do gráfico
class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
