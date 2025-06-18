import 'package:dartz/dartz.dart';

import 'package:student_supervisor_app/core/errors/app_exceptions.dart';
import 'package:student_supervisor_app/data/models/student_model.dart';
import 'package:student_supervisor_app/domain/entities/student_entity.dart';

import 'package:student_supervisor_app/domain/entities/time_log_entity.dart';
import 'package:student_supervisor_app/domain/usecases/supervisor/get_all_students_for_supervisor_usecase.dart';

import '../entities/supervisor_entity.dart';
import '../entities/contract_entity.dart';

abstract class ISupervisorRepository {
  Future<List<SupervisorEntity>> getAllSupervisors();
  Future<SupervisorEntity?> getSupervisorById(String id);
  Future<SupervisorEntity?> getSupervisorByUserId(String userId);
  Future<SupervisorEntity> createSupervisor(SupervisorEntity supervisor);
  Future<SupervisorEntity> updateSupervisor(SupervisorEntity supervisor);
  Future<void> deleteSupervisor(String id);

  Future<Either<AppFailure, TimeLogEntity>> approveOrRejectTimeLog(
      {required String timeLogId,
      required bool approved,
      required String supervisorId,
      String? rejectionReason});

  Future<Either<AppFailure, StudentEntity>> createStudent(
      StudentEntity studentData);

  Future<Either<AppFailure, void>> deleteStudent(String studentId);

  Future<Either<AppFailure, List<StudentEntity>>> getAllStudents(
      FilterStudentsParams? params);

  Future<Either<AppFailure, List<TimeLogEntity>>> getAllTimeLogs(
      {String? studentId, bool? pendingApprovalOnly});

  Future<Object> getStudentDetailsForSupervisor(String studentId);

  Future<Either<AppFailure, SupervisorEntity>> getSupervisorDetails(
      String userId);

  Future<Either<AppFailure, StudentEntity>> updateStudentBySupervisor(
      StudentEntity studentData);
}
