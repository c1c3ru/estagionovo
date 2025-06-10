// lib/domain/repositories/i_student_repository.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/core/enum/class_shift.dart';
import 'package:flutter/material.dart';
import '../entities/student_entity.dart';
import '../entities/time_log_entity.dart';
import '../../core/errors/app_exceptions.dart';

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
  final DateTime? birthDate;
  final ClassShift? classShift;

  UpdateStudentProfileParams({
    required this.studentId,
    this.fullName,
    this.registrationNumber,
    this.course,
    this.advisorName,
    this.isMandatoryInternship,
    this.profilePictureUrl,
    this.phoneNumber,
    this.birthDate,
    this.classShift,
  });
}

abstract class IStudentRepository {
  /// Obtém os detalhes do perfil de um estudante pelo seu ID de utilizador.
  Future<Either<AppFailure, StudentEntity>> getStudentDetails(String userId);

  /// Atualiza os detalhes do perfil de um estudante.
  Future<Either<AppFailure, StudentEntity>> updateStudentProfile(
      UpdateStudentProfileParams params);

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
    TimeOfDay? checkOutTime,
    String? description,
  });

  /// Atualiza um registo de tempo existente (ex: adicionar check-out, editar descrição).
  Future<Either<AppFailure, TimeLogEntity>> updateTimeLog(
      TimeLogEntity timeLog);

  /// Remove um registo de tempo.
  Future<Either<AppFailure, Unit>> deleteTimeLog(
      String timeLogId); // Corrigido para Unit

  /// Realiza o check-in para um estudante.
  Future<Either<AppFailure, TimeLogEntity>> checkIn({
    required String studentId,
    String? notes,
  });

  /// Realiza o check-out para um estudante, finalizando o registo de tempo.
  Future<Either<AppFailure, TimeLogEntity>> checkOut({
    required String studentId,
    required String activeTimeLogId,
    String? description,
  });
}
