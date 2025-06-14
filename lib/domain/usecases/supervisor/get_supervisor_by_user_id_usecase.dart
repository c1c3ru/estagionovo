import '../../repositories/i_supervisor_repository.dart';
import '../../entities/supervisor_entity.dart';

class GetSupervisorByUserIdUsecase {
  final ISupervisorRepository _supervisorRepository;

  GetSupervisorByUserIdUsecase(this._supervisorRepository);

  Future<SupervisorEntity?> call(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('ID do usuário não pode estar vazio');
      }
      return await _supervisorRepository.getSupervisorByUserId(userId);
    } catch (e) {
      throw Exception('Erro ao buscar supervisor por usuário: $e');
    }
  }
}

