import '../../repositories/i_contract_repository.dart';
import '../../entities/contract_entity.dart';

class GetContractsByStudentUsecase {
  final IContractRepository _contractRepository;

  GetContractsByStudentUsecase(this._contractRepository);

  Future<List<ContractEntity>> call(String studentId) async {
    try {
      if (studentId.isEmpty) {
        throw Exception('ID do estudante não pode estar vazio');
      }
      
      return await _contractRepository.getContractsByStudent(studentId);
    } catch (e) {
      throw Exception('Erro ao buscar contratos do estudante: $e');
    }
  }
}

