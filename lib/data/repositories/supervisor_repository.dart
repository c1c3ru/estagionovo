import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/i_supervisor_repository.dart';
import '../models/student_model.dart';
import '../models/supervisor_model.dart';
import '../models/contract_model.dart';
import '../models/time_log_model.dart';
import '../datasources/supabase/supervisor_datasource.dart';
import '../datasources/supabase/student_datasource.dart';
import '../datasources/supabase/contract_datasource.dart';
import '../datasources/supabase/time_log_datasource.dart';
import '../../domain/entities/time_log_entity.dart';
import '../../domain/entities/supervisor_entity.dart';

class SupervisorRepository implements ISupervisorRepository {
  final SupervisorDatasource _supervisorDatasource;

  SupervisorRepository(this._supervisorDatasource);

  @override
  Future<List<SupervisorEntity>> getAllSupervisors() async {
    try {
      final supervisorsData = await _supervisorDatasource.getAllSupervisors();
      return supervisorsData
          .map((data) => SupervisorModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar supervisores: $e');
    }
  }

  @override
  Future<SupervisorEntity?> getSupervisorById(String id) async {
    try {
      final supervisorData = await _supervisorDatasource.getSupervisorById(id);
      if (supervisorData == null) return null;
      return SupervisorModel.fromJson(supervisorData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar supervisor: $e');
    }
  }

  @override
  Future<SupervisorEntity?> getSupervisorByUserId(String userId) async {
    try {
      final supervisorData =
          await _supervisorDatasource.getSupervisorByUserId(userId);
      if (supervisorData == null) return null;
      return SupervisorModel.fromJson(supervisorData).toEntity();
    } catch (e) {
      throw Exception(
          'Erro no repositório ao buscar supervisor por usuário: $e');
    }
  }

  @override
  Future<SupervisorEntity> createSupervisor(SupervisorEntity supervisor) async {
    try {
      final supervisorModel = SupervisorModel.fromEntity(supervisor);
      final createdData = await _supervisorDatasource
          .createSupervisor(supervisorModel.toJson());
      return SupervisorModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao criar supervisor: $e');
    }
  }

  @override
  Future<SupervisorEntity> updateSupervisor(SupervisorEntity supervisor) async {
    try {
      final supervisorModel = SupervisorModel.fromEntity(supervisor);
      final updatedData = await _supervisorDatasource.updateSupervisor(
        supervisor.id,
        supervisorModel.toJson(),
      );
      return SupervisorModel.fromJson(updatedData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao atualizar supervisor: $e');
    }
  }

  @override
  Future<void> deleteSupervisor(String id) async {
    try {
      await _supervisorDatasource.deleteSupervisor(id);
    } catch (e) {
      throw Exception('Erro no repositório ao excluir supervisor: $e');
    }
  }

  @override
  Future<Either<AppFailure, TimeLogEntity>> approveOrRejectTimeLog(
      {required String timeLogId,
      required bool approved,
      required String supervisorId,
      String? rejectionReason}) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método approveOrRejectTimeLog não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> createStudent(
      StudentEntity studentData) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método createStudent não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteStudent(String studentId) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método deleteStudent não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<StudentEntity>>> getAllStudents(
      FilterStudentsParams? params) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método getAllStudents não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<TimeLogEntity>>> getAllTimeLogs(
      {String? studentId, bool? pendingApprovalOnly}) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método getAllTimeLogs não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> getStudentDetailsForSupervisor(
      String studentId) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método getStudentDetailsForSupervisor não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, SupervisorEntity>> getSupervisorDetails(
      String userId) async {
    try {
      final supervisor = await getSupervisorByUserId(userId);
      if (supervisor == null) {
        return Left(const ServerFailure(message: 'Supervisor não encontrado'));
      }
      return Right(supervisor);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> updateStudentBySupervisor(
      StudentEntity studentData) async {
    try {
      // Implementação temporária
      return Left(const ServerFailure(
          message: 'Método updateStudentBySupervisor não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
