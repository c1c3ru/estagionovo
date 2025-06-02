// lib/domain/usecases/supervisor/approve_or_reject_time_log_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/time_log.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../entities/time_log_entity.dart';
import '../../repositories/i_supervisor_repository.dart';

class ApproveOrRejectTimeLogUsecase {
  final ISupervisorRepository _repository;

  ApproveOrRejectTimeLogUsecase(this._repository);

  Future<Either<AppFailure, TimeLogEntity>> call({
    required String timeLogId,
    required bool approved,
    required String supervisorId, // ID do supervisor que está a realizar a ação
    String? rejectionReason,
  }) async {
    if (timeLogId.isEmpty) {
      return Left(
        ValidationFailure('O ID do registo de tempo não pode estar vazio.'),
      );
    }
    if (supervisorId.isEmpty) {
      return Left(ValidationFailure('O ID do supervisor é obrigatório.'));
    }
    if (!approved &&
        (rejectionReason == null || rejectionReason.trim().isEmpty)) {
      // Poderia ser uma regra de negócio que a rejeição requer um motivo.
      // return Left(ValidationFailure('Um motivo é obrigatório ao rejeitar um registo de tempo.'));
    }
    return await _repository.approveOrRejectTimeLog(
      timeLogId: timeLogId,
      approved: approved,
      supervisorId: supervisorId,
      rejectionReason: rejectionReason,
    );
  }
}
