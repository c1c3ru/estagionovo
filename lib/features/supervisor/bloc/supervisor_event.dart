// lib/features/supervisor/presentation/bloc/supervisor_event.dart
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/student_entity.dart'; // Para passar dados de estudante
import '../../../../domain/entities/contract_entity.dart'; // Para passar dados de contrato
import '../../../../domain/repositories/i_supervisor_repository.dart'; // Para FilterStudentsParams
// Importe UserRole e StudentStatus dos seus enums centrais

abstract class SupervisorEvent extends Equatable {
  const SupervisorEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar os dados iniciais do dashboard do supervisor.
class LoadSupervisorDashboardDataEvent extends SupervisorEvent {
  // Pode incluir ID do supervisor se os dados forem específicos para ele,
  // mas geralmente o dashboard do supervisor mostra dados agregados.
  const LoadSupervisorDashboardDataEvent();
}

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
  // Adicionalmente, pode precisar de dados para a tabela 'users' (email, senha inicial, role)
  // que seriam passados para um usecase de criação de utilizador antes de criar o perfil de estudante.
  // Por simplicidade, assumimos que a criação do User (auth e tabela users) é pré-requisito
  // e StudentEntity já tem o ID do user.
  final String initialEmail; // Email para criar o user no auth
  final String initialPassword; // Senha inicial para o user no auth

  const CreateStudentBySupervisorEvent({
    required this.studentData,
    required this.initialEmail,
    required this.initialPassword,
  });

  @override
  List<Object?> get props => [studentData, initialEmail, initialPassword];
}

/// Evento para o supervisor atualizar os dados de um estudante.
class UpdateStudentBySupervisorEvent extends SupervisorEvent {
  final StudentEntity
      studentData; // Contém o ID do estudante e os campos atualizados

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
  final String? studentIdFilter; // Opcional
  final bool pendingOnly;

  const LoadAllTimeLogsForApprovalEvent(
      {this.studentIdFilter, this.pendingOnly = true});

  @override
  List<Object?> get props => [studentIdFilter, pendingOnly];
}

/// Evento para o supervisor aprovar ou rejeitar um registo de tempo.
class ApproveOrRejectTimeLogEvent extends SupervisorEvent {
  final String timeLogId;
  final bool approved;
  final String supervisorId; // ID do supervisor que está a realizar a ação
  final String? rejectionReason;

  const ApproveOrRejectTimeLogEvent({
    required this.timeLogId,
    required this.approved,
    required this.supervisorId,
    this.rejectionReason,
    required bool isApproved,
  });

  @override
  List<Object?> get props =>
      [timeLogId, approved, supervisorId, rejectionReason];
}

/// Evento para carregar todos os contratos (para visualização ou gestão).
class LoadAllContractsEvent extends SupervisorEvent {
  final String? studentIdFilter;
  final ContractStatus? statusFilter;

  const LoadAllContractsEvent({this.studentIdFilter, this.statusFilter});

  @override
  List<Object?> get props => [studentIdFilter, statusFilter];
}

/// Evento para o supervisor criar um novo contrato.
class CreateContractBySupervisorEvent extends SupervisorEvent {
  final ContractEntity contractData;
  final String createdBySupervisorId; // ID do supervisor que está a criar

  const CreateContractBySupervisorEvent(
      {required this.contractData, required this.createdBySupervisorId});

  @override
  List<Object?> get props => [contractData, createdBySupervisorId];
}

/// Evento para o supervisor atualizar um contrato existente.
class UpdateContractBySupervisorEvent extends SupervisorEvent {
  final ContractEntity contractData;
  final String updatedBySupervisorId; // ID do supervisor que está a atualizar

  const UpdateContractBySupervisorEvent(
      {required this.contractData, required this.updatedBySupervisorId});

  @override
  List<Object?> get props => [contractData, updatedBySupervisorId];
}

/// Evento para alternar a visualização no dashboard (ex: Lista vs Gantt).
class ToggleDashboardViewEvent extends SupervisorEvent {
  final bool showGanttView; // true para Gantt, false para Lista

  const ToggleDashboardViewEvent({required this.showGanttView});

  @override
  List<Object?> get props => [showGanttView];
}
