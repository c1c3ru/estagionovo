// lib/domain/usecases/supervisor/get_student_details_for_supervisor_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/student.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../entities/student_entity.dart';
import '../../repositories/i_supervisor_repository.dart';

class GetStudentDetailsForSupervisorUsecase {
  final ISupervisorRepository _repository;

  GetStudentDetailsForSupervisorUsecase(this._repository);

  Future<Either<AppFailure, StudentEntity>> call(String studentId) async {
    if (studentId.isEmpty) {
      return Left(ValidationFailure('O ID do estudante não pode estar vazio.'));
    }
    return await _repository.getStudentDetailsForSupervisor(studentId);
  }
}
