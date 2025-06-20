import 'package:dartz/dartz.dart';
import 'package:student_supervisor_app/core/errors/app_exceptions.dart';

import '../../repositories/i_contract_repository.dart';
import '../../entities/contract_entity.dart';

class GetContractsByStudentUsecase {
  final IContractRepository _contractRepository;

  GetContractsByStudentUsecase(this._contractRepository);

  Future<Either<AppFailure, List<ContractEntity>>> call(
      String studentId) async {
    return await _contractRepository.getContractsByStudent(studentId);
  }
}
