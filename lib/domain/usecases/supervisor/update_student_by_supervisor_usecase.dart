// lib/domain/usecases/supervisor/update_student_by_supervisor_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/student.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../entities/student_entity.dart';
import '../../repositories/i_supervisor_repository.dart';

class UpdateStudentBySupervisorUsecase {
  final ISupervisorRepository _repository;

  UpdateStudentBySupervisorUsecase(this._repository);

  Future<Either<AppFailure, StudentEntity>> call(
    StudentEntity studentData,
  ) async {
    if (studentData.id.isEmpty) {
      return Left(
        ValidationFailure('O ID do estudante é obrigatório para atualização.'),
      );
    }
    if (studentData.fullName.trim().isEmpty) {
      return Left(
        ValidationFailure('O nome completo do estudante é obrigatório.'),
      );
    }
    // Adicione outras validações.
    return await _repository.updateStudentBySupervisor(studentData);
  }
}
