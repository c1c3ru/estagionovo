// lib/features/supervisor/presentation/bloc/supervisor_event.dart
import 'package:equatable/equatable.dart';
import '../../../core/enums/contract_status.dart';
import '../../../domain/repositories/i_supervisor_repository.dart';
import '../../../domain/entities/contract_entity.dart';
import '../../../domain/entities/student_entity.dart';
import '../../../data/models/student_model.dart' show FilterStudentsParams;
import '../../../domain/usecases/contract/upsert_contract_usecase.dart';
// Importe UserRole e StudentStatus dos seus enums centrais

abstract class SupervisorEvent extends Equatable {
  const SupervisorEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar os dados iniciais do dashboard do supervisor.
class LoadSupervisorDashboardDataEvent extends SupervisorEvent {}

/// Evento para filtrar a lista de estudantes no dashboard.
class FilterStudentsEvent extends SupervisorEvent {
  final FilterStudentsParams params;

  const FilterStudentsEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Evento para carregar os detalhes de um estudante específico.
class LoadStudentDetailsForSupervisorEvent extends SupervisorEvent {
  final String studentId;

  const LoadStudentDetailsForSupervisorEvent({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}

/// Evento para o supervisor criar um novo estudante.
/// O StudentEntity aqui conteria os dados do formulário de criação.
class CreateStudentBySupervisorEvent extends SupervisorEvent {
  final StudentEntity studentData;

  const CreateStudentBySupervisorEvent({required this.studentData});

  @override
  List<Object?> get props => [studentData];
}

/// Evento para o supervisor atualizar os dados de um estudante.
class UpdateStudentBySupervisorEvent extends SupervisorEvent {
  final StudentEntity studentData;

  const UpdateStudentBySupervisorEvent({required this.studentData});

  @override
  List<Object?> get props => [studentData];
}

/// Evento para o supervisor remover um estudante.
class DeleteStudentBySupervisorEvent extends SupervisorEvent {
  final String studentId;

  const DeleteStudentBySupervisorEvent({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}

/// Evento para carregar todos os registos de tempo (para aprovação ou visualização).
class LoadAllTimeLogsForApprovalEvent extends SupervisorEvent {
  final String? studentIdFilter;
  final bool pendingOnly;

  const LoadAllTimeLogsForApprovalEvent({
    this.studentIdFilter,
    this.pendingOnly = true,
  });

  @override
  List<Object?> get props => [studentIdFilter, pendingOnly];
}

/// Evento para o supervisor aprovar ou rejeitar um registo de tempo.
class ApproveOrRejectTimeLogEvent extends SupervisorEvent {
  final String timeLogId;
  final bool approved;
  final String supervisorId;
  final String? rejectionReason;

  const ApproveOrRejectTimeLogEvent({
    required this.timeLogId,
    required this.approved,
    required this.supervisorId,
    this.rejectionReason,
  });

  @override
  List<Object?> get props =>
      [timeLogId, approved, supervisorId, rejectionReason];
}

/// Evento para carregar todos os contratos (para visualização ou gestão).
class LoadAllContractsEvent extends SupervisorEvent {
  final String? studentIdFilter;
  final ContractStatus? statusFilter;

  const LoadAllContractsEvent({
    this.studentIdFilter,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [studentIdFilter, statusFilter];
}

/// Evento para o supervisor criar um novo contrato.
class CreateContractBySupervisorEvent extends SupervisorEvent {
  final UpsertContractParams params;

  const CreateContractBySupervisorEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Evento para o supervisor atualizar um contrato existente.
class UpdateContractBySupervisorEvent extends SupervisorEvent {
  final UpsertContractParams params;

  const UpdateContractBySupervisorEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

/// Evento para alternar a visualização no dashboard (ex: Lista vs Gantt).
class ToggleDashboardViewEvent extends SupervisorEvent {}
