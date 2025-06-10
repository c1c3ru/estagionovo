// lib/features/student/presentation/bloc/student_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../../domain/entities/student_entity.dart';
import '../../../../domain/entities/time_log_entity.dart';
import '../../../../domain/entities/contract_entity.dart';

// Usecases do Estudante
import '../../../../domain/usecases/student/get_student_details_usecase.dart';
import '../../../../domain/usecases/student/update_student_profile_usecase.dart';
import '../../../../domain/usecases/student/check_in_usecase.dart';
import '../../../../domain/usecases/student/check_out_usecase.dart';

// Usecases de TimeLog (podem vir de IStudentRepository ou ITimeLogRepository)
import '../../../../domain/usecases/student/get_student_time_logs_usecase.dart';
import '../../../../domain/usecases/student/create_time_log_usecase.dart';
import '../../../../domain/usecases/student/update_time_log_usecase.dart';
import '../../../../domain/usecases/student/delete_time_log_usecase.dart';
// Usecase para buscar log ativo (precisaria ser definido no domínio e repositório)

// Usecases de Contrato
import '../../../../domain/usecases/contract/get_contracts_for_student_usecase.dart';

// Repositório (para os parâmetros dos usecases)
import '../../../../domain/repositories/i_student_repository.dart'
    show UpdateStudentProfileParams;

import 'student_event.dart';
import 'student_state.dart';

