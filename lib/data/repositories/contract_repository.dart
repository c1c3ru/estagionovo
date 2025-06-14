import '../../domain/repositories/i_contract_repository.dart';
import '../../domain/entities/contract_entity.dart';
import '../datasources/supabase/contract_datasource.dart';
import '../models/contract_model.dart';

class ContractRepository implements IContractRepository {
  final ContractDatasource _contractDatasource;

  ContractRepository(this._contractDatasource);

  @override
  Future<List<ContractEntity>> getAllContracts() async {
    try {
      final contractsData = await _contractDatasource.getAllContracts();
      return contractsData
          .map((data) => ContractModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contratos: $e');
    }
  }

  @override
  Future<ContractEntity?> getContractById(String id) async {
    try {
      final contractData = await _contractDatasource.getContractById(id);
      if (contractData == null) return null;
      return ContractModel.fromJson(contractData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contrato: $e');
    }
  }

  @override
  Future<List<ContractEntity>> getContractsByStudent(String studentId) async {
    try {
      final contractsData = await _contractDatasource.getContractsByStudent(studentId);
      return contractsData
          .map((data) => ContractModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contratos do estudante: $e');
    }
  }

  @override
  Future<List<ContractEntity>> getContractsBySupervisor(String supervisorId) async {
    try {
      final contractsData = await _contractDatasource.getContractsBySupervisor(supervisorId);
      return contractsData
          .map((data) => ContractModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contratos do supervisor: $e');
    }
  }

  @override
  Future<List<ContractEntity>> getActiveContracts() async {
    try {
      final contractsData = await _contractDatasource.getActiveContracts();
      return contractsData
          .map((data) => ContractModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contratos ativos: $e');
    }
  }

  @override
  Future<ContractEntity> createContract(ContractEntity contract) async {
    try {
      final contractModel = ContractModel.fromEntity(contract);
      final createdData = await _contractDatasource.createContract(contractModel.toJson());
      return ContractModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao criar contrato: $e');
    }
  }

  @override
  Future<ContractEntity> updateContract(ContractEntity contract) async {
    try {
      final contractModel = ContractModel.fromEntity(contract);
      final updatedData = await _contractDatasource.updateContract(
        contract.id,
        contractModel.toJson(),
      );
      return ContractModel.fromJson(updatedData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao atualizar contrato: $e');
    }
  }

  @override
  Future<void> deleteContract(String id) async {
    try {
      await _contractDatasource.deleteContract(id);
    } catch (e) {
      throw Exception('Erro no repositório ao excluir contrato: $e');
    }
  }

  @override
  Future<ContractEntity?> getActiveContractByStudent(String studentId) async {
    try {
      final contractData = await _contractDatasource.getActiveContractByStudent(studentId);
      if (contractData == null) return null;
      return ContractModel.fromJson(contractData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contrato ativo do estudante: $e');
    }
  }

  @override
  Future<List<ContractEntity>> getExpiringContracts(int daysAhead) async {
    try {
      final contractsData = await _contractDatasource.getExpiringContracts(daysAhead);
      return contractsData
          .map((data) => ContractModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar contratos próximos do vencimento: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getContractStatistics() async {
    try {
      return await _contractDatasource.getContractStatistics();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar estatísticas de contratos: $e');
    }
  }
}

