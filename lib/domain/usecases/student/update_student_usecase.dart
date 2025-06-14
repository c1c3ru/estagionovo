import '../../repositories/i_student_repository.dart';
import '../../entities/student_entity.dart';

class UpdateStudentUsecase {
  final IStudentRepository _studentRepository;

  UpdateStudentUsecase(this._studentRepository);

  Future<StudentEntity> call(StudentEntity student) async {
    try {
      // Validações
      if (student.id.isEmpty) {
        throw Exception('ID do estudante é obrigatório');
      }
      
      if (student.registration.isEmpty) {
        throw Exception('Matrícula é obrigatória');
      }
      
      if (student.course.isEmpty) {
        throw Exception('Curso é obrigatório');
      }
      
      if (student.semester <= 0) {
        throw Exception('Semestre deve ser maior que zero');
      }

      return await _studentRepository.updateStudent(student);
    } catch (e) {
      throw Exception('Erro ao atualizar estudante: $e');
    }
  }
}