// Importe o logger se for usar
// import '../../../../core/utils/logger_utils.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  // Usecases do Estudante
  final GetStudentDetailsUsecase _getStudentDetailsUsecase;
  final UpdateStudentProfileUsecase _updateStudentProfileUsecase;
  final CheckInUsecase _checkInUsecase;
  final CheckOutUsecase _checkOutUsecase;

  // Usecases de TimeLog
  final GetStudentTimeLogsUsecase _getStudentTimeLogsUsecase;
  final CreateTimeLogUsecase _createTimeLogUsecase;
  final DeleteTimeLogUsecase _deleteTimeLogUsecase;
  // final GetActiveTimeLogForStudentUsecase _getActiveTimeLogForStudentUsecase; // Para buscar log ativo

  // Usecases de Contrato
  final GetContractsForStudentUsecase _getContractsForStudentUsecase;

  StudentBloc({
    required GetStudentDetailsUsecase getStudentDetailsUsecase,
    required UpdateStudentProfileUsecase updateStudentProfileUsecase,
    required CheckInUsecase checkInUsecase,
    required CheckOutUsecase checkOutUsecase,
    required GetStudentTimeLogsUsecase getStudentTimeLogsUsecase,
    required CreateTimeLogUsecase createTimeLogUsecase,
    required UpdateTimeLogUsecase updateTimeLogUsecase,
    required DeleteTimeLogUsecase deleteTimeLogUsecase,
    // required GetActiveTimeLogForStudentUsecase getActiveTimeLogForStudentUsecase,
    required GetContractsForStudentUsecase getContractsForStudentUsecase,
  })  : _getStudentDetailsUsecase = getStudentDetailsUsecase,
        _updateStudentProfileUsecase = updateStudentProfileUsecase,
        _checkInUsecase = checkInUsecase,
        _checkOutUsecase = checkOutUsecase,
        _getStudentTimeLogsUsecase = getStudentTimeLogsUsecase,
        _createTimeLogUsecase = createTimeLogUsecase,
        _deleteTimeLogUsecase = deleteTimeLogUsecase,
        // _getActiveTimeLogForStudentUsecase = getActiveTimeLogForStudentUsecase,
        _getContractsForStudentUsecase = getContractsForStudentUsecase,
        super(const StudentInitial()) {
    on<LoadStudentDashboardDataEvent>(_onLoadStudentDashboardData);
    on<UpdateStudentProfileInfoEvent>(_onUpdateStudentProfileInfo);
    on<StudentCheckInEvent>(_onStudentCheckIn);
    on<StudentCheckOutEvent>(_onStudentCheckOut);
    on<LoadStudentTimeLogsEvent>(_onLoadStudentTimeLogs);
    on<CreateManualTimeLogEvent>(_onCreateManualTimeLog);
    on<UpdateManualTimeLogEvent>(_onUpdateManualTimeLog);
    on<DeleteTimeLogRequestedEvent>(_onDeleteTimeLogRequested);
    on<FetchActiveTimeLogEvent>(_onFetchActiveTimeLog);
  }

  Future<void> _onLoadStudentDashboardData(
    LoadStudentDashboardDataEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // 1. Buscar detalhes do estudante
      final studentDetailsResult =
          await _getStudentDetailsUsecase.call(event.userId);
      final StudentEntity student = await studentDetailsResult.fold(
        (failure) => throw failure, // Lança para o catch do BLoC
        (student) => student,
      );

      // 2. Buscar logs de tempo recentes e calcular horas da semana
      // (Exemplo: últimos 5 logs e horas da semana atual)
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek
          .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final timeLogsResult = await _getStudentTimeLogsUsecase.call(
        studentId: event.userId,
        // Para o dashboard, podemos pegar todos da semana atual ou um limite
        startDate: startOfWeek,
        endDate: endOfWeek,
      );

      List<TimeLogEntity> allLogsThisWeek = [];
      timeLogsResult.fold(
        (failure) => throw failure,
        (logs) => allLogsThisWeek = logs,
      );

      double hoursThisWeek = allLogsThisWeek
          .where((log) => log.hoursLogged != null)
          .fold(0.0, (sum, log) => sum + log.hoursLogged!);

      // Pega os 5 mais recentes para exibição (já ordenados pelo repositório/datasource)
      List<TimeLogEntity> recentLogs = allLogsThisWeek.take(5).toList();

      // 3. Buscar contratos do estudante
      final contractsResult =
          await _getContractsForStudentUsecase.call(event.userId);
      List<ContractEntity> contracts = [];
      contractsResult.fold(
        (failure) =>
            throw failure, // Ou tratar de forma diferente se contratos não forem críticos
        (contractList) => contracts = contractList,
      );

      // 4. Buscar log de tempo ativo (se houver)
      // Para isso, o GetStudentTimeLogsUsecase pode ser adaptado ou um novo usecase/método no repo.
      // Assumindo que getStudentTimeLogs pode retornar logs sem checkout_time.
      TimeLogEntity? activeTimeLog;
      final allTimeLogsResult =
          await _getStudentTimeLogsUsecase.call(studentId: event.userId);
      allTimeLogsResult.fold((failure) {
        /* não faz nada, continua sem active log */
      }, (logs) {
        // ignore: cast_from_null_always_fails
        activeTimeLog = logs.firstWhere((log) => log.checkOutTime == null,
            orElse: () => null as TimeLogEntity);
      });

      emit(StudentDashboardLoadSuccess(
        student: student,
        timeStats: StudentTimeStats(
          hoursThisWeek: hoursThisWeek,
          recentLogs: recentLogs,
          activeTimeLog: activeTimeLog,
        ),
        contracts: contracts,
      ));
    } catch (e) {
      // logger.e('Erro ao carregar dados do dashboard do estudante', error: e);
      emit(StudentOperationFailure(
          message: e is AppFailure
              ? e.message
              : 'Erro desconhecido ao carregar dados do dashboard.'));
    }
  }

  Future<void> _onUpdateStudentProfileInfo(
    UpdateStudentProfileInfoEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await _updateStudentProfileUsecase.call(
      UpdateStudentProfileParams(
        // Usando o Params do repositório
        studentId: event.userId,
        fullName: event.params.fullName,
        registrationNumber: event.params.registrationNumber,
        course: event.params.course,
        advisorName: event.params.advisorName,
        isMandatoryInternship: event.params.isMandatoryInternship,
        profilePictureUrl: event.params.profilePictureUrl,
        phoneNumber: event.params.phoneNumber,
        birthDate: event.params.birthDate, // Adicionado
        classShift: event.params.classShift, // Adicionado
      ),
    );
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (updatedStudent) {
        emit(StudentProfileUpdateSuccess(updatedStudent: updatedStudent));
        // Atualizar o estado do dashboard se ele já estiver carregado
        if (state is StudentDashboardLoadSuccess) {
          final currentDashboardState = state as StudentDashboardLoadSuccess;
          emit(currentDashboardState.copyWith(student: updatedStudent));
        }
      },
    );
  }

  Future<void> _onStudentCheckIn(
    StudentCheckInEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await _checkInUsecase.call(
      studentId: event.userId,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (timeLog) {
        emit(StudentTimeLogOperationSuccess(
            timeLog: timeLog, message: 'Check-in realizado com sucesso!'));
        // Se o dashboard estiver carregado, atualiza o activeTimeLog
        if (state is StudentDashboardLoadSuccess) {
          final dashboardState = state as StudentDashboardLoadSuccess;
          emit(dashboardState.copyWith(
              timeStats:
                  dashboardState.timeStats.copyWith(activeTimeLog: timeLog)));
        } else if (state is ActiveTimeLogFetched) {
          // Se um estado específico de log ativo existir
          emit(ActiveTimeLogFetched(activeTimeLog: timeLog));
        }
      },
    );
  }

  Future<void> _onStudentCheckOut(
    StudentCheckOutEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await _checkOutUsecase.call(
      studentId: event.userId,
      activeTimeLogId: event.activeTimeLogId,
      description: event.description,
    );
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (timeLog) {
        emit(StudentTimeLogOperationSuccess(
            timeLog: timeLog, message: 'Check-out realizado com sucesso!'));
        // Se o dashboard estiver carregado, limpa o activeTimeLog
        if (state is StudentDashboardLoadSuccess) {
          final dashboardState = state as StudentDashboardLoadSuccess;
          emit(dashboardState.copyWith(
              timeStats:
                  dashboardState.timeStats.copyWith(clearActiveTimeLog: true)));
        } else if (state is ActiveTimeLogFetched) {
          emit(const ActiveTimeLogFetched(activeTimeLog: null));
        }
      },
    );
  }

  Future<void> _onLoadStudentTimeLogs(
    LoadStudentTimeLogsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await _getStudentTimeLogsUsecase.call(
      studentId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
    );
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (timeLogs) => emit(StudentTimeLogsLoadSuccess(timeLogs: timeLogs)),
    );
  }

  Future<void> _onCreateManualTimeLog(
    CreateManualTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await _createTimeLogUsecase.call(
      studentId: event.userId,
      logDate: event.logDate,
      checkInTime: event.checkInTime,
      checkOutTime: event.checkOutTime,
      description: event.description,
    );
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (timeLog) => emit(StudentTimeLogOperationSuccess(
          timeLog: timeLog, message: 'Registo de tempo criado com sucesso!')),
    );
  }

  Future<void> _onUpdateManualTimeLog(
    UpdateManualTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    // A interface IStudentRepository.updateTimeLog espera um TimeLogEntity completo.
    // O UpdateTimeLogUsecase (que usa IStudentRepository) também.
    // Para implementar corretamente, precisamos buscar o log, aplicar as mudanças e enviar.

    // Etapa 1: Buscar o log de tempo existente
    // Supondo que temos um usecase para buscar por ID, ou o repositório diretamente.
    // Para simplificar, se o TimeLogUsecase (que não está injetado) tivesse um getById, usaríamos.
    // Como não temos, vamos emitir um erro por agora, ou teríamos que adicionar um GetTimeLogByIdUsecase.
    // A alternativa seria modificar o UpdateTimeLogUsecase para aceitar campos parciais,
    // o que exigiria uma mudança na cadeia até o datasource.

    // Vamos assumir que o evento precisaria ser redesenhado para passar o TimeLogEntity original,
    // ou que a UI que dispara este evento já tem a entidade.
    // Por agora, esta funcionalidade não pode ser completada sem mais informações ou refatoração.
    emit(const StudentOperationFailure(
        message:
            'Atualização de log manual: buscar log original antes de atualizar não implementado neste BLoC.'));
  }

  Future<void> _onDeleteTimeLogRequested(
    DeleteTimeLogRequestedEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await _deleteTimeLogUsecase.call(event.timeLogId);
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (_) => emit(const StudentTimeLogDeleteSuccess()),
    );
  }

  Future<void> _onFetchActiveTimeLog(
    FetchActiveTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    final result =
        await _getStudentTimeLogsUsecase.call(studentId: event.userId);
    result.fold(
      (failure) => emit(StudentOperationFailure(message: failure.message)),
      (logs) {
        TimeLogEntity? activeLog;
        try {
          activeLog = logs.firstWhere((log) => log.checkOutTime == null,
              // ignore: cast_from_null_always_fails
              orElse: () => null as TimeLogEntity);
        } catch (e) {
          activeLog = null;
        }
        emit(ActiveTimeLogFetched(activeTimeLog: activeLog));
        if (state is StudentDashboardLoadSuccess) {
          final dashboardState = state as StudentDashboardLoadSuccess;
          emit(dashboardState.copyWith(
              timeStats:
                  dashboardState.timeStats.copyWith(activeTimeLog: activeLog)));
        }
      },
    );
  }
}
