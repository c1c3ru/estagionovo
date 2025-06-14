import '../../repositories/i_contract_repository.dart';
import '../../entities/contract_entity.dart';

class UpdateContractUsecase {
  final IContractRepository _contractRepository;

  UpdateContractUsecase(this._contractRepository);

  Future<ContractEntity> call(ContractEntity contract) async {
    try {
      // Validações
      if (contract.id.isEmpty) {
        throw Exception('ID do contrato é obrigatório');
      }
      
      if (contract.studentId.isEmpty) {
        throw Exception('ID do estudante é obrigatório');
      }
      
      if (contract.supervisorId.isEmpty) {
        throw Exception('ID do supervisor é obrigatório');
      }
      
      if (contract.company.isEmpty) {
        throw Exception('Empresa é obrigatória');
      }
      
      if (contract.position.isEmpty) {
        throw Exception('Cargo é obrigatório');
      }
      
      if (contract.weeklyHours <= 0) {
        throw Exception('Horas semanais devem ser maior que zero');
      }
      
      if (contract.startDate.isAfter(contract.endDate)) {
        throw Exception('Data de início deve ser anterior à data de fim');
      }

      return await _contractRepository.updateContract(contract);
    } catch (e) {
      throw Exception('Erro ao atualizar contrato: $e');
    }
  }
}

