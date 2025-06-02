// lib/domain/repositories/i_student_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart'; // Para TimeOfDay
import '../entities/student_entity.dart';
import '../entities/time_log_entity.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/enums.dart'; // Para ClassShift

// Parâmetros para atualizar perfil do estudante
class UpdateStudentProfileParams {
  final String studentId;
  final String? fullName;
  final String? registrationNumber;
  final String? course;
  final String? advisorName;
  final bool? isMandatoryInternship;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final DateTime? birthDate; // Adicionado
  final ClassShift? classShift; // Adicionado
  // Adicione outros campos de StudentEntity que podem ser atualizados

  UpdateStudentProfileParams({
    required this.studentId,
    this.fullName,
    this.registrationNumber,
    this.course,
    this.advisorName,
    this.isMandatoryInternship,
    this.profilePictureUrl,
    this.phoneNumber,
    this.birthDate, // Adicionado
    this.classShift, // Adicionado
  });
}


abstract class IStudentRepository {
  /// Obtém os detalhes do perfil de um estudante pelo seu ID de utilizador.
  Future<Either<AppFailure, StudentEntity>> getStudentDetails(String userId);

  /// Atualiza os detalhes do perfil de um estudante.
  Future<Either<AppFailure, StudentEntity>> updateStudentProfile(UpdateStudentProfileParams params);

  /// Obtém os registos de tempo de um estudante.
  Future<Either<AppFailure, List<TimeLogEntity>>> getStudentTimeLogs({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Cria um novo registo de tempo para um estudante (check-in/check-out manual).
  Future<Either<AppFailure, TimeLogEntity>> createTimeLog({
    required String studentId,
    required DateTime logDate,
    required TimeOfDay checkInTime,
    TimeOfDay? checkOutTime, // Opcional no momento da criação se for só check-in
    String? description,
  });

  /// Atualiza um registo de tempo existente (ex: adicionar check-out, editar descrição).
  Future<Either<AppFailure, TimeLogEntity>> updateTimeLog(TimeLogEntity timeLog);

  /// Remove um registo de tempo.
  Future<Either<AppFailure, void>> deleteTimeLog(String timeLogId);

  /// Realiza o check-in para um estudante.
  Future<Either<AppFailure, TimeLogEntity>> checkIn({
    required String studentId,
    String? notes, // Notas opcionais para o check-in
  });

  /// Realiza o check-out para um estudante, finalizando o registo de tempo.
  Future<Either<AppFailure, TimeLogEntity>> checkOut({
    required String studentId,
    required String activeTimeLogId, // ID do time_log que foi iniciado no check-in
    String? description, // Descrição para o período
  });
}
import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../entities/student_entity.dart';

abstract class IStudentRepository {
  Future<Either<AppFailure, StudentEntity>> getStudentDetails(String userId);
  Future<Either<AppFailure, StudentEntity>> updateStudentProfile(StudentEntity student);
  Future<Either<AppFailure, List<StudentEntity>>> getAllStudents();
  Future<Either<AppFailure, StudentEntity>> createStudent(StudentEntity student);
  Future<Either<AppFailure, void>> deleteStudent(String studentId);
}

class FilterStudentsParams {
  final String? course;
  final String? institution;
  final StudentStatus? status;
  final String? supervisorId;

  const FilterStudentsParams({
    this.course,
    this.institution,
    this.status,
    this.supervisorId,
  });
}
