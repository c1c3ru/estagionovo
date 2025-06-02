// lib/features/supervisor/presentation/bloc/supervisor_bloc.dart
import 'dart:async';
import 'package:estagio/core/enum/user_role.dart';
import 'package:estagio/domain/entities/contract.dart';
import 'package:estagio/domain/entities/student.dart';
import 'package:estagio/domain/entities/time_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/app_exceptions.dart';

// Usecases de Supervisor
import '../../../../domain/usecases/supervisor/get_supervisor_details_usecase.dart';
import '../../../../domain/usecases/supervisor/get_all_students_for_supervisor_usecase.dart';
import '../../../../domain/usecases/supervisor/get_student_details_for_supervisor_usecase.dart';
import '../../../../domain/usecases/supervisor/create_student_by_supervisor_usecase.dart';
import '../../../../domain/usecases/supervisor/update_student_by_supervisor_usecase.dart';
import '../../../../domain/usecases/supervisor/delete_student_by_supervisor_usecase.dart';
import '../../../../domain/usecases/supervisor/get_all_time_logs_for_supervisor_usecase.dart';
import '../../../../domain/usecases/supervisor/approve_or_reject_time_log_usecase.dart';

// Usecases de Contrato (usados pelo Supervisor)
import '../../../../domain/usecases/contract/get_all_contracts_usecase.dart';
import '../../../../domain/usecases/contract/create_contract_usecase.dart';
import '../../../../domain/usecases/contract/update_contract_usecase.dart';
import '../../../../domain/usecases/contract/delete_contract_usecase.dart'; // Se supervisores podem apagar contratos

// Usecases de Auth (para criar o utilizador auth antes de criar o perfil de estudante)
import '../../../../domain/usecases/auth/register_usecase.dart';
import '../../../../domain/repositories/i_auth_repository.dart'
    show RegisterParams; // Para RegisterParams
import '../../../../domain/repositories/i_supervisor_repository.dart'
    show FilterStudentsParams; // Para FilterStudentsParams
import '../../../../domain/repositories/i_contract_repository.dart'
    show UpsertContractParams; // Para UpsertContractParams

import 'supervisor_event.dart';
import 'supervisor_state.dart';
// Importe o logger se for usar
// import '../../../../core/utils/logger_utils.dart';

class SupervisorBloc extends Bloc<SupervisorEvent, SupervisorState> {
  // Usecases de Supervisor
  final GetSupervisorDetailsUsecase _getSupervisorDetailsUsecase;
  final GetAllStudentsForSupervisorUsecase _getAllStudentsForSupervisorUsecase;
  final GetStudentDetailsForSupervisorUsecase
  _getStudentDetailsForSupervisorUsecase;
  final CreateStudentBySupervisorUsecase _createStudentBySupervisorUsecase;
  final UpdateStudentBySupervisorUsecase _updateStudentBySupervisorUsecase;
  final DeleteStudentBySupervisorUsecase _deleteStudentBySupervisorUsecase;
  final GetAllTimeLogsForSupervisorUsecase _getAllTimeLogsForSupervisorUsecase;
  final ApproveOrRejectTimeLogUsecase _approveOrRejectTimeLogUsecase;

  // Usecases de Contrato
  final GetAllContractsUsecase _getAllContractsUsecase;
  final CreateContractUsecase _createContractUsecase;
  final UpdateContractUsecase _updateContractUsecase;
  final DeleteContractUsecase _deleteContractUsecase; // Adicionado

  // Usecase de Auth (para registar o utilizador auth do estudante)
  final RegisterUsecase _registerAuthUserUsecase;

