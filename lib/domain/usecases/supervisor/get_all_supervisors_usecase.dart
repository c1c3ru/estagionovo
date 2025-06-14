import '../../repositories/i_supervisor_repository.dart';
import '../../entities/supervisor_entity.dart';

class GetAllSupervisorsUsecase {
  final ISupervisorRepository _supervisorRepository;

  GetAllSupervisorsUsecase(this._supervisorRepository);

  Future<List<SupervisorEntity>> call() async {
    try {
      return await _supervisorRepository.getAllSupervisors();
    } catch (e) {
      throw Exception('Erro ao buscar supervisores: $e');
    }
  }
}

