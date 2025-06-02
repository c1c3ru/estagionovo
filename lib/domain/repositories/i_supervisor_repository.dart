// lib/domain/repositories/i_supervisor_repository.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/contract.dart';
import 'package:estagio/domain/entities/student.dart';
import 'package:estagio/domain/entities/supervisor.dart';
import 'package:estagio/domain/entities/time_log.dart';
import '../../core/errors/app_exceptions.dart';

// Parâmetros para filtrar estudantes
class FilterStudentsParams {
  final String? name;
  final String? course;
  final StudentStatus? status; // Usando o enum StudentStatus
  // Adicione outros critérios de filtro conforme necessário

  FilterStudentsParams({this.name, this.course, this.status});
}

abstract class ISupervisorRepository {
  /// Obtém os detalhes do perfil de um supervisor pelo seu ID de utilizador.
  Future<Either<AppFailure, SupervisorEntity>> getSupervisorDetails(
    String userId,
  );

  /// Obtém todos os estudantes (geralmente para um supervisor).
  /// Pode incluir paginação ou filtros básicos se necessário.
  Future<Either<AppFailure, List<StudentEntity>>> getAllStudents(
    FilterStudentsParams? params,
  );

  /// Obtém os detalhes de um estudante específico (visão do supervisor).
  Future<Either<AppFailure, StudentEntity>> getStudentDetailsForSupervisor(
    String studentId,
  );

  /// Cria um novo registo de estudante (feito pelo supervisor).
  Future<Either<AppFailure, StudentEntity>> createStudent(
    StudentEntity studentData,
  );

  /// Atualiza os dados de um estudante (feito pelo supervisor).
  Future<Either<AppFailure, StudentEntity>> updateStudentBySupervisor(
    StudentEntity studentData,
  );

  /// Remove um estudante (feito pelo supervisor).
  Future<Either<AppFailure, void>> deleteStudent(String studentId);

  /// Obtém todos os registos de tempo para aprovação ou visualização.
  Future<Either<AppFailure, List<TimeLogEntity>>> getAllTimeLogs({
    String? studentId, // Opcional para filtrar por estudante
    bool? pendingApprovalOnly, // Opcional para filtrar apenas pendentes
  });

  /// Aprova ou rejeita um registo de tempo.
  Future<Either<AppFailure, TimeLogEntity>> approveOrRejectTimeLog({
    required String timeLogId,
    required bool approved,
    required String supervisorId, // ID do supervisor que realizou a ação
    String? rejectionReason, // Opcional se rejeitado
  });

  /// Obtém todos os contratos.
  Future<Either<AppFailure, List<ContractEntity>>> getAllContracts(
    String? studentId,
  );

  /// Cria um novo contrato.
  Future<Either<AppFailure, ContractEntity>> createContract(
    ContractEntity contractData,
  );

  /// Atualiza um contrato existente.
  Future<Either<AppFailure, ContractEntity>> updateContract(
    ContractEntity contractData,
  );
}
