// lib/domain/usecases/contract/get_contracts_for_student_usecase.dart
import '../../../core/errors/app_exceptions.dart';
import '../../entities/contract_entity.dart';
import '../../repositories/i_contract_repository.dart';

class GetContractsForStudentUsecase {
  final IContractRepository _repository;

  GetContractsForStudentUsecase(this._repository);

  Future<Either<AppFailure, List<ContractEntity>>> call(
      String studentId) async {
    if (studentId.isEmpty) {
      return Left(
          const ValidationFailure('O ID do estudante não pode estar vazio.'));
    }
    return await _repository.getContractsForStudent(studentId);
  }
}
