import '../../domain/entities/student_entity.dart';
import '../../core/enums/class_shift.dart';
import '../../core/enums/internship_shift.dart';

class StudentModel {
  final String id;
  final String userId;
  final String registration;
  final String course;
  final int semester;
  final String classShift;
  final String internshipShift;
  final String? supervisorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentModel({
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

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      registration: json['registration'] as String,
      course: json['course'] as String,
      semester: json['semester'] as int,
      classShift: json['class_shift'] as String,
      internshipShift: json['internship_shift'] as String,
      supervisorId: json['supervisor_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'registration': registration,
      'course': course,
      'semester': semester,
      'class_shift': classShift,
      'internship_shift': internshipShift,
      'supervisor_id': supervisorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      userId: userId,
      registration: registration,
      course: course,
      semester: semester,
      classShift: ClassShift.fromString(classShift),
      internshipShift: InternshipShift.fromString(internshipShift),
      supervisorId: supervisorId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      userId: entity.userId,
      registration: entity.registration,
      course: entity.course,
      semester: entity.semester,
      classShift: entity.classShift.value,
      internshipShift: entity.internshipShift.value,
      supervisorId: entity.supervisorId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  StudentModel copyWith({
    String? id,
    String? userId,
    String? registration,
    String? course,
    int? semester,
    String? classShift,
    String? internshipShift,
    String? supervisorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      registration: registration ?? this.registration,
      course: course ?? this.course,
      semester: semester ?? this.semester,
      classShift: classShift ?? this.classShift,
      internshipShift: internshipShift ?? this.internshipShift,
      supervisorId: supervisorId ?? this.supervisorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentModel &&
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
    return 'StudentModel(id: $id, userId: $userId, registration: $registration, course: $course, semester: $semester, classShift: $classShift, internshipShift: $internshipShift, supervisorId: $supervisorId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

