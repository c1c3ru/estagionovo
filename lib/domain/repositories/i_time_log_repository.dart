// lib/domain/repositories/i_time_log_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/time_log_entity.dart';
import '../../core/errors/app_exceptions.dart';
import 'package:flutter/material.dart'; // Para TimeOfDay

// Parâmetros para criar um TimeLog
class CreateTimeLogParams {
  final String studentId;
  final DateTime logDate;
  final TimeOfDay checkInTime;
  final TimeOfDay? checkOutTime;
  final String? description;
  // approved, supervisorId, approvedAt são geralmente definidos por um supervisor, não na criação inicial pelo estudante
}

// Parâmetros para atualizar um TimeLog
class UpdateTimeLogParams {
  final String timeLogId;
  final DateTime? logDate;
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;
  final String? description;
  // Campos de aprovação
  final bool? approved;
  final String? supervisorId; // Quem aprovou/rejeitou
  final DateTime? approvedAt;
}

abstract class ITimeLogRepository {
  /// Cria um novo registo de tempo.
  Future<Either<AppFailure, TimeLogEntity>> createTimeLog({
    required String studentId,
    required DateTime logDate,
    required TimeOfDay checkInTime,
    TimeOfDay? checkOutTime,
    String? description,
  });

  /// Obtém um registo de tempo específico pelo seu ID.
  Future<Either<AppFailure, TimeLogEntity>> getTimeLogById(String timeLogId);

  /// Obtém todos os registos de tempo para um estudante específico num intervalo de datas.
  Future<Either<AppFailure, List<TimeLogEntity>>> getTimeLogsForStudent({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Atualiza um registo de tempo existente.
  /// Pode ser usado tanto pelo estudante (para adicionar checkout/descrição)
  /// quanto pelo supervisor (para aprovar/rejeitar).
  Future<Either<AppFailure, TimeLogEntity>> updateTimeLog(UpdateTimeLogParams params);

  /// Remove um registo de tempo.
  /// Geralmente feito pelo estudante ou por um supervisor/admin.
  Future<Either<AppFailure, void>> deleteTimeLog(String timeLogId);

  /// Obtém todos os registos de tempo que requerem aprovação.
  Future<Either<AppFailure, List<TimeLogEntity>>> getPendingApprovalTimeLogs();
}
s