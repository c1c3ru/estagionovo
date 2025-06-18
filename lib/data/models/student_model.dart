import 'package:student_supervisor_app/core/errors/app_exceptions.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/student_entity.dart';
import '../../core/enums/class_shift.dart';
import '../../core/enums/internship_shift.dart';
import '../../core/enums/user_role.dart';

class StudentModel {
  final String id;
  final String fullName;
  final String registrationNumber;
  final String course;
  final String advisorName;
  final bool isMandatoryInternship;
  final String classShift;
  final String internshipShift1;
  final String? internshipShift2;
  final String birthDate;
  final String contractStartDate;
  final String contractEndDate;
  final double totalHoursRequired;
  final double totalHoursCompleted;
  final double weeklyHoursTarget;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String createdAt;
  final String? updatedAt;
  final String role;

  const StudentModel({
    required this.id,
    required this.fullName,
    required this.registrationNumber,
    required this.course,
    required this.advisorName,
    required this.isMandatoryInternship,
    required this.classShift,
    required this.internshipShift1,
    this.internshipShift2,
    required this.birthDate,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.totalHoursRequired,
    required this.totalHoursCompleted,
    required this.weeklyHoursTarget,
    this.profilePictureUrl,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
    required this.role,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      registrationNumber: json['registration_number'] as String,
      course: json['course'] as String,
      advisorName: json['advisor_name'] as String,
      isMandatoryInternship: json['is_mandatory_internship'] as bool,
      classShift: json['class_shift'] as String,
      internshipShift1: json['internship_shift1'] as String,
      internshipShift2: json['internship_shift2'] as String?,
      birthDate: json['birth_date'] as String,
      contractStartDate: json['contract_start_date'] as String,
      contractEndDate: json['contract_end_date'] as String,
      totalHoursRequired: (json['total_hours_required'] as num).toDouble(),
      totalHoursCompleted: (json['total_hours_completed'] as num).toDouble(),
      weeklyHoursTarget: (json['weekly_hours_target'] as num).toDouble(),
      profilePictureUrl: json['profile_picture_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'registration_number': registrationNumber,
      'course': course,
      'advisor_name': advisorName,
      'is_mandatory_internship': isMandatoryInternship,
      'class_shift': classShift,
      'internship_shift1': internshipShift1,
      'internship_shift2': internshipShift2,
      'birth_date': birthDate,
      'contract_start_date': contractStartDate,
      'contract_end_date': contractEndDate,
      'total_hours_required': totalHoursRequired,
      'total_hours_completed': totalHoursCompleted,
      'weekly_hours_target': weeklyHoursTarget,
      'profile_picture_url': profilePictureUrl,
      'phone_number': phoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'role': role,
    };
  }

  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      fullName: fullName,
      registrationNumber: registrationNumber,
      course: course,
      advisorName: advisorName,
      isMandatoryInternship: isMandatoryInternship,
      classShift: ClassShift.fromString(classShift),
      internshipShift1: InternshipShift.fromString(internshipShift1),
      internshipShift2: internshipShift2 != null
          ? InternshipShift.fromString(internshipShift2!)
          : null,
      birthDate: DateTime.parse(birthDate),
      contractStartDate: DateTime.parse(contractStartDate),
      contractEndDate: DateTime.parse(contractEndDate),
      totalHoursRequired: totalHoursRequired,
      totalHoursCompleted: totalHoursCompleted,
      weeklyHoursTarget: weeklyHoursTarget,
      profilePictureUrl: profilePictureUrl,
      phoneNumber: phoneNumber,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      role: UserRole.fromString(role),
    );
  }

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      fullName: entity.fullName,
      registrationNumber: entity.registrationNumber,
      course: entity.course,
      advisorName: entity.advisorName,
      isMandatoryInternship: entity.isMandatoryInternship,
      classShift: entity.classShift.value,
      internshipShift1: entity.internshipShift1.value,
      internshipShift2: entity.internshipShift2?.value,
      birthDate: entity.birthDate.toIso8601String(),
      contractStartDate: entity.contractStartDate.toIso8601String(),
      contractEndDate: entity.contractEndDate.toIso8601String(),
      totalHoursRequired: entity.totalHoursRequired,
      totalHoursCompleted: entity.totalHoursCompleted,
      weeklyHoursTarget: entity.weeklyHoursTarget,
      profilePictureUrl: entity.profilePictureUrl,
      phoneNumber: entity.phoneNumber,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      role: entity.role.value,
    );
  }

  StudentModel copyWith({
    String? id,
    String? fullName,
    String? registrationNumber,
    String? course,
    String? advisorName,
    bool? isMandatoryInternship,
    String? classShift,
    String? internshipShift1,
    String? internshipShift2,
    String? birthDate,
    String? contractStartDate,
    String? contractEndDate,
    double? totalHoursRequired,
    double? totalHoursCompleted,
    double? weeklyHoursTarget,
    String? profilePictureUrl,
    String? phoneNumber,
    String? createdAt,
    String? updatedAt,
    String? role,
  }) {
    return StudentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      course: course ?? this.course,
      advisorName: advisorName ?? this.advisorName,
      isMandatoryInternship:
          isMandatoryInternship ?? this.isMandatoryInternship,
      classShift: classShift ?? this.classShift,
      internshipShift1: internshipShift1 ?? this.internshipShift1,
      internshipShift2: internshipShift2 ?? this.internshipShift2,
      birthDate: birthDate ?? this.birthDate,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      totalHoursCompleted: totalHoursCompleted ?? this.totalHoursCompleted,
      weeklyHoursTarget: weeklyHoursTarget ?? this.weeklyHoursTarget,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.registrationNumber == registrationNumber &&
        other.course == course &&
        other.advisorName == advisorName &&
        other.isMandatoryInternship == isMandatoryInternship &&
        other.classShift == classShift &&
        other.internshipShift1 == internshipShift1 &&
        other.internshipShift2 == internshipShift2 &&
        other.birthDate == birthDate &&
        other.contractStartDate == contractStartDate &&
        other.contractEndDate == contractEndDate &&
        other.totalHoursRequired == totalHoursRequired &&
        other.totalHoursCompleted == totalHoursCompleted &&
        other.weeklyHoursTarget == weeklyHoursTarget &&
        other.profilePictureUrl == profilePictureUrl &&
        other.phoneNumber == phoneNumber &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        registrationNumber.hashCode ^
        course.hashCode ^
        advisorName.hashCode ^
        isMandatoryInternship.hashCode ^
        classShift.hashCode ^
        internshipShift1.hashCode ^
        internshipShift2.hashCode ^
        birthDate.hashCode ^
        contractStartDate.hashCode ^
        contractEndDate.hashCode ^
        totalHoursRequired.hashCode ^
        totalHoursCompleted.hashCode ^
        weeklyHoursTarget.hashCode ^
        profilePictureUrl.hashCode ^
        phoneNumber.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        role.hashCode;
  }

  @override
  String toString() {
    return 'StudentModel(id: $id, fullName: $fullName, registrationNumber: $registrationNumber, course: $course, advisorName: $advisorName, isMandatoryInternship: $isMandatoryInternship, classShift: $classShift, internshipShift1: $internshipShift1, internshipShift2: $internshipShift2, birthDate: $birthDate, contractStartDate: $contractStartDate, contractEndDate: $contractEndDate, totalHoursRequired: $totalHoursRequired, totalHoursCompleted: $totalHoursCompleted, weeklyHoursTarget: $weeklyHoursTarget, profilePictureUrl: $profilePictureUrl, phoneNumber: $phoneNumber, createdAt: $createdAt, updatedAt: $updatedAt, role: $role)';
  }
}

