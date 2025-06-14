import '../../domain/repositories/i_student_repository.dart';
import '../../domain/entities/student_entity.dart';
import '../datasources/supabase/student_datasource.dart';
import '../models/student_model.dart';

class StudentRepository implements IStudentRepository {
  final StudentDatasource _studentDatasource;

  StudentRepository(this._studentDatasource);

  @override
  Future<List<StudentEntity>> getAllStudents() async {
    try {
      final studentsData = await _studentDatasource.getAllStudents();
      return studentsData
          .map((data) => StudentModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar estudantes: $e');
    }
  }

  @override
  Future<StudentEntity?> getStudentById(String id) async {
    try {
      final studentData = await _studentDatasource.getStudentById(id);
      if (studentData == null) return null;
      return StudentModel.fromJson(studentData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar estudante: $e');
    }
  }

  @override
  Future<StudentEntity?> getStudentByUserId(String userId) async {
    try {
      final studentData = await _studentDatasource.getStudentByUserId(userId);
      if (studentData == null) return null;
      return StudentModel.fromJson(studentData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar estudante por usuário: $e');
    }
  }

  @override
  Future<StudentEntity> createStudent(StudentEntity student) async {
    try {
      final studentModel = StudentModel.fromEntity(student);
      final createdData = await _studentDatasource.createStudent(studentModel.toJson());
      return StudentModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao criar estudante: $e');
    }
  }

  @override
  Future<StudentEntity> updateStudent(StudentEntity student) async {
    try {
      final studentModel = StudentModel.fromEntity(student);
      final updatedData = await _studentDatasource.updateStudent(
        student.id,
        studentModel.toJson(),
      );
      return StudentModel.fromJson(updatedData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao atualizar estudante: $e');
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      await _studentDatasource.deleteStudent(id);
    } catch (e) {
      throw Exception('Erro no repositório ao excluir estudante: $e');
    }
  }

  @override
  Future<List<StudentEntity>> getStudentsBySupervisor(String supervisorId) async {
    try {
      final studentsData = await _studentDatasource.getStudentsBySupervisor(supervisorId);
      return studentsData
          .map((data) => StudentModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar estudantes do supervisor: $e');
    }
  }
}

