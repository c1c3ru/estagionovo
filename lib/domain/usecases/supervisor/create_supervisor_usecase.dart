import '../../repositories/i_supervisor_repository.dart';
import '../../entities/supervisor_entity.dart';

class CreateSupervisorUsecase {
  final ISupervisorRepository _supervisorRepository;

  CreateSupervisorUsecase(this._supervisorRepository);

  Future<SupervisorEntity> call(SupervisorEntity supervisor) async {
    try {
      // Validações
      if (supervisor.department.isEmpty) {
        throw Exception('Departamento é obrigatório');
      }
      
      if (supervisor.specialization.isEmpty) {
        throw Exception('Especialização é obrigatória');
      }

      return await _supervisorRepository.createSupervisor(supervisor);
    } catch (e) {
      throw Exception('Erro ao criar supervisor: $e');
    }
  }
}

