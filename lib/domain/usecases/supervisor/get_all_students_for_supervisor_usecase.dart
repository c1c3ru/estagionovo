// lib/domain/usecases/supervisor/get_all_students_for_supervisor_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/student.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../repositories/i_supervisor_repository.dart'; // Contém FilterStudentsParams

class GetAllStudentsForSupervisorUsecase {
  final ISupervisorRepository _repository;

  GetAllStudentsForSupervisorUsecase(this._repository);

  Future<Either<AppFailure, List<StudentEntity>>> call(
      FilterStudentsParams? params) async {
    // Nenhuma validação complexa nos parâmetros aqui, o repositório pode lidar com params nulos.
    return await _repository.getAllStudents(params);
  }
}
