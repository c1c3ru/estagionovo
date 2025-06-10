// lib/data/repositories/student_repository.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/core/constants/app_failure.dart';
import 'package:estagio/core/enum/class_shift.dart';
import 'package:estagio/core/enum/internship_shift.dart';
import 'package:estagio/core/enum/user_role.dart';
import 'package:estagio/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

// Imports Corrigidos
import '../../../core/errors/app_exceptions.dart' hide AppFailure;
import '../../domain/entities/student_entity.dart';
import '../../domain/entities/time_log_entity.dart';
import '../../domain/repositories/i_student_repository.dart';
import '../datasources/supabase/student_datasource.dart';
import '../datasources/supabase/time_log_datasource.dart';

class StudentRepository implements IStudentRepository {
  final IStudentSupabaseDatasource _studentDatasource;
  final ITimeLogSupabaseDatasource _timeLogDatasource;
  // Adicione aqui um logger se desejar logar eventos do repositório
  // final AppLogger logger;

  StudentRepository(this._studentDatasource, this._timeLogDatasource);

  // Função auxiliar para mapear Map<String, dynamic> para StudentEntity (CORRIGIDA)
  StudentEntity _mapDataToStudentEntity(Map<String, dynamic> data) {
    return StudentEntity(
      id: data['id'] as String,
      fullName: data['full_name'] as String,
      registrationNumber: data['registration_number'] as String,
      course: data['course'] as String,
      advisorName: data['advisor_name'] as String,
      isMandatoryInternship: data['is_mandatory_internship'] as bool? ?? false,
      classShift: ClassShift.fromString(data['class_shift'] as String?),
      internshipShift1:
          InternshipShift.fromString(data['internship_shift_1'] as String?),
      internshipShift2: data['internship_shift_2'] != null
          ? InternshipShift.fromString(data['internship_shift_2'] as String?)
          : null,
      birthDate: DateTime.parse(data['birth_date'] as String),
      contractStartDate: DateTime.parse(data['contract_start_date'] as String),
      contractEndDate: DateTime.parse(data['contract_end_date'] as String),
      totalHoursRequired:
          (data['total_hours_required'] as num?)?.toDouble() ?? 0.0,
      totalHoursCompleted:
          (data['total_hours_completed'] as num?)?.toDouble() ?? 0.0,
      weeklyHoursTarget:
          (data['weekly_hours_target'] as num?)?.toDouble() ?? 0.0,
      profilePictureUrl: data['profile_picture_url'] as String?,
      phoneNumber: data['phone_number'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
      role: UserRole.student,
      user: UserEntity.empty(), // Use a default or empty UserEntity instance
    );
  }

  // Função auxiliar para mapear Map<String, dynamic> para TimeLogEntity
  TimeLogEntity _mapDataToTimeLogEntity(Map<String, dynamic> data) {
    final checkInTimeStr = data['check_in_time'] as String?;
    final checkOutTimeStr = data['check_out_time'] as String?;

    TimeOfDay? parseTime(String? timeStr) {
      if (timeStr == null) return null;
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
      return null;
    }

    final checkIn = parseTime(checkInTimeStr);
    if (checkIn == null) {
      throw const FormatException(
          "check_in_time inválido ou ausente nos dados do time_log.");
    }

    return TimeLogEntity(
      id: data['id'] as String,
      studentId: data['student_id'] as String,
      logDate: DateTime.parse(data['log_date'] as String),
      checkInTime: checkIn,
      checkOutTime: parseTime(checkOutTimeStr),
      hoursLogged: (data['hours_logged'] as num?)?.toDouble(),
      description: data['description'] as String?,
      approved: data['approved'] as bool? ?? false,
      supervisorId: data['supervisor_id'] as String?,
      approvedAt: data['approved_at'] != null
          ? DateTime.parse(data['approved_at'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }

  @override
  Future<Either<AppFailure, StudentEntity>> getStudentDetails(
      String userId) async {
    try {
      final studentData = await _studentDatasource.getStudentDataById(userId);
      if (studentData != null) {
        return Right(_mapDataToStudentEntity(studentData));
      } else {
        return Left(NotFoundFailure(
            message: 'Perfil de estudante não encontrado para o ID: $userId'));
      }
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message:
              'Erro do Supabase ao obter detalhes do estudante: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao obter detalhes do estudante: ${e.toString()}',
          originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, StudentEntity>> updateStudentProfile(
      StudentEntity student) async {
    try {
      final Map<String, dynamic> dataToUpdate = {
        'full_name': student.fullName,
        'registration_number': student.registrationNumber,
        'course': student.course,
        'advisor_name': student.advisorName,
        'is_mandatory_internship': student.isMandatoryInternship,
        'profile_picture_url': student.profilePictureUrl,
        'phone_number': student.phoneNumber,
        'birth_date': student.birthDate?.toIso8601String().substring(0, 10),
        'class_shift': student.classShift?.value,
      };

      // Remove null values
      dataToUpdate.removeWhere((key, value) => value == null);

      if (dataToUpdate.isEmpty) {
        return getStudentDetails(student.id);
      }

      final updatedStudentData =
          await _studentDatasource.updateStudentData(student.id, dataToUpdate);
      return Right(_mapDataToStudentEntity(updatedStudentData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message:
              'Erro do Supabase ao atualizar perfil do estudante: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao atualizar perfil do estudante: ${e.toString()}',
          originalException: e));
    }
  }

  Future<Either<AppFailure, List<TimeLogEntity>>> getStudentTimeLogs({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final timeLogsData = await _timeLogDatasource.getTimeLogsDataForStudent(
        studentId: studentId,
        startDate: startDate,
        endDate: endDate,
      );
      final timeLogEntities =
          timeLogsData.map((data) => _mapDataToTimeLogEntity(data)).toList();
      return Right(timeLogEntities);
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao obter registos de tempo: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao obter registos de tempo: ${e.toString()}',
          originalException: e));
    }
  }

  Future<Either<AppFailure, TimeLogEntity>> createTimeLog({
    required String studentId,
    required DateTime logDate,
    required TimeOfDay checkInTime,
    TimeOfDay? checkOutTime,
    String? description,
  }) async {
    try {
      final Map<String, dynamic> timeLogData = {
        'student_id': studentId,
        'log_date': logDate.toIso8601String().substring(0, 10),
        'check_in_time':
            '${checkInTime.hour.toString().padLeft(2, '0')}:${checkInTime.minute.toString().padLeft(2, '0')}:00',
        if (checkOutTime != null)
          'check_out_time':
              '${checkOutTime.hour.toString().padLeft(2, '0')}:${checkOutTime.minute.toString().padLeft(2, '0')}:00',
        if (description != null) 'description': description,
      };

      if (checkOutTime != null) {
        final start = DateTime(logDate.year, logDate.month, logDate.day,
            checkInTime.hour, checkInTime.minute);
        final end = DateTime(logDate.year, logDate.month, logDate.day,
            checkOutTime.hour, checkOutTime.minute);
        if (end.isAfter(start)) {
          final durationInMinutes = end.difference(start).inMinutes;
          timeLogData['hours_logged'] = (durationInMinutes / 60.0);
        } else {
          timeLogData['hours_logged'] = 0.0;
        }
      }

      final newTimeLogData =
          await _timeLogDatasource.createTimeLogData(timeLogData);
      return Right(_mapDataToTimeLogEntity(newTimeLogData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao criar registo de tempo: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao criar registo de tempo: ${e.toString()}',
          originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, TimeLogEntity>> updateTimeLog(
      TimeLogEntity timeLog) async {
    try {
      final Map<String, dynamic> dataToUpdate = {};
      if (timeLog.description != null) {
        dataToUpdate['description'] = timeLog.description;
      }
      if (timeLog.checkOutTime != null) {
        dataToUpdate['check_out_time'] =
            '${timeLog.checkOutTime!.hour.toString().padLeft(2, '0')}:${timeLog.checkOutTime!.minute.toString().padLeft(2, '0')}:00';
      }

      if (timeLog.checkOutTime != null) {
        final start = DateTime(
            timeLog.logDate.year,
            timeLog.logDate.month,
            timeLog.logDate.day,
            timeLog.checkInTime.hour,
            timeLog.checkInTime.minute);
        final end = DateTime(
            timeLog.logDate.year,
            timeLog.logDate.month,
            timeLog.logDate.day,
            timeLog.checkOutTime!.hour,
            timeLog.checkOutTime!.minute);
        if (end.isAfter(start)) {
          final durationInMinutes = end.difference(start).inMinutes;
          dataToUpdate['hours_logged'] = (durationInMinutes / 60.0);
        } else {
          dataToUpdate['hours_logged'] = timeLog.hoursLogged ?? 0.0;
        }
      }

      if (dataToUpdate.isEmpty) {
        return Right(timeLog);
      }

      final updatedTimeLogData =
          await _timeLogDatasource.updateTimeLogData(timeLog.id, dataToUpdate);
      return Right(_mapDataToTimeLogEntity(updatedTimeLogData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message:
              'Erro do Supabase ao atualizar registo de tempo: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao atualizar registo de tempo: ${e.toString()}',
          originalException: e));
    }
  }

  Future<Either<AppFailure, Unit>> deleteTimeLog(String timeLogId) async {
    try {
      await _timeLogDatasource.deleteTimeLogData(timeLogId);
      return const Right(unit); // Retorna Right(unit) para sucesso com void
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao remover registo de tempo: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao remover registo de tempo: ${e.toString()}',
          originalException: e));
    }
  }

  Future<Either<AppFailure, TimeLogEntity>> checkIn({
    required String studentId,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();
      final timeLogData = {
        'student_id': studentId,
        'log_date': now.toIso8601String().substring(0, 10),
        'check_in_time':
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00',
        if (notes != null && notes.isNotEmpty) 'description': notes,
        'approved': false,
      };
      final createdLogData =
          await _timeLogDatasource.createTimeLogData(timeLogData);
      return Right(_mapDataToTimeLogEntity(createdLogData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao fazer check-in: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido ao fazer check-in: ${e.toString()}',
          originalException: e));
    }
  }

  Future<Either<AppFailure, TimeLogEntity>> checkOut({
    required String studentId,
    required String activeTimeLogId,
    String? description,
  }) async {
    try {
      final activeLogData =
          await _timeLogDatasource.getTimeLogDataById(activeTimeLogId);
      if (activeLogData == null) {
        return Left(NotFoundFailure(
            message: 'Registo de tempo ativo não encontrado para check-out.'));
      }

      final logDate = DateTime.parse(activeLogData['log_date'] as String);
      final checkInTimeStr = activeLogData['check_in_time'] as String?;
      if (checkInTimeStr == null) {
        return Left(ServerFailure(
            message: 'Dados de check-in inválidos no registo ativo.'));
      }
      final checkInParts = checkInTimeStr.split(':');
      final checkInTime = TimeOfDay(
          hour: int.parse(checkInParts[0]), minute: int.parse(checkInParts[1]));

      final now = DateTime.now();
      final checkOutTime = TimeOfDay(hour: now.hour, minute: now.minute);

      final Map<String, dynamic> dataToUpdate = {
        'check_out_time':
            '${checkOutTime.hour.toString().padLeft(2, '0')}:${checkOutTime.minute.toString().padLeft(2, '0')}:00',
      };
      if (description != null && description.isNotEmpty) {
        dataToUpdate['description'] =
            (activeLogData['description'] as String? ?? '') +
                (description.isNotEmpty ? '\nCheckout: $description' : '');
      }

      final startDateTime = DateTime(logDate.year, logDate.month, logDate.day,
          checkInTime.hour, checkInTime.minute);
      final endDateTime = DateTime(logDate.year, logDate.month, logDate.day,
          checkOutTime.hour, checkOutTime.minute);

      if (endDateTime.isAfter(startDateTime)) {
        final durationInMinutes =
            endDateTime.difference(startDateTime).inMinutes;
        dataToUpdate['hours_logged'] = (durationInMinutes / 60.0);
      } else {
        dataToUpdate['hours_logged'] = 0.0;
      }

      final updatedLogData = await _timeLogDatasource.updateTimeLogData(
          activeTimeLogId, dataToUpdate);
      return Right(_mapDataToTimeLogEntity(updatedLogData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao fazer check-out: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } on NotFoundFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido ao fazer check-out: ${e.toString()}',
          originalException: e));
    }
  }
}
