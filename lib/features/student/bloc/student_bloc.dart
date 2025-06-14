import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/student_entity.dart';
import '../../../domain/usecases/student/get_all_students_usecase.dart';
import '../../../domain/usecases/student/get_student_by_id_usecase.dart';
import '../../../domain/usecases/student/get_student_by_user_id_usecase.dart';
import '../../../domain/usecases/student/create_student_usecase.dart';
import '../../../domain/usecases/student/update_student_usecase.dart';
import '../../../domain/usecases/student/delete_student_usecase.dart';
import '../../../domain/usecases/student/get_students_by_supervisor_usecase.dart';

// Events
abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class StudentLoadAllRequested extends StudentEvent {}

class StudentLoadByIdRequested extends StudentEvent {
  final String id;

  const StudentLoadByIdRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class StudentLoadCurrentRequested extends StudentEvent {}

class StudentLoadByUserIdRequested extends StudentEvent {
  final String userId;

  const StudentLoadByUserIdRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class StudentCreateRequested extends StudentEvent {
  final StudentEntity student;

  const StudentCreateRequested({required this.student});

  @override
  List<Object> get props => [student];
}

class StudentUpdateRequested extends StudentEvent {
  final StudentEntity student;

  const StudentUpdateRequested({required this.student});

  @override
  List<Object> get props => [student];
}

class StudentDeleteRequested extends StudentEvent {
  final String id;

  const StudentDeleteRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class StudentLoadBySupervisorRequested extends StudentEvent {
  final String supervisorId;

  const StudentLoadBySupervisorRequested({required this.supervisorId});

  @override
  List<Object> get props => [supervisorId];
}

// States
abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

// Loading States
class StudentLoading extends StudentState {}

class StudentSelecting extends StudentState {}

class StudentInserting extends StudentState {}

class StudentUpdating extends StudentState {}

class StudentDeleting extends StudentState {}

// Success States
class StudentLoadAllSuccess extends StudentState {
  final List<StudentEntity> students;

  const StudentLoadAllSuccess({required this.students});

  @override
  List<Object> get props => [students];
}

class StudentLoadByIdSuccess extends StudentState {
  final StudentEntity? student;

  const StudentLoadByIdSuccess({required this.student});

  @override
  List<Object?> get props => [student];
}

class StudentLoadCurrentSuccess extends StudentState {
  final StudentEntity student;

  const StudentLoadCurrentSuccess({required this.student});

  @override
  List<Object> get props => [student];
}

class StudentCreateSuccess extends StudentState {
  final StudentEntity student;

  const StudentCreateSuccess({required this.student});

  @override
  List<Object> get props => [student];
}

class StudentUpdateSuccess extends StudentState {
  final StudentEntity student;

  const StudentUpdateSuccess({required this.student});

  @override
  List<Object> get props => [student];
}

class StudentDeleteSuccess extends StudentState {
  final String deletedId;

  const StudentDeleteSuccess({required this.deletedId});

  @override
  List<Object> get props => [deletedId];
}

class StudentLoadBySupervisorSuccess extends StudentState {
  final List<StudentEntity> students;

  const StudentLoadBySupervisorSuccess({required this.students});

  @override
  List<Object> get props => [students];
}

// Error States
class StudentSelectError extends StudentState {
  final String message;

  const StudentSelectError({required this.message});

  @override
  List<Object> get props => [message];
}

class StudentInsertError extends StudentState {
  final String message;

  const StudentInsertError({required this.message});

  @override
  List<Object> get props => [message];
}

class StudentUpdateError extends StudentState {
  final String message;