  SupervisorBloc({
    required GetSupervisorDetailsUsecase getSupervisorDetailsUsecase,
    required GetAllStudentsForSupervisorUsecase
    getAllStudentsForSupervisorUsecase,
    required GetStudentDetailsForSupervisorUsecase
    getStudentDetailsForSupervisorUsecase,
    required CreateStudentBySupervisorUsecase createStudentBySupervisorUsecase,
    required UpdateStudentBySupervisorUsecase updateStudentBySupervisorUsecase,
    required DeleteStudentBySupervisorUsecase deleteStudentBySupervisorUsecase,
    required GetAllTimeLogsForSupervisorUsecase
    getAllTimeLogsForSupervisorUsecase,
    required ApproveOrRejectTimeLogUsecase approveOrRejectTimeLogUsecase,
    required GetAllContractsUsecase getAllContractsUsecase,
    required CreateContractUsecase createContractUsecase,
    required UpdateContractUsecase updateContractUsecase,
    required DeleteContractUsecase deleteContractUsecase,
    required RegisterUsecase registerAuthUserUsecase,
  }) : _getSupervisorDetailsUsecase = getSupervisorDetailsUsecase,
       _getAllStudentsForSupervisorUsecase = getAllStudentsForSupervisorUsecase,
       _getStudentDetailsForSupervisorUsecase =
           getStudentDetailsForSupervisorUsecase,
       _createStudentBySupervisorUsecase = createStudentBySupervisorUsecase,
       _updateStudentBySupervisorUsecase = updateStudentBySupervisorUsecase,
       _deleteStudentBySupervisorUsecase = deleteStudentBySupervisorUsecase,
       _getAllTimeLogsForSupervisorUsecase = getAllTimeLogsForSupervisorUsecase,
       _approveOrRejectTimeLogUsecase = approveOrRejectTimeLogUsecase,
       _getAllContractsUsecase = getAllContractsUsecase,
       _createContractUsecase = createContractUsecase,
       _updateContractUsecase = updateContractUsecase,
       _deleteContractUsecase = deleteContractUsecase,
       _registerAuthUserUsecase = registerAuthUserUsecase,
       super(const SupervisorInitial()) {
    on<LoadSupervisorDashboardDataEvent>(_onLoadSupervisorDashboardData);
    on<FilterStudentsEvent>(_onFilterStudents);
    on<LoadStudentDetailsForSupervisorEvent>(
      _onLoadStudentDetailsForSupervisor,
    );
    on<CreateStudentBySupervisorEvent>(_onCreateStudentBySupervisor);
    on<UpdateStudentBySupervisorEvent>(_onUpdateStudentBySupervisor);
    on<DeleteStudentBySupervisorEvent>(_onDeleteStudentBySupervisor);
    on<LoadAllTimeLogsForApprovalEvent>(_onLoadAllTimeLogsForApproval);
    on<ApproveOrRejectTimeLogEvent>(_onApproveOrRejectTimeLog);
    on<LoadAllContractsEvent>(_onLoadAllContracts);
    on<CreateContractBySupervisorEvent>(_onCreateContractBySupervisor);
    on<UpdateContractBySupervisorEvent>(_onUpdateContractBySupervisor);
    on<ToggleDashboardViewEvent>(_onToggleDashboardView);
  }

  Future<void> _onLoadSupervisorDashboardData(
    LoadSupervisorDashboardDataEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(
      const SupervisorLoading(
        loadingMessage: 'A carregar dados do dashboard...',
      ),
    );
    try {
      // TODO: Obter ID do supervisor logado (do AuthBloc ou de um parâmetro do evento)
      // String supervisorId = "obter_id_do_supervisor_logado";
      // final supervisorProfileResult = await _getSupervisorDetailsUsecase.call(supervisorId);
      // SupervisorEntity? supervisorProfile;
      // supervisorProfileResult.fold((l) => null, (r) => supervisorProfile = r);

      // 1. Buscar todos os estudantes (sem filtro inicial)
      final studentsResult = await _getAllStudentsForSupervisorUsecase.call(
        null,
      );
      List<StudentEntity> students = [];
      await studentsResult.fold(
        (failure) => throw failure,
        (studentList) => students = studentList,
      );

      // 2. Buscar todos os contratos (para o Gantt ou visão geral)
      final contractsResult = await _getAllContractsUsecase.call(
        const GetAllContractsParams(),
      ); // Sem filtros
      List<ContractEntity> contracts = [];
      await contractsResult.fold(
        (failure) => throw failure,
        (contractList) => contracts = contractList,
      );

      // 3. Calcular estatísticas
      final now = DateTime.now();
      final activeStudents = students
          .where(
            (s) => s.role == UserRole.student && s.contractEndDate.isAfter(now),
          )
          .length; // Simplificado: ativos se contrato não terminou
      final inactiveStudents = students.length - activeStudents; // Simplificado
      final expiringContractsSoon = contracts
          .where(
            (c) =>
                c.endDate.isAfter(now) &&
                c.endDate.isBefore(now.add(const Duration(days: 30))),
          )
          .length;

      final stats = SupervisorDashboardStats(
        totalStudents: students.length,
        activeStudents: activeStudents,
        inactiveStudents: inactiveStudents,
        expiringContractsSoon: expiringContractsSoon,
      );

      emit(
        SupervisorDashboardLoadSuccess(
          // supervisorProfile: supervisorProfile,
          students: students,
          contracts: contracts,
          stats: stats,
          showGanttView: (state is SupervisorDashboardLoadSuccess)
              ? (state as SupervisorDashboardLoadSuccess).showGanttView
              : false,
        ),
      );
    } catch (e) {
      emit(
        SupervisorOperationFailure(
          message: e is AppFailure
              ? e.message
              : 'Erro ao carregar dados do dashboard.',
        ),
      );
    }
  }

