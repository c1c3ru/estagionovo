import 'dart:async';
import 'package:estagio/core/enum/user_role.dart';
import 'package:estagio/domain/entities/student.dart';
import 'package:estagio/features/supervisor/bloc/supervisor_event.dart';
import 'package:estagio/features/supervisor/bloc/supervisor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../../domain/entities/student_entity.dart'
    hide StudentStatus, StudentEntity;
import '../../../../domain/entities/supervisor_entity.dart';
import '../../../../domain/entities/time_log_entity.dart';
import '../../../../domain/entities/contract_entity.dart';

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
import '../../../../domain/usecases/contract/delete_contract_usecase.dart';

// Usecases de Auth
import '../../../../domain/usecases/auth/register_usecase.dart';
import '../../../../domain/repositories/i_auth_repository.dart'
    show RegisterParams;
import '../../../../domain/repositories/i_supervisor_repository.dart'
    show FilterStudentsParams;
import '../../../../domain/repositories/i_contract_repository.dart'
    show UpsertContractParams;

class SupervisorBloc extends Bloc<SupervisorEvent, SupervisorState> {
  // Usecases
  final GetSupervisorDetailsUsecase _getSupervisorDetailsUsecase;
  final GetAllStudentsForSupervisorUsecase _getAllStudentsForSupervisorUsecase;
  final GetStudentDetailsForSupervisorUsecase
      _getStudentDetailsForSupervisorUsecase;
  final CreateStudentBySupervisorUsecase _createStudentBySupervisorUsecase;
  final UpdateStudentBySupervisorUsecase _updateStudentBySupervisorUsecase;
  final DeleteStudentBySupervisorUsecase _deleteStudentBySupervisorUsecase;
  final GetAllTimeLogsForSupervisorUsecase _getAllTimeLogsForSupervisorUsecase;
  final ApproveOrRejectTimeLogUsecase _approveOrRejectTimeLogUsecase;
  final GetAllContractsUsecase _getAllContractsUsecase;
  final CreateContractUsecase _createContractUsecase;
  final UpdateContractUsecase _updateContractUsecase;
  final DeleteContractUsecase _deleteContractUsecase;
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
  })  : _getSupervisorDetailsUsecase = getSupervisorDetailsUsecase,
        _getAllStudentsForSupervisorUsecase =
            getAllStudentsForSupervisorUsecase,
        _getStudentDetailsForSupervisorUsecase =
            getStudentDetailsForSupervisorUsecase,
        _createStudentBySupervisorUsecase = createStudentBySupervisorUsecase,
        _updateStudentBySupervisorUsecase = updateStudentBySupervisorUsecase,
        _deleteStudentBySupervisorUsecase = deleteStudentBySupervisorUsecase,
        _getAllTimeLogsForSupervisorUsecase =
            getAllTimeLogsForSupervisorUsecase,
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
        _onLoadStudentDetailsForSupervisor);
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
    if (state is! SupervisorDashboardLoadSuccess) {
      emit(const SupervisorLoading(
          loadingMessage: 'A carregar dados do dashboard...'));
    }

    try {
      final results = await Future.wait([
        _getAllStudentsForSupervisorUsecase.call(null),
        _getAllContractsUsecase.call(GetAllContractsParams()),
        _getAllTimeLogsForSupervisorUsecase.call(pendingApprovalOnly: true),
      ]);

      final studentsResult =
          results[0] as Either<AppFailure, List<StudentEntity>>;
      final List<StudentEntity> students = studentsResult.fold(
        (failure) => throw failure,
        (studentList) => studentList,
      );

      final contractsResult =
          results[1] as Either<AppFailure, List<ContractEntity>>;
      final List<ContractEntity> contracts = contractsResult.fold(
        (failure) => throw failure,
        (contractList) => contractList,
      );

      final timeLogsResult =
          results[2] as Either<AppFailure, List<TimeLogEntity>>;
      final List<TimeLogEntity> pendingApprovals = timeLogsResult.fold(
        (failure) => throw failure,
        (timeLogList) => timeLogList,
      );

      final now = DateTime.now();
      final activeStudents =
          students.where((s) => s.status == StudentStatus.active).length;
      final inactiveStudents =
          students.where((s) => s.status == StudentStatus.inactive).length;
      final expiringContractsSoon = contracts
          .where((c) =>
              c.endDate.isAfter(now) &&
              c.endDate.isBefore(now.add(const Duration(days: 30))))
          .length;

      final stats = SupervisorDashboardStats(
        totalStudents: students.length,
        activeStudents: activeStudents,
        inactiveStudents: inactiveStudents,
        expiringContractsSoon: expiringContractsSoon,
      );

      emit(SupervisorDashboardLoadSuccess(
        students: students,
        contracts: contracts,
        stats: stats,
        pendingApprovals: pendingApprovals,
        showGanttView: (state is SupervisorDashboardLoadSuccess)
            ? (state as SupervisorDashboardLoadSuccess).showGanttView
            : false,
      ));
    } on AppFailure catch (e) {
      emit(SupervisorOperationFailure(message: e.message));
    } catch (e) {
      emit(SupervisorOperationFailure(
          message:
              'Ocorreu um erro inesperado ao carregar o dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onFilterStudents(
    FilterStudentsEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SupervisorDashboardLoadSuccess) {
      emit(currentState.copyWith(isLoading: true));

      final result =
          await _getAllStudentsForSupervisorUsecase.call(event.params);

      result.fold(
        (failure) => emit(SupervisorOperationFailure(message: failure.message)),
        (filteredStudents) {
          emit(currentState.copyWith(
            students: filteredStudents,
            isLoading: false,
            appliedFilters: event.params,
          ));
        },
      );
    } else {
      add(const LoadSupervisorDashboardDataEvent());
    }
  }

  Future<void> _onApproveOrRejectTimeLog(
    ApproveOrRejectTimeLogEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SupervisorDashboardLoadSuccess) {
      // **IMPROVEMENT**: Optimistically update the UI before making the network call
      // to provide immediate feedback.
      final originalApprovals =
          List<TimeLogEntity>.from(currentState.pendingApprovals);
      final updatedApprovals = originalApprovals
        ..removeWhere((log) => log.id == event.timeLogId);

      emit(currentState.copyWith(pendingApprovals: updatedApprovals));

      // **TODO**: Obter o ID do supervisor a partir do seu serviço de autenticação (ex: AuthBloc)
      // em vez de o passar a partir da UI.
      const supervisorId = "get-real-supervisor-id-from-auth-service";

      final result = await _approveOrRejectTimeLogUsecase.call(
        timeLogId: event.timeLogId,
        approved: event.isApproved,
        supervisorId: supervisorId,
      );

      result.fold(
        (failure) {
          // If the operation fails, revert the state and show an error.
          emit(currentState.copyWith(pendingApprovals: originalApprovals));
          emit(SupervisorOperationFailure(message: failure.message));
        },
        (updatedTimeLog) {
          emit(SupervisorOperationSuccess(
            message: event.isApproved
                ? 'Registo de tempo aprovado!'
                : 'Registo de tempo rejeitado.',
            entity: updatedTimeLog,
          ));
          // The state is already updated, no need to reload the whole dashboard.
        },
      );
    }
  }

  void _onToggleDashboardView(
    ToggleDashboardViewEvent event,
    Emitter<SupervisorState> emit,
  ) {
    if (state is SupervisorDashboardLoadSuccess) {
      final currentDashboardState = state as SupervisorDashboardLoadSuccess;
      emit(currentDashboardState.copyWith(showGanttView: event.showGanttView));
    }
  }

  // --- Other Event Handlers (unchanged) ---
  Future<void> _onLoadStudentDetailsForSupervisor(
    LoadStudentDetailsForSupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(
        loadingMessage: 'A carregar detalhes do estudante...'));
    try {
      final studentResult =
          await _getStudentDetailsForSupervisorUsecase.call(event.studentId);
      final StudentEntity student = await studentResult.fold(
        (failure) => throw failure,
        (s) => s,
      );

      final timeLogsResult = await _getAllTimeLogsForSupervisorUsecase.call(
          studentId: event.studentId, pendingApprovalOnly: null);
      List<TimeLogEntity> timeLogs = [];
      await timeLogsResult.fold(
        (failure) => throw failure,
        (tl) => timeLogs = tl,
      );

      final contractsResult = await _getAllContractsUsecase
          .call(GetAllContractsParams(studentId: event.studentId));
      List<ContractEntity> contracts = [];
      await contractsResult.fold(
        (failure) => throw failure,
        (c) => contracts = c,
      );

      emit(SupervisorStudentDetailsLoadSuccess(
        student: student,
        timeLogs: timeLogs,
        contracts: contracts,
      ));
    } catch (e) {
      emit(SupervisorOperationFailure(
          message: e is AppFailure
              ? e.message
              : 'Erro ao carregar detalhes do estudante.'));
    }
  }

  Future<void> _onCreateStudentBySupervisor(
    CreateStudentBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A criar estudante...'));

    final authResult = await _registerAuthUserUsecase.call(RegisterParams(
      email: event.initialEmail,
      password: event.initialPassword,
      fullName: event.studentData.fullName,
      role: UserRole.student,
    ));

    await authResult.fold(
      (failure) async {
        emit(SupervisorOperationFailure(
            message:
                'Falha ao criar utilizador de autenticação: ${failure.message}'));
      },
      (authUserEntity) async {
        try {
          final studentToCreate =
              event.studentData.copyWith(id: authUserEntity.id);

          final studentProfileResult = await _createStudentBySupervisorUsecase
              .call(studentToCreate as StudentEntity);

          studentProfileResult.fold(
            (profileFailure) {
              emit(SupervisorOperationFailure(
                  message:
                      'Utilizador auth criado, mas falha ao criar perfil de estudante: ${profileFailure.message}'));
            },
            (createdStudent) {
              emit(SupervisorOperationSuccess(
                  message: 'Estudante criado com sucesso!',
                  entity: createdStudent));
              add(const LoadSupervisorDashboardDataEvent());
            },
          );
        } catch (e) {
          emit(SupervisorOperationFailure(
              message: e is AppFailure
                  ? e.message
                  : 'Erro ao criar perfil de estudante.'));
        }
      },
    );
  }

  Future<void> _onUpdateStudentBySupervisor(
    UpdateStudentBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A atualizar estudante...'));
    final result = await _updateStudentBySupervisorUsecase
        .call(event.studentData as StudentEntity);
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (updatedStudent) {
        emit(SupervisorOperationSuccess(
            message: 'Estudante atualizado com sucesso!',
            entity: updatedStudent));
        add(const LoadSupervisorDashboardDataEvent());
      },
    );
  }

  Future<void> _onDeleteStudentBySupervisor(
    DeleteStudentBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A remover estudante...'));
    final result =
        await _deleteStudentBySupervisorUsecase.call(event.studentId);
    result.fold(
      (failure) => emit(SupervisorOperationFailure(message: failure.message)),
      (_) {
        emit(const SupervisorOperationSuccess(
            message: 'Estudante removido com sucesso!'));
        add(const LoadSupervisorDashboardDataEvent());
      },
    );
  }

  Future<void> _onLoadAllTimeLogsForApproval(
    LoadAllTimeLogsForApprovalEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(
        loadingMessage: 'A carregar registos de tempo...'));
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

  Future<void> _onLoadAllContracts(
    LoadAllContractsEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A carregar contratos...'));
    final result = await _getAllContractsUsecase.call(GetAllContractsParams(
      studentId: event.studentIdFilter,
      status: event.statusFilter,
    ));
    result.fold(
        (failure) => emit(SupervisorOperationFailure(message: failure.message)),
        (contracts) {
      if (state is SupervisorDashboardLoadSuccess) {
        emit((state as SupervisorDashboardLoadSuccess)
            .copyWith(contracts: contracts));
      } else {
        emit(SupervisorContractsLoadSuccess(contracts: contracts));
      }
    });
  }

  Future<void> _onCreateContractBySupervisor(
    CreateContractBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A criar contrato...'));
    final result = await _createContractUsecase.call(UpsertContractParams(
      studentId: event.contractData.studentId,
      supervisorId: event.contractData.supervisorId,
      contractType: event.contractData.contractType,
      status: event.contractData.status,
      startDate: event.contractData.startDate,
      endDate: event.contractData.endDate,
      description: event.contractData.description,
      documentUrl: event.contractData.documentUrl,
      createdBy: event.createdBySupervisorId,
    ));
    result.fold(
        (failure) => emit(SupervisorOperationFailure(message: failure.message)),
        (newContract) {
      emit(SupervisorOperationSuccess(
          message: 'Contrato criado com sucesso!', entity: newContract));
      add(const LoadSupervisorDashboardDataEvent());
    });
  }

  Future<void> _onUpdateContractBySupervisor(
    UpdateContractBySupervisorEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(const SupervisorLoading(loadingMessage: 'A atualizar contrato...'));
    final result = await _updateContractUsecase.call(UpsertContractParams(
      id: event.contractData.id,
      studentId: event.contractData.studentId,
      supervisorId: event.contractData.supervisorId,
      contractType: event.contractData.contractType,
      status: event.contractData.status,
      startDate: event.contractData.startDate,
      endDate: event.contractData.endDate,
      description: event.contractData.description,
      documentUrl: event.contractData.documentUrl,
      createdBy: event.updatedBySupervisorId,
    ));
    result.fold(
        (failure) => emit(SupervisorOperationFailure(message: failure.message)),
        (updatedContract) {
      emit(SupervisorOperationSuccess(
          message: 'Contrato atualizado com sucesso!',
          entity: updatedContract));
      add(const LoadSupervisorDashboardDataEvent());
    });
  }
}
