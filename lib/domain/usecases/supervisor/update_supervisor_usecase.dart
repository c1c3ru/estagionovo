import '../../repositories/i_supervisor_repository.dart';
import '../../entities/supervisor_entity.dart';

class UpdateSupervisorUsecase {
  final ISupervisorRepository _supervisorRepository;

  UpdateSupervisorUsecase(this._supervisorRepository);

  Future<SupervisorEntity> call(SupervisorEntity supervisor) async {
    try {
      // Validações
      if (supervisor.id.isEmpty) {
        throw Exception('ID do supervisor é obrigatório');
      }
      
      if (supervisor.department.isEmpty) {
        throw Exception('Departamento é obrigatório');
      }
      
      if (supervisor.specialization.isEmpty) {
        throw Exception('Especialização é obrigatória');
      }

      return await _supervisorRepository.updateSupervisor(supervisor);
    } catch (e) {
      throw Exception('Erro ao atualizar supervisor: $e');
    }
  }
}

