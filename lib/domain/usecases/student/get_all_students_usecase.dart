import 'package:dartz/dartz.dart';
import 'package:student_supervisor_app/core/errors/app_exceptions.dart';
import '../../repositories/i_student_repository.dart';
import '../../entities/student_entity.dart';

class GetAllStudentsUsecase {
  final IStudentRepository _studentRepository;

  GetAllStudentsUsecase(this._studentRepository);

  Future<Either<AppFailure, List<StudentEntity>>> call() async {
    return await _studentRepository.getAllStudents();
  }
}
