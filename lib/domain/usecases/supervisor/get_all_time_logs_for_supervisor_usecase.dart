// lib/domain/usecases/supervisor/get_all_time_logs_for_supervisor_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/time_log.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../entities/time_log_entity.dart';
import '../../repositories/i_supervisor_repository.dart';

class GetAllTimeLogsForSupervisorUsecase {
  final ISupervisorRepository _repository;

  GetAllTimeLogsForSupervisorUsecase(this._repository);

  Future<Either<AppFailure, List<TimeLogEntity>>> call({
    String? studentId,
    bool? pendingApprovalOnly,
  }) async {
    return await _repository.getAllTimeLogs(
      studentId: studentId,
      pendingApprovalOnly: pendingApprovalOnly,
    );
  }
}
