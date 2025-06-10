import 'package:dartz/dartz.dart';
import 'package:estagio/core/constants/app_failure.dart';
import 'package:flutter/material.dart'; // Para TimeOfDay
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../../core/errors/app_exceptions.dart';
import '../../domain/entities/time_log_entity.dart';
import '../../domain/repositories/i_time_log_repository.dart'; // Contém UpdateTimeLogParams
import '../datasources/supabase/time_log_datasource.dart';

class TimeLogRepository implements ITimeLogRepository {
  final ITimeLogSupabaseDatasource _timeLogDatasource;

  TimeLogRepository(this._timeLogDatasource);

  // Função auxiliar para mapear Map<String, dynamic> para TimeLogEntity
  TimeLogEntity _mapDataToTimeLogEntity(Map<String, dynamic> data) {
    // Helper para converter string 'HH:mm:ss' ou 'HH:mm' para TimeOfDay
    TimeOfDay? parseTime(String? timeStr) {
      if (timeStr == null) {
        return null;
      }
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
      return null;
    }

    final checkIn = parseTime(data['check_in_time'] as String?);
    if (checkIn == null) {
      throw const FormatException(
          "check_in_time inválido ou ausente nos dados do time_log.");
    }

    // CORREÇÃO: Mapeamento direto para os tipos corretos da TimeLogEntity.
    return TimeLogEntity(
      id: data['id'] as String,
      studentId: data['student_id'] as String,
      logDate: DateTime.parse(data['log_date'] as String),
      checkInTime: checkIn, // Agora é TimeOfDay, como esperado pela entidade
      checkOutTime:
          parseTime(data['check_out_time'] as String?), // E aqui também
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

  // Helper para converter TimeOfDay para string 'HH:mm:ss' para o banco de dados
  String? _formatTimeOfDayForDb(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  @override
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
        'check_in_time': _formatTimeOfDayForDb(checkInTime),
        if (checkOutTime != null)
          'check_out_time': _formatTimeOfDayForDb(checkOutTime),
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
  Future<Either<AppFailure, TimeLogEntity>> getTimeLogById(
      String timeLogId) async {
    try {
      final timeLogData =
          await _timeLogDatasource.getTimeLogDataById(timeLogId);
      if (timeLogData != null) {
        return Right(_mapDataToTimeLogEntity(timeLogData));
      } else {
        return Left(NotFoundFailure(
            message: 'Registo de tempo não encontrado com ID: $timeLogId'));
      }
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao obter registo de tempo: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao obter registo de tempo: ${e.toString()}',
          originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, List<TimeLogEntity>>> getTimeLogsForStudent({
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
          message:
              'Erro do Supabase ao obter registos de tempo do estudante: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao obter registos de tempo do estudante: ${e.toString()}',
          originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, TimeLogEntity>> updateTimeLog(
      UpdateTimeLogParams params) async {
    try {
      final Map<String, dynamic> dataToUpdate = {};
      if (params.logDate != null) {
        dataToUpdate['log_date'] =
            params.logDate!.toIso8601String().substring(0, 10);
      }
      if (params.checkInTime != null) {
        dataToUpdate['check_in_time'] =
            _formatTimeOfDayForDb(params.checkInTime);
      }
      if (params.checkOutTime != null) {
        dataToUpdate['check_out_time'] =
            _formatTimeOfDayForDb(params.checkOutTime);
      }
      if (params.description != null) {
        dataToUpdate['description'] = params.description;
      }
      if (params.approved != null) {
        dataToUpdate['approved'] = params.approved;
      }
      if (params.supervisorId != null) {
        dataToUpdate['supervisor_id'] = params.supervisorId;
      }
      if (params.approvedAt != null) {
        dataToUpdate['approved_at'] = params.approvedAt!.toIso8601String();
      }

      TimeOfDay? finalCheckIn = params.checkInTime;
      TimeOfDay? finalCheckOut = params.checkOutTime;
      DateTime? finalLogDate = params.logDate;

      if (finalCheckIn == null ||
          finalCheckOut == null ||
          finalLogDate == null) {
        final existingLogEither = await getTimeLogById(params.timeLogId);
        existingLogEither.fold(
          (failure) {
            // não faz nada, hours_logged não será recalculado
          },
          (existingLog) {
            finalLogDate ??= existingLog.logDate;
            finalCheckIn ??= existingLog.checkInTime;
            finalCheckOut ??= existingLog.checkOutTime;
          },
        );
      }

      if (finalCheckIn != null &&
          finalCheckOut != null &&
          finalLogDate != null) {
        final start = DateTime(finalLogDate!.year, finalLogDate!.month,
            finalLogDate!.day, finalCheckIn!.hour, finalCheckIn!.minute);
        final end = DateTime(finalLogDate!.year, finalLogDate!.month,
            finalLogDate!.day, finalCheckOut!.hour, finalCheckOut!.minute);
        if (end.isAfter(start)) {
          final durationInMinutes = end.difference(start).inMinutes;
          dataToUpdate['hours_logged'] = (durationInMinutes / 60.0);
        } else {
          dataToUpdate['hours_logged'] = 0.0;
        }
      }

      if (dataToUpdate.isEmpty) {
        return getTimeLogById(params.timeLogId);
      }

      final updatedTimeLogData = await _timeLogDatasource.updateTimeLogData(
          params.timeLogId, dataToUpdate);
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

  @override
  Future<Either<AppFailure, void>> deleteTimeLog(String timeLogId) async {
    try {
      await _timeLogDatasource.deleteTimeLogData(timeLogId);
      return const Right(null);
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

  @override
  Future<Either<AppFailure, List<TimeLogEntity>>>
      getPendingApprovalTimeLogs() async {
    try {
      final timeLogsData =
          await _timeLogDatasource.getAllTimeLogsData(approved: false);
      final timeLogEntities =
          timeLogsData.map((data) => _mapDataToTimeLogEntity(data)).toList();
      return Right(timeLogEntities);
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(
          message: 'Erro do Supabase ao obter registos pendentes: ${e.message}',
          originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(
          message:
              'Erro desconhecido ao obter registos pendentes: ${e.toString()}',
          originalException: e));
    }
  }
}
