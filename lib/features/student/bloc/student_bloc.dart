import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/student/get_student_dashboard_usecase.dart';
import '../../../domain/entities/student_entity.dart';
import '../../../domain/entities/contract_entity.dart';
import '../../../core/enums/class_shift.dart';
import '../../../core/enums/internship_shift.dart';
import '../../../core/enums/student_status.dart';

// Importar eventos e estados dos arquivos separados
import 'student_event.dart';
import 'student_state.dart';

// BLoC
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final GetStudentDashboardUsecase _getStudentDashboardUsecase;

  StudentBloc({
    required GetStudentDashboardUsecase getStudentDashboardUsecase,
  })  : _getStudentDashboardUsecase = getStudentDashboardUsecase,
        super(const StudentInitial()) {
    // Registrar handlers para os eventos
    on<LoadStudentDashboardDataEvent>(_onLoadStudentDashboardData);
    on<UpdateStudentProfileInfoEvent>(_onUpdateStudentProfileInfo);
    on<StudentCheckInEvent>(_onStudentCheckIn);
    on<StudentCheckOutEvent>(_onStudentCheckOut);
    on<LoadStudentTimeLogsEvent>(_onLoadStudentTimeLogs);
    on<CreateManualTimeLogEvent>(_onCreateManualTimeLog);
    on<UpdateManualTimeLogEvent>(_onUpdateManualTimeLog);
    on<DeleteTimeLogRequestedEvent>(_onDeleteTimeLog);
    on<FetchActiveTimeLogEvent>(_onFetchActiveTimeLog);
  }

  // Implementar os handlers dos eventos
  Future<void> _onLoadStudentDashboardData(
    LoadStudentDashboardDataEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());

    try {
      // Usar o use case para carregar dados do dashboard
      final result = await _getStudentDashboardUsecase(event.userId);

      result.fold(
        (failure) => emit(StudentOperationFailure(message: failure.message)),
        (dashboardData) {
          // Criar StudentEntity a partir dos dados do dashboard
          final studentData = dashboardData['student'] as Map<String, dynamic>;
          final student = StudentEntity(
            id: studentData['id'],
            userId: studentData['userId'],
            fullName: studentData['fullName'],
            email: studentData['email'],
            course: studentData['course'],
            advisorName: studentData['advisorName'],
            registrationNumber: studentData['registrationNumber'],
            isMandatoryInternship: studentData['isMandatoryInternship'],
            classShift: ClassShift.values.firstWhere(
              (e) => e.name == studentData['classShift'],
              orElse: () => ClassShift.morning,
            ),
            internshipShift:
                InternshipShift.fromString(studentData['internshipShift']),
            supervisorId: studentData['supervisorId'],
            totalHoursCompleted: studentData['totalHoursCompleted'].toDouble(),
            totalHoursRequired: studentData['totalHoursRequired'].toDouble(),
            weeklyHoursTarget: studentData['weeklyHoursTarget'].toDouble(),
            contractStartDate: DateTime.parse(studentData['contractStartDate']),
            contractEndDate: DateTime.parse(studentData['contractEndDate']),
            isOnTrack: studentData['isOnTrack'],
            createdAt: DateTime.parse(studentData['createdAt']),
            updatedAt: DateTime.parse(studentData['updatedAt']),
          );

          final timeStats = const StudentTimeStats();
          final contracts = <ContractEntity>[];

          emit(StudentDashboardLoadSuccess(
            student: student,
            timeStats: timeStats,
            contracts: contracts,
          ));
        },
      );
    } catch (e) {
      emit(StudentOperationFailure(message: 'Erro inesperado: $e'));
    }
  }

  Future<void> _onUpdateStudentProfileInfo(
    UpdateStudentProfileInfoEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica para atualizar perfil
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onStudentCheckIn(
    StudentCheckInEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica de check-in
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onStudentCheckOut(
    StudentCheckOutEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica de check-out
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onLoadStudentTimeLogs(
    LoadStudentTimeLogsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica para carregar logs de tempo
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCreateManualTimeLog(
    CreateManualTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica para criar log manual
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateManualTimeLog(
    UpdateManualTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica para atualizar log manual
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onDeleteTimeLog(
    DeleteTimeLogRequestedEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica para deletar log
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onFetchActiveTimeLog(
    FetchActiveTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    try {
      // Implementar lógica para buscar log ativo
      emit(const StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }
}
