import '../../repositories/i_student_repository.dart';
import '../../entities/student_entity.dart';

class GetAllStudentsUsecase {
  final IStudentRepository _studentRepository;

  GetAllStudentsUsecase(this._studentRepository);

  Future<List<StudentEntity>> call() async {
    try {
      return await _studentRepository.getAllStudents();
    } catch (e) {
      throw Exception('Erro ao buscar estudantes: $e');
    }
  }
}

