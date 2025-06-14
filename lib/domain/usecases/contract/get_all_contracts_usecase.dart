// lib/domain/usecases/contract/get_all_contracts_usecase.dart

import 'package:student_supervisor_app/core/enums/contract_status.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../entities/contract_entity.dart';
import '../../repositories/i_contract_repository.dart';

class GetAllContractsParams {
  final String? studentId;
  final String? supervisorId;
  final ContractStatus? status;

  GetAllContractsParams({this.studentId, this.supervisorId, this.status});
}

class GetAllContractsUsecase {
  final IContractRepository _repository;

  GetAllContractsUsecase(this._repository);

  Future<Either<AppFailure, List<ContractEntity>>> call(
      GetAllContractsParams params) async {
    // Validações nos parâmetros de filtro podem ser adicionadas aqui, se necessário.
    return await _repository.getAllContracts(
      studentId: params.studentId,
      supervisorId: params.supervisorId,
      status: params.status,
    );
  }
}
