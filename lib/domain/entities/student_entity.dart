import '../../core/enums/class_shift.dart';
import '../../core/enums/internship_shift.dart';

class StudentEntity {
  final String id;
  final String userId;
  final String registration;
  final String course;
  final int semester;
  final ClassShift classShift;
  final InternshipShift internshipShift;
  final String? supervisorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudentEntity({
    required this.id,
    required this.userId,
    required this.registration,
    required this.course,
    required this.semester,
    required this.classShift,
    required this.internshipShift,
    this.supervisorId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentEntity &&
        other.id == id &&
        other.userId == userId &&
        other.registration == registration &&
        other.course == course &&
        other.semester == semester &&
        other.classShift == classShift &&
        other.internshipShift == internshipShift &&
        other.supervisorId == supervisorId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        registration.hashCode ^
        course.hashCode ^
        semester.hashCode ^
        classShift.hashCode ^
        internshipShift.hashCode ^
        supervisorId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'StudentEntity(id: $id, userId: $userId, registration: $registration, course: $course, semester: $semester, classShift: $classShift, internshipShift: $internshipShift, supervisorId: $supervisorId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

