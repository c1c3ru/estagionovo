import 'package:student_supervisor_app/core/enums/contract_status.dart';

import '../entities/contract_entity.dart';

abstract class IContractRepository {
  Future<List<ContractEntity>> getAllContracts(
      {String? studentId, String? supervisorId, ContractStatus? status});
  Future<ContractEntity?> getContractById(String id);
  Future<List<ContractEntity>> getContractsByStudent(String studentId);
  Future<List<ContractEntity>> getContractsBySupervisor(String supervisorId);
  Future<ContractEntity?> getActiveContractByStudent(String studentId);
  Future<ContractEntity> createContract(ContractEntity contract);
  Future<ContractEntity> updateContract(ContractEntity contract);
  Future<void> deleteContract(String id);
  Future<Map<String, dynamic>> getContractStatistics();
}