  Future<void> _onFilterStudents(
    FilterStudentsEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    // Mantém os outros dados do dashboard (stats, contracts, view mode) se já carregados
    final currentState = state;
    SupervisorDashboardLoadSuccess? previousDashboardState;
    if (currentState is SupervisorDashboardLoadSuccess) {
      previousDashboardState = currentState;
    }

    emit(SupervisorLoading(loadingMessage: 'A filtrar estudantes...'));
    final result = await _getAllStudentsForSupervisorUsecase.call(event.params);
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (filteredStudents) {
        if (previousDashboardState != null) {
          emit(previousDashboardState.copyWith(students: filteredStudents));
        } else {
          // Se o dashboard não foi carregado antes, precisa carregar tudo
          // Isso é menos provável, pois o filtro geralmente é aplicado sobre dados existentes.
          // Por segurança, poderia chamar LoadSupervisorDashboardDataEvent ou emitir um estado parcial.
          // Para simplificar, assumimos que o dashboard já foi carregado uma vez.
          emit(
            SupervisorDashboardLoadSuccess(
              // Estado parcial, pode precisar de mais dados
              students: filteredStudents,
              contracts: [], // Ou buscar contratos novamente
              stats:
                  const SupervisorDashboardStats(), // Ou buscar stats novamente
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadStudentDetailsForSupervisor(
    LoadStudentDetailsForSupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(
      const SupervisorLoading(
        loadingMessage: 'A carregar detalhes do estudante...',
      ),
    );
    try {
      final studentResult = await _getStudentDetailsForSupervisorUsecase.call(
        event.studentId,
      );
      final StudentEntity student = await studentResult.fold(
        (failure) => throw failure,
        (s) => s,
      );

      final timeLogsResult = await _getAllTimeLogsForSupervisorUsecase.call(
        studentId: event.studentId,
        pendingApprovalOnly: null,
      ); // Todos os logs do estudante
      List<TimeLogEntity> timeLogs = [];
      await timeLogsResult.fold(
        (failure) => throw failure,
        (tl) => timeLogs = tl,
      );

      final contractsResult = await _getAllContractsUsecase.call(
        GetAllContractsParams(studentId: event.studentId),
      );
      List<ContractEntity> contracts = [];
      await contractsResult.fold(
        (failure) => throw failure,
        (c) => contracts = c,
      );

      emit(
        SupervisorStudentDetailsLoadSuccess(
          student: student,
          timeLogs: timeLogs,
          contracts: contracts,
        ),
      );
    } catch (e) {
      emit(
        SupervisorOperationFailure(
          message: e is AppFailure
              ? e.message
              : 'Erro ao carregar detalhes do estudante.',
        ),
      );
    }
  }

  Future<void> _onCreateStudentBySupervisor(
    CreateStudentBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A criar estudante...'));

    // Passo 1: Registar o utilizador no Supabase Auth
    final authResult = await _registerAuthUserUsecase.call(
      RegisterParams(
        email: event.initialEmail,
        password: event.initialPassword,
        fullName: event
            .studentData
            .fullName, // O nome completo também vai para o user_metadata do auth
        role: UserRole.student, // A role é sempre estudante aqui
      ),
    );

    await authResult.fold(
      (failure) async {
        emit(
          SupervisorOperationFailure(
            message:
                'Falha ao criar utilizador de autenticação: ${failure.message}',
          ),
        );
      },
      (authUserEntity) async {
        // authUserEntity é o UserEntity do utilizador auth criado
        try {
          // Passo 2: Criar o perfil de estudante na tabela 'students'
          // A StudentEntity do evento já deve ter o ID do authUserEntity
          // Se não, precisamos copiar com o novo ID.
          final studentToCreate = event.studentData.id == authUserEntity.id
              ? event.studentData
              : event.studentData.copyWith(id: authUserEntity.id);

          final studentProfileResult = await _createStudentBySupervisorUsecase
              .call(studentToCreate);

          studentProfileResult.fold(
            (profileFailure) {
              // TODO: Considerar apagar o utilizador auth se a criação do perfil falhar (rollback)
              emit(
                SupervisorOperationFailure(
                  message:
                      'Utilizador auth criado, mas falha ao criar perfil de estudante: ${profileFailure.message}',
                ),
              );
            },
            (createdStudent) {
              emit(
                SupervisorOperationSuccess(
                  message: 'Estudante criado com sucesso!',
                  entity: createdStudent,
                ),
              );
              // Recarregar dados do dashboard para refletir o novo estudante
              add(const LoadSupervisorDashboardDataEvent());
            },
          );
        } catch (e) {
          emit(
            SupervisorOperationFailure(
              message: e is AppFailure
                  ? e.message
                  : 'Erro ao criar perfil de estudante.',
            ),
          );
        }
      },
    );
  }

  Future<void> _onUpdateStudentBySupervisor(
    UpdateStudentBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A atualizar estudante...'));
    final result = await _updateStudentBySupervisorUsecase.call(
      event.studentData,
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (updatedStudent) {
        emit(
          SupervisorOperationSuccess(
            message: 'Estudante atualizado com sucesso!',
            entity: updatedStudent,
          ),
        );
        add(
          const LoadSupervisorDashboardDataEvent(),
        ); // Recarrega para atualizar a lista
      },
    );
  }

  Future<void> _onDeleteStudentBySupervisor(
    DeleteStudentBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A remover estudante...'));
    // AVISO: Remover um estudante pode exigir a remoção do utilizador no Supabase Auth também.
    // O DeleteStudentBySupervisorUsecase e seu repositório precisam lidar com isso.
    // Se ele apenas remove da tabela 'students', o utilizador auth ainda existirá.
    final result = await _deleteStudentBySupervisorUsecase.call(
      event.studentId,
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (_) {
        emit(
          const SupervisorOperationSuccess(
            message: 'Estudante removido com sucesso!',
          ),
        );
        add(const LoadSupervisorDashboardDataEvent()); // Recarrega
      },
    );
  }

  Future<void> _onLoadAllTimeLogsForApproval(
    LoadAllTimeLogsForApprovalEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(
      const SupervisorLoading(
        loadingMessage: 'A carregar registos de tempo...',
      ),
    );
    final result = await _getAllTimeLogsForSupervisorUsecase.call(
      studentId: event.studentIdFilter,
      pendingApprovalOnly: event.pendingOnly,
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (timeLogs) =>
          emit(SupervisorTimeLogsForApprovalLoadSuccess(timeLogs: timeLogs)),
    );
  }

  Future<void> _onApproveOrRejectTimeLog(
    ApproveOrRejectTimeLogEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    // Não emitir loading aqui para não piscar a UI da lista inteira
    // A UI pode mostrar um indicador no item específico do log.
    final result = await _approveOrRejectTimeLogUsecase.call(
      timeLogId: event.timeLogId,
      approved: event.approved,
      supervisorId: event.supervisorId,
      rejectionReason: event.rejectionReason,
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (updatedTimeLog) {
        emit(
          SupervisorOperationSuccess(
            message: event.approved
                ? 'Registo de tempo aprovado!'
                : 'Registo de tempo rejeitado.',
            entity: updatedTimeLog,
          ),
        );
        // Recarregar a lista de logs para aprovação para refletir a mudança
        // Ou, se o estado atual for SupervisorTimeLogsForApprovalLoadSuccess, atualizá-lo.
        if (state is SupervisorTimeLogsForApprovalLoadSuccess) {
          final currentLogs =
              (state as SupervisorTimeLogsForApprovalLoadSuccess).timeLogs;
          final newLogs = currentLogs
              .map((log) => log.id == updatedTimeLog.id ? updatedTimeLog : log)
              .toList();
          // Se for aprovado/rejeitado e a lista for só de pendentes, pode ser removido
          if ((state as SupervisorTimeLogsForApprovalLoadSuccess).props
                  .contains(true) &&
              updatedTimeLog.approved) {
            // Assumindo que pendingOnly é um prop ou estado
            newLogs.removeWhere((log) => log.id == updatedTimeLog.id);
          }
          emit(SupervisorTimeLogsForApprovalLoadSuccess(timeLogs: newLogs));
        } else {
          // Se não, apenas dispara o evento para recarregar a lista de aprovações
          add(const LoadAllTimeLogsForApprovalEvent(pendingOnly: true));
        }
      },
    );
  }

  Future<void> _onLoadAllContracts(
    LoadAllContractsEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A carregar contratos...'));
    final result = await _getAllContractsUsecase.call(
      GetAllContractsParams(
        studentId: event.studentIdFilter,
        status: event.statusFilter,
      ),
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (contracts) {
        // Se o estado atual for o dashboard, atualiza os contratos lá
        if (state is SupervisorDashboardLoadSuccess) {
          emit(
            (state as SupervisorDashboardLoadSuccess).copyWith(
              contracts: contracts,
            ),
          );
        } else {
          // Se não, emite um estado específico para contratos (se houver uma página só de contratos)
          emit(SupervisorContractsLoadSuccess(contracts: contracts));
        }
      },
    );
  }

  Future<void> _onCreateContractBySupervisor(
    CreateContractBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A criar contrato...'));
    final result = await _createContractUsecase.call(
      UpsertContractParams(
        studentId: event.contractData.studentId,
        supervisorId: event.contractData.supervisorId,
        contractType: event.contractData.contractType,
        status: event.contractData.status,
        startDate: event.contractData.startDate,
        endDate: event.contractData.endDate,
        description: event.contractData.description,
        documentUrl: event.contractData.documentUrl,
        createdBy:
            event.createdBySupervisorId, // ID do supervisor que está a criar
      ),
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (newContract) {
        emit(
          SupervisorOperationSuccess(
            message: 'Contrato criado com sucesso!',
            entity: newContract,
          ),
        );
        add(const LoadSupervisorDashboardDataEvent()); // Recarrega o dashboard
      },
    );
  }

  Future<void> _onUpdateContractBySupervisor(
    UpdateContractBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A atualizar contrato...'));
    final result = await _updateContractUsecase.call(
      UpsertContractParams(
        id: event.contractData.id, // ID do contrato a ser atualizado
        studentId: event.contractData.studentId,
        supervisorId: event.contractData.supervisorId,
        contractType: event.contractData.contractType,
        status: event.contractData.status,
        startDate: event.contractData.startDate,
        endDate: event.contractData.endDate,
        description: event.contractData.description,
        documentUrl: event.contractData.documentUrl,
        createdBy: event
            .updatedBySupervisorId, // Quem está a atualizar (pode ser diferente do created_by original)
      ),
    );
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (updatedContract) {
        emit(
          SupervisorOperationSuccess(
            message: 'Contrato atualizado com sucesso!',
            entity: updatedContract,
          ),
        );
        add(const LoadSupervisorDashboardDataEvent()); // Recarrega o dashboard
      },
    );
  }

  void _onToggleDashboardView(
    ToggleDashboardViewEvent event,
    Emitter<SupervisorState> emit,
  ) {
    if (state is SupervisorDashboardLoadSuccess) {
      final currentDashboardState = state as SupervisorDashboardLoadSuccess;
      emit(currentDashboardState.copyWith(showGanttView: event.showGanttView));
    }
    // Se não estiver no estado de dashboard carregado, este evento pode não ter efeito
    // ou pode precisar de uma lógica para carregar o dashboard primeiro.
  }
}
