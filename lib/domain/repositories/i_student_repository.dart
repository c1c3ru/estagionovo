import '../entities/student_entity.dart';

abstract class IStudentRepository {
  Future<List<StudentEntity>> getAllStudents();
  Future<StudentEntity?> getStudentById(String id);
  Future<StudentEntity?> getStudentByUserId(String userId);
  Future<StudentEntity> createStudent(StudentEntity student);
  Future<StudentEntity> updateStudent(StudentEntity student);
  Future<void> deleteStudent(String id);
  Future<List<StudentEntity>> getStudentsBySupervisor(String supervisorId);
}

