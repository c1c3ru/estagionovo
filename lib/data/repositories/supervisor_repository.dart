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
import '../../domain/usecases/supervisor/get_all_students_for_supervisor_usecase.dart';

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
      final timeLog = await _supervisorDatasource.approveOrRejectTimeLog(
        timeLogId: timeLogId,
        approved: approved,
        supervisorId: supervisorId,
        rejectionReason: rejectionReason,
      );
      return Right(TimeLogEntity.fromJson(timeLog));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> createStudent(
      StudentEntity studentData) async {
    try {
      final studentModel = StudentModel.fromEntity(studentData);
      final createdStudent =
          await _supervisorDatasource.createStudent(studentModel.toJson());
      return Right(StudentModel.fromJson(createdStudent).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteStudent(String studentId) async {
    try {
      await _supervisorDatasource.deleteStudent(studentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<StudentEntity>>> getAllStudents({
    String? supervisorId,
    FilterStudentsParams? filters,
  }) async {
    try {
      final students = await _supervisorDatasource.getAllStudents(
        supervisorId: supervisorId,
        filters: filters,
      );
      return Right(
          students.map((s) => StudentModel.fromJson(s).toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<TimeLogEntity>>> getAllTimeLogs({
    String? studentId,
    bool pendingOnly = false,
  }) async {
    try {
      final timeLogs = await _supervisorDatasource.getAllTimeLogs(
        studentId: studentId,
        pendingOnly: pendingOnly,
      );
      return Right(timeLogs.map((t) => TimeLogEntity.fromJson(t)).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> getStudentDetails(
      String studentId) async {
    try {
      final student = await _supervisorDatasource.getStudentById(studentId);
      if (student == null) {
        return const Left(ServerFailure(message: 'Estudante não encontrado'));
      }
      return Right(StudentModel.fromJson(student).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, SupervisorEntity>> getSupervisorDetails(
      String supervisorId) async {
    try {
      final supervisor =
          await _supervisorDatasource.getSupervisorById(supervisorId);
      if (supervisor == null) {
        return const Left(ServerFailure(message: 'Supervisor não encontrado'));
      }
      return Right(SupervisorModel.fromJson(supervisor).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> updateStudent(
      StudentEntity student) async {
    try {
      final studentModel = StudentModel.fromEntity(student);
      final updatedStudent = await _supervisorDatasource.updateStudent(
        student.id,
        studentModel.toJson(),
      );
      return Right(StudentModel.fromJson(updatedStudent).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
