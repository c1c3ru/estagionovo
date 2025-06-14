import '../../repositories/i_supervisor_repository.dart';
import '../../entities/supervisor_entity.dart';

class GetSupervisorByIdUsecase {
  final ISupervisorRepository _supervisorRepository;

  GetSupervisorByIdUsecase(this._supervisorRepository);

  Future<SupervisorEntity?> call(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID do supervisor não pode estar vazio');
      }
      return await _supervisorRepository.getSupervisorById(id);
    } catch (e) {
      throw Exception('Erro ao buscar supervisor: $e');
    }
  }
}

