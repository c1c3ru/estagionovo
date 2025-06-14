// ignore_for_file: override_on_non_overriding_member

import '../../domain/repositories/i_time_log_repository.dart';
import '../../domain/entities/time_log_entity.dart';
import '../datasources/supabase/time_log_datasource.dart';
import '../models/time_log_model.dart';

abstract class TimeLogRepository implements ITimeLogRepository {
  final TimeLogDatasource _timeLogDatasource;

  TimeLogRepository(this._timeLogDatasource);

  @override
  Future<List<TimeLogEntity>> getAllTimeLogs() async {
    try {
      final timeLogsData = await _timeLogDatasource.getAllTimeLogs();
      return timeLogsData
          .map((data) => TimeLogModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar registros de horas: $e');
    }
  }

  @override
  Future<TimeLogEntity?> getTimeLogById(String id) async {
    try {
      final timeLogData = await _timeLogDatasource.getTimeLogById(id);
      if (timeLogData == null) return null;
      return TimeLogModel.fromJson(timeLogData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar registro de horas: $e');
    }
  }

  @override
  Future<List<TimeLogEntity>> getTimeLogsByStudent(String studentId) async {
    try {
      final timeLogsData =
          await _timeLogDatasource.getTimeLogsByStudent(studentId);
      return timeLogsData
          .map((data) => TimeLogModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception(
          'Erro no repositório ao buscar registros do estudante: $e');
    }
  }

  @override
  Future<List<TimeLogEntity>> getTimeLogsByDateRange(
    String studentId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final timeLogsData = await _timeLogDatasource.getTimeLogsByDateRange(
        studentId,
        startDate,
        endDate,
      );
      return timeLogsData
          .map((data) => TimeLogModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception(
          'Erro no repositório ao buscar registros por período: $e');
    }
  }

  @override
  Future<TimeLogEntity?> getActiveTimeLog(String studentId) async {
    try {
      final timeLogData = await _timeLogDatasource.getActiveTimeLog(studentId);
      if (timeLogData == null) return null;
      return TimeLogModel.fromJson(timeLogData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar registro ativo: $e');
    }
  }

  @override
  Future<TimeLogEntity> createTimeLog(TimeLogEntity timeLog) async {
    try {
      final timeLogModel = TimeLogModel.fromEntity(timeLog);
      final createdData =
          await _timeLogDatasource.createTimeLog(timeLogModel.toJson());
      return TimeLogModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao criar registro de horas: $e');
    }
  }

  @override
  Future<TimeLogEntity> updateTimeLog(TimeLogEntity timeLog) async {
    try {
      final timeLogModel = TimeLogModel.fromEntity(timeLog);
      final updatedData = await _timeLogDatasource.updateTimeLog(
        timeLog.id,
        timeLogModel.toJson(),
      );
      return TimeLogModel.fromJson(updatedData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao atualizar registro de horas: $e');
    }
  }

  @override
  Future<void> deleteTimeLog(String id) async {
    try {
      await _timeLogDatasource.deleteTimeLog(id);
    } catch (e) {
      throw Exception('Erro no repositório ao excluir registro de horas: $e');
    }
  }

  @override
  Future<TimeLogEntity> clockIn(String studentId, {String? description}) async {
    try {
      final timeLogData =
          await _timeLogDatasource.clockIn(studentId, notes: description);
      return TimeLogModel.fromJson(timeLogData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao registrar entrada: $e');
    }
  }

  @override
  Future<TimeLogEntity> clockOut(String studentId, {String? notes}) async {
    try {
      final timeLogData =
          await _timeLogDatasource.clockOut(studentId, notes: notes);
      return TimeLogModel.fromJson(timeLogData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao registrar saída: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getTotalHoursByStudent(
    String studentId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _timeLogDatasource.getTotalHoursByStudent(
        studentId,
        startDate,
        endDate,
      );
    } catch (e) {
      throw Exception('Erro no repositório ao calcular horas totais: $e');
    }
  }

  @override
  Future<List<TimeLogEntity>> getTimeLogsBySupervisor(
      String supervisorId) async {
    try {
      final timeLogsData =
          await _timeLogDatasource.getTimeLogsBySupervisor(supervisorId);
      return timeLogsData
          .map((data) => TimeLogModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception(
          'Erro no repositório ao buscar registros do supervisor: $e');
    }
  }
}
