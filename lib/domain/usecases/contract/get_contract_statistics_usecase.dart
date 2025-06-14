import '../../repositories/i_contract_repository.dart';

class GetContractStatisticsUsecase {
  final IContractRepository _contractRepository;

  GetContractStatisticsUsecase(this._contractRepository);

  Future<Map<String, dynamic>> call() async {
    try {
      return await _contractRepository.getContractStatistics();
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas de contratos: $e');
    }
  }
}

