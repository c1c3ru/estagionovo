// lib/domain/usecases/contract/delete_contract_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../repositories/i_contract_repository.dart';

class DeleteContractUsecase {
  final IContractRepository _repository;

  DeleteContractUsecase(this._repository);

  Future<Either<AppFailure, void>> call(String contractId) async {
    if (contractId.isEmpty) {
      return Left(ValidationFailure('O ID do contrato não pode estar vazio.'));
    }
    return await _repository.deleteContract(contractId);
  }
}
