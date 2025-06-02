// lib/domain/usecases/contract/update_contract_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../entities/contract_entity.dart';
import '../../repositories/i_contract_repository.dart'; // Contém UpsertContractParams

class UpdateContractUsecase {
  final IContractRepository _repository;

  UpdateContractUsecase(this._repository);

  Future<Either<AppFailure, ContractEntity>> call(UpsertContractParams params) async {
    // Validações básicas
    if (params.id == null || params.id!.isEmpty) {
      return Left(ValidationFailure('O ID do contrato é obrigatório para atualização.'));
    }
    if (params.studentId.isEmpty) {
      return Left(ValidationFailure('O ID do estudante é obrigatório.'));
    }
     if (params.createdBy.isEmpty) {
      return Left(ValidationFailure('O ID do atualizador do contrato é obrigatório.'));
    }
    if (params.startDate.isAfter(params.endDate)) {
      return Left(ValidationFailure('A data de início não pode ser posterior à data de término.'));
    }
    // Outras validações específicas do contrato podem ser adicionadas aqui.
    return await _repository.updateContract(params);
  }
}