class FilterStudentsParams {
  final String? course;
  final String? classShift;
  final String? internshipShift;
  final String? supervisorId;
  final StudentStatus status;

  FilterStudentsParams({
    this.course,
    this.classShift,
    this.internshipShift,
    this.supervisorId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'course': course,
      'class_shift': classShift,
      'internship_shift': internshipShift,
      'supervisor_id': supervisorId,
      'status': status.name,
    };
  }

  factory FilterStudentsParams.fromJson(Map<String, dynamic> json) {
    return FilterStudentsParams(
      course: json['course'] as String?,
      classShift: json['class_shift'] as String?,
      internshipShift: json['internship_shift'] as String?,
      supervisorId: json['supervisor_id'] as String?,
      status: StudentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StudentStatus.unknown,
      ),
    );
  }

  @override
  String toString() {
    return 'FilterStudentsParams(course: $course, classShift: $classShift, internshipShift: $internshipShift, supervisorId: $supervisorId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final FilterStudentsParams otherParams = other as FilterStudentsParams;
    return otherParams.course == course &&
        otherParams.classShift == classShift &&
        otherParams.internshipShift == internshipShift &&
        otherParams.supervisorId == supervisorId &&
        otherParams.status == status;
  }

  @override
  int get hashCode {
    return course.hashCode ^
        classShift.hashCode ^
        internshipShift.hashCode ^
        supervisorId.hashCode ^
        status.hashCode;
  }

  FilterStudentsParams copyWith({
    String? course,
    String? classShift,
    String? internshipShift,
    String? supervisorId,
    StudentStatus? status,
  }) {
    return FilterStudentsParams(
      course: course ?? this.course,
      classShift: classShift ?? this.classShift,
      internshipShift: internshipShift ?? this.internshipShift,
      supervisorId: supervisorId ?? this.supervisorId,
      status: status ?? this.status,
    );
  }
}
