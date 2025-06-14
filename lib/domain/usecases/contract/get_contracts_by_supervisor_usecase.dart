import '../../repositories/i_contract_repository.dart';
import '../../entities/contract_entity.dart';

class GetContractsBySupervisorUsecase {
  final IContractRepository _contractRepository;

  GetContractsBySupervisorUsecase(this._contractRepository);

  Future<List<ContractEntity>> call(String supervisorId) async {
    try {
      if (supervisorId.isEmpty) {
        throw Exception('ID do supervisor não pode estar vazio');
      }
      
      return await _contractRepository.getContractsBySupervisor(supervisorId);
    } catch (e) {
      throw Exception('Erro ao buscar contratos do supervisor: $e');
    }
  }
}

