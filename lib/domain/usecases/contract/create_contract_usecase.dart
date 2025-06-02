// lib/domain/usecases/contract/create_contract_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../entities/contract_entity.dart';
import '../../repositories/i_contract_repository.dart'; // Contém UpsertContractParams

class CreateContractUsecase {
  final IContractRepository _repository;

  CreateContractUsecase(this._repository);

  Future<Either<AppFailure, ContractEntity>> call(UpsertContractParams params) async {
    // Validações básicas
    if (params.studentId.isEmpty) {
      return Left(ValidationFailure('O ID do estudante é obrigatório.'));
    }
    if (params.createdBy.isEmpty) {
      return Left(ValidationFailure('O ID do criador do contrato é obrigatório.'));
    }
    if (params.startDate.isAfter(params.endDate)) {
      return Left(ValidationFailure('A data de início não pode ser posterior à data de término.'));
    }
    // Outras validações específicas do contrato podem ser adicionadas aqui.

    // Garante que o ID seja nulo para a criação
    final createParams = UpsertContractParams(
      studentId: params.studentId,
      supervisorId: params.supervisorId,
      contractType: params.contractType,
      status: params.status,
      startDate: params.startDate,
      endDate: params.endDate,
      description: params.description,
      documentUrl: params.documentUrl,
      createdBy: params.createdBy,
    );

    return await _repository.createContract(createParams);
  }
}
