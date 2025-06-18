import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/create_supervisor_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/delete_supervisor_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/get_all_supervisors_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/get_supervisor_by_id_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/get_supervisor_by_user_id_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/update_supervisor_usecase.dart';
import '../../../domain/entities/supervisor_entity.dart';
import '../../../domain/repositories/i_supervisor_repository.dart';

// Events
abstract class SupervisorEvent extends Equatable {
  const SupervisorEvent();

  @override
  List<Object?> get props => [];
}

class SupervisorLoadAllRequested extends SupervisorEvent {}

class SupervisorLoadByIdRequested extends SupervisorEvent {
  final String id;

  const SupervisorLoadByIdRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class SupervisorLoadByUserIdRequested extends SupervisorEvent {
  final String userId;

  const SupervisorLoadByUserIdRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SupervisorCreateRequested extends SupervisorEvent {
  final SupervisorEntity supervisor;

  const SupervisorCreateRequested({required this.supervisor});

  @override
  List<Object> get props => [supervisor];
}

class SupervisorUpdateRequested extends SupervisorEvent {
  final SupervisorEntity supervisor;

  const SupervisorUpdateRequested({required this.supervisor});

  @override
  List<Object> get props => [supervisor];
}

class SupervisorDeleteRequested extends SupervisorEvent {
  final String id;

  const SupervisorDeleteRequested({required this.id});

  @override
  List<Object> get props => [id];
}

// States
abstract class SupervisorState extends Equatable {
  const SupervisorState();

  @override
  List<Object?> get props => [];
}

class SupervisorInitial extends SupervisorState {}

// Loading States
class SupervisorLoading extends SupervisorState {}

class SupervisorSelecting extends SupervisorState {}

class SupervisorInserting extends SupervisorState {}

class SupervisorUpdating extends SupervisorState {}

class SupervisorDeleting extends SupervisorState {}

// Success States
class SupervisorLoadAllSuccess extends SupervisorState {
  final List<SupervisorEntity> supervisors;

  const SupervisorLoadAllSuccess({required this.supervisors});

  @override
  List<Object> get props => [supervisors];
}

class SupervisorLoadByIdSuccess extends SupervisorState {
  final SupervisorEntity? supervisor;

  const SupervisorLoadByIdSuccess({required this.supervisor});

  @override
  List<Object?> get props => [supervisor];
}

class SupervisorLoadByUserIdSuccess extends SupervisorState {
  final SupervisorEntity? supervisor;

  const SupervisorLoadByUserIdSuccess({required this.supervisor});

  @override
  List<Object?> get props => [supervisor];
}

class SupervisorCreateSuccess extends SupervisorState {
  final SupervisorEntity supervisor;

  const SupervisorCreateSuccess({required this.supervisor});

  @override
  List<Object> get props => [supervisor];
}

class SupervisorUpdateSuccess extends SupervisorState {
  final SupervisorEntity supervisor;

  const SupervisorUpdateSuccess({required this.supervisor});

  @override
  List<Object> get props => [supervisor];
}

class SupervisorDeleteSuccess extends SupervisorState {
  final String deletedId;

  const SupervisorDeleteSuccess({required this.deletedId});

  @override
  List<Object> get props => [deletedId];
}

// Error States
class SupervisorSelectError extends SupervisorState {
  final String message;

  const SupervisorSelectError({required this.message});

  @override
  List<Object> get props => [message];
}

class SupervisorInsertError extends SupervisorState {
  final String message;

  const SupervisorInsertError({required this.message});

  @override
  List<Object> get props => [message];
}

class SupervisorUpdateError extends SupervisorState {
  final String message;

  const SupervisorUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class SupervisorDeleteError extends SupervisorState {
  final String message;

  const SupervisorDeleteError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class SupervisorBloc extends Bloc<SupervisorEvent, SupervisorState> {
  final ISupervisorRepository _supervisorRepository;
  final GetAllSupervisorsUsecase getAllSupervisorsUsecase;
  final GetSupervisorByIdUsecase getSupervisorByIdUsecase;
  final GetSupervisorByUserIdUsecase getSupervisorByUserIdUsecase;
  final CreateSupervisorUsecase createSupervisorUsecase;
  final UpdateSupervisorUsecase updateSupervisorUsecase;
  final DeleteSupervisorUsecase deleteSupervisorUsecase;

  SupervisorBloc({
    required ISupervisorRepository supervisorRepository,
    required this.getAllSupervisorsUsecase,
    required this.getSupervisorByIdUsecase,
    required this.getSupervisorByUserIdUsecase,
    required this.createSupervisorUsecase,
    required this.updateSupervisorUsecase,
    required this.deleteSupervisorUsecase,
  })  : _supervisorRepository = supervisorRepository,
        super(SupervisorInitial()) {
    on<SupervisorLoadAllRequested>(_onSupervisorLoadAllRequested);
    on<SupervisorLoadByIdRequested>(_onSupervisorLoadByIdRequested);
    on<SupervisorLoadByUserIdRequested>(_onSupervisorLoadByUserIdRequested);
    on<SupervisorCreateRequested>(_onSupervisorCreateRequested);
    on<SupervisorUpdateRequested>(_onSupervisorUpdateRequested);
    on<SupervisorDeleteRequested>(_onSupervisorDeleteRequested);
  }

  Future<void> _onSupervisorLoadAllRequested(
    SupervisorLoadAllRequested event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(SupervisorSelecting());
    try {
      // TODO: Implement supervisor loading logic
      final supervisors = await _supervisorRepository.getAllSupervisors();
      emit(SupervisorLoadAllSuccess(supervisors: supervisors));
      emit(SupervisorLoadAllSuccess(supervisors: []));
    } catch (e) {
      emit(SupervisorSelectError(message: e.toString()));
    }
  }

  Future<void> _onSupervisorLoadByIdRequested(
    SupervisorLoadByIdRequested event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(SupervisorSelecting());
    try {
      // TODO: Implement supervisor loading by id logic
      final supervisor =
          await _supervisorRepository.getSupervisorById(event.id);
      emit(SupervisorLoadByIdSuccess(supervisor: supervisor));
      emit(SupervisorLoadByIdSuccess(supervisor: null));
    } catch (e) {
      emit(SupervisorSelectError(message: e.toString()));
    }
  }

  Future<void> _onSupervisorLoadByUserIdRequested(
    SupervisorLoadByUserIdRequested event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(SupervisorSelecting());
    try {
      // TODO: Implement supervisor loading by user id logic
      final supervisor =
          await _supervisorRepository.getSupervisorByUserId(event.userId);
      emit(SupervisorLoadByUserIdSuccess(supervisor: supervisor));
      emit(SupervisorLoadByUserIdSuccess(supervisor: null));
    } catch (e) {
      emit(SupervisorSelectError(message: e.toString()));
    }
  }

  Future<void> _onSupervisorCreateRequested(
    SupervisorCreateRequested event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(SupervisorInserting());
    try {
      // TODO: Implement supervisor creation logic
      final supervisor =
          await _supervisorRepository.createSupervisor(event.supervisor);
      emit(SupervisorCreateSuccess(supervisor: supervisor));
      emit(SupervisorCreateSuccess(supervisor: event.supervisor));
    } catch (e) {
      emit(SupervisorInsertError(message: e.toString()));
    }
  }

  Future<void> _onSupervisorUpdateRequested(
    SupervisorUpdateRequested event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(SupervisorUpdating());
    try {
      // TODO: Implement supervisor update logic
      final supervisor =
          await _supervisorRepository.updateSupervisor(event.supervisor);
      emit(SupervisorUpdateSuccess(supervisor: supervisor));
      emit(SupervisorUpdateSuccess(supervisor: event.supervisor));
    } catch (e) {
      emit(SupervisorUpdateError(message: e.toString()));
    }
  }

  Future<void> _onSupervisorDeleteRequested(
    SupervisorDeleteRequested event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(SupervisorDeleting());
    try {
      // TODO: Implement supervisor deletion logic
      await _supervisorRepository.deleteSupervisor(event.id);
      emit(SupervisorDeleteSuccess(deletedId: event.id));
    } catch (e) {
      emit(SupervisorDeleteError(message: e.toString()));
    }
  }
}
