import '../../repositories/i_contract_repository.dart';
import '../../entities/contract_entity.dart';

class GetActiveContractByStudentUsecase {
  final IContractRepository _contractRepository;

  GetActiveContractByStudentUsecase(this._contractRepository);

  Future<ContractEntity?> call(String studentId) async {
    try {
      if (studentId.isEmpty) {
        throw Exception('ID do estudante não pode estar vazio');
      }
      
      return await _contractRepository.getActiveContractByStudent(studentId);
    } catch (e) {
      throw Exception('Erro ao buscar contrato ativo do estudante: $e');
    }
  }
}

