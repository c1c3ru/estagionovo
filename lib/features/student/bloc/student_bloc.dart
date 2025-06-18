import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_supervisor_app/domain/usecases/contract/get_contracts_for_student_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/check_in_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/check_out_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/create_time_log_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/delete_time_log_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/get_student_details_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/get_student_time_logs_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/update_student_profile_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/student/update_time_log_usecase.dart';
import '../../../domain/entities/student_entity.dart';
import '../../../domain/usecases/student/get_all_students_usecase.dart';
import '../../../domain/usecases/student/get_student_by_id_usecase.dart';
import '../../../domain/usecases/student/get_student_by_user_id_usecase.dart';
import '../../../domain/usecases/student/create_student_usecase.dart';
import '../../../domain/usecases/student/update_student_usecase.dart';
import '../../../domain/usecases/student/delete_student_usecase.dart';
import '../../../domain/usecases/student/get_students_by_supervisor_usecase.dart';

// Importar eventos e estados dos arquivos separados
import 'student_event.dart';
import 'student_state.dart';

// BLoC
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final GetAllStudentsUsecase _getAllStudentsUsecase;
  final GetStudentByIdUsecase _getStudentByIdUsecase;
  final GetStudentByUserIdUsecase _getStudentByUserIdUsecase;
  final CreateStudentUsecase _createStudentUsecase;
  final UpdateStudentUsecase _updateStudentUsecase;
  final DeleteStudentUsecase _deleteStudentUsecase;
  final GetStudentsBySupervisorUsecase _getStudentsBySupervisorUsecase;
  final GetStudentDetailsUsecase _getStudentDetailsUsecase;
  final UpdateStudentProfileUsecase _updateStudentProfileUsecase;
  final CheckInUsecase _checkInUsecase;
  final CheckOutUsecase _checkOutUsecase;
  final GetStudentTimeLogsUsecase _getStudentTimeLogsUsecase;
  final CreateTimeLogUsecase _createTimeLogUsecase;
  final UpdateTimeLogUsecase _updateTimeLogUsecase;
  final DeleteTimeLogUsecase _deleteTimeLogUsecase;
  final GetContractsForStudentUsecase _getContractsForStudentUsecase;

  StudentBloc({
    required GetAllStudentsUsecase getAllStudentsUsecase,
    required GetStudentByIdUsecase getStudentByIdUsecase,
    required GetStudentByUserIdUsecase getStudentByUserIdUsecase,
    required CreateStudentUsecase createStudentUsecase,
    required UpdateStudentUsecase updateStudentUsecase,
    required DeleteStudentUsecase deleteStudentUsecase,
    required GetStudentsBySupervisorUsecase getStudentsBySupervisorUsecase,
    required GetStudentDetailsUsecase getStudentDetailsUsecase,
    required UpdateStudentProfileUsecase updateStudentProfileUsecase,
    required CheckInUsecase checkInUsecase,
    required CheckOutUsecase checkOutUsecase,
    required GetStudentTimeLogsUsecase getStudentTimeLogsUsecase,
    required CreateTimeLogUsecase createTimeLogUsecase,
    required UpdateTimeLogUsecase updateTimeLogUsecase,
    required DeleteTimeLogUsecase deleteTimeLogUsecase,
    required GetContractsForStudentUsecase getContractsForStudentUsecase,
  })  : _getAllStudentsUsecase = getAllStudentsUsecase,
        _getStudentByIdUsecase = getStudentByIdUsecase,
        _getStudentByUserIdUsecase = getStudentByUserIdUsecase,
        _createStudentUsecase = createStudentUsecase,
        _updateStudentUsecase = updateStudentUsecase,
        _deleteStudentUsecase = deleteStudentUsecase,
        _getStudentsBySupervisorUsecase = getStudentsBySupervisorUsecase,
        _getStudentDetailsUsecase = getStudentDetailsUsecase,
        _updateStudentProfileUsecase = updateStudentProfileUsecase,
        _checkInUsecase = checkInUsecase,
        _checkOutUsecase = checkOutUsecase,
        _getStudentTimeLogsUsecase = getStudentTimeLogsUsecase,
        _createTimeLogUsecase = createTimeLogUsecase,
        _updateTimeLogUsecase = updateTimeLogUsecase,
        _deleteTimeLogUsecase = deleteTimeLogUsecase,
        _getContractsForStudentUsecase = getContractsForStudentUsecase,
        super(StudentInitial()) {
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
    emit(StudentLoading());
    try {
      // Implementar lógica para carregar dados do dashboard
      // Por enquanto, apenas emitir estado de loading
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateStudentProfileInfo(
    UpdateStudentProfileInfoEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica para atualizar perfil
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onStudentCheckIn(
    StudentCheckInEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica de check-in
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onStudentCheckOut(
    StudentCheckOutEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica de check-out
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onLoadStudentTimeLogs(
    LoadStudentTimeLogsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica para carregar logs de tempo
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCreateManualTimeLog(
    CreateManualTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica para criar log manual
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateManualTimeLog(
    UpdateManualTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica para atualizar log manual
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onDeleteTimeLog(
    DeleteTimeLogRequestedEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica para deletar log
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onFetchActiveTimeLog(
    FetchActiveTimeLogEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      // Implementar lógica para buscar log ativo
      emit(StudentLoading());
    } catch (e) {
      emit(StudentOperationFailure(message: e.toString()));
    }
  }
}