  const StudentUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class StudentDeleteError extends StudentState {
  final String message;

  const StudentDeleteError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final GetAllStudentsUsecase _getAllStudentsUsecase;
  final GetStudentByIdUsecase _getStudentByIdUsecase;
  final GetStudentByUserIdUsecase _getStudentByUserIdUsecase;
  final CreateStudentUsecase _createStudentUsecase;
  final UpdateStudentUsecase _updateStudentUsecase;
  final DeleteStudentUsecase _deleteStudentUsecase;
  final GetStudentsBySupervisorUsecase _getStudentsBySupervisorUsecase;

  StudentBloc({
    required GetAllStudentsUsecase getAllStudentsUsecase,
    required GetStudentByIdUsecase getStudentByIdUsecase,
    required GetStudentByUserIdUsecase getStudentByUserIdUsecase,
    required CreateStudentUsecase createStudentUsecase,
    required UpdateStudentUsecase updateStudentUsecase,
    required DeleteStudentUsecase deleteStudentUsecase,
    required GetStudentsBySupervisorUsecase getStudentsBySupervisorUsecase,
  })  : _getAllStudentsUsecase = getAllStudentsUsecase,
        _getStudentByIdUsecase = getStudentByIdUsecase,
        _getStudentByUserIdUsecase = getStudentByUserIdUsecase,
        _createStudentUsecase = createStudentUsecase,
        _updateStudentUsecase = updateStudentUsecase,
        _deleteStudentUsecase = deleteStudentUsecase,
        _getStudentsBySupervisorUsecase = getStudentsBySupervisorUsecase,
        super(StudentInitial()) {
    on<StudentLoadAllRequested>(_onStudentLoadAllRequested);
    on<StudentLoadByIdRequested>(_onStudentLoadByIdRequested);
    on<StudentLoadCurrentRequested>(_onStudentLoadCurrentRequested);
    on<StudentLoadByUserIdRequested>(_onStudentLoadByUserIdRequested);
    on<StudentCreateRequested>(_onStudentCreateRequested);
    on<StudentUpdateRequested>(_onStudentUpdateRequested);
    on<StudentDeleteRequested>(_onStudentDeleteRequested);
    on<StudentLoadBySupervisorRequested>(_onStudentLoadBySupervisorRequested);
  }

  Future<void> _onStudentLoadAllRequested(
    StudentLoadAllRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentSelecting());
    try {
      final students = await _getAllStudentsUsecase();
      emit(StudentLoadAllSuccess(students: students));
    } catch (e) {
      emit(StudentSelectError(message: e.toString()));
    }
  }

  Future<void> _onStudentLoadByIdRequested(
    StudentLoadByIdRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentSelecting());
    try {
      final student = await _getStudentByIdUsecase(event.id);
      emit(StudentLoadByIdSuccess(student: student));
    } catch (e) {
      emit(StudentSelectError(message: e.toString()));
    }
  }

  Future<void> _onStudentLoadCurrentRequested(
    StudentLoadCurrentRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentSelecting());
    try {
      // TODO: Get current user ID from auth
      const currentUserId = 'current-user-id'; // Placeholder
      final student = await _getStudentByUserIdUsecase(currentUserId);
      if (student != null) {
        emit(StudentLoadCurrentSuccess(student: student));
      } else {
        emit(StudentSelectError(message: 'Estudante não encontrado'));
      }
    } catch (e) {
      emit(StudentSelectError(message: e.toString()));
    }
  }

  Future<void> _onStudentLoadByUserIdRequested(
    StudentLoadByUserIdRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentSelecting());
    try {
      final student = await _getStudentByUserIdUsecase(event.userId);
      emit(StudentLoadByIdSuccess(student: student));
    } catch (e) {
      emit(StudentSelectError(message: e.toString()));
    }
  }

  Future<void> _onStudentCreateRequested(
    StudentCreateRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentInserting());
    try {
      final student = await _createStudentUsecase(event.student);
      emit(StudentCreateSuccess(student: student));
    } catch (e) {
      emit(StudentInsertError(message: e.toString()));
    }
  }

  Future<void> _onStudentUpdateRequested(
    StudentUpdateRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentUpdating());
    try {
      final student = await _updateStudentUsecase(event.student);
      emit(StudentUpdateSuccess(student: student));
    } catch (e) {
      emit(StudentUpdateError(message: e.toString()));
    }
  }

  Future<void> _onStudentDeleteRequested(
    StudentDeleteRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentDeleting());
    try {
      await _deleteStudentUsecase(event.id);
      emit(StudentDeleteSuccess(deletedId: event.id));
    } catch (e) {
      emit(StudentDeleteError(message: e.toString()));
    }
  }

  Future<void> _onStudentLoadBySupervisorRequested(
    StudentLoadBySupervisorRequested event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentSelecting());
    try {
      final students = await _getStudentsBySupervisorUsecase(event.supervisorId);
      emit(StudentLoadBySupervisorSuccess(students: students));
    } catch (e) {
      emit(StudentSelectError(message: e.toString()));
    }
  }
}

