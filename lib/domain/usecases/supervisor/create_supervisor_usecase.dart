import 'package:dartz/dartz.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../repositories/i_supervisor_repository.dart';
import '../../entities/supervisor_entity.dart';

class CreateSupervisorUsecase {
  final ISupervisorRepository _supervisorRepository;

  CreateSupervisorUsecase(this._supervisorRepository);

  Future<Either<AppFailure, SupervisorEntity>> call(
      SupervisorEntity supervisor) async {
    // Validações
    if (supervisor.department.isEmpty) {
      return const Left(ValidationFailure('Departamento é obrigatório'));
    }

    if (supervisor.specialization.isEmpty) {
      return const Left(ValidationFailure('Especialização é obrigatória'));
    }

    return await _supervisorRepository.createSupervisor(supervisor);
  }
}
