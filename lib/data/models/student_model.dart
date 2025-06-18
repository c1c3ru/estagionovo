import 'package:student_supervisor_app/core/errors/app_exceptions.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/student_entity.dart';
import '../../core/enums/class_shift.dart';
import '../../core/enums/internship_shift.dart';
import '../../core/enums/user_role.dart';
import '../../core/enums/student_status.dart' as student_status;

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.email,
    required super.course,
    required super.advisorName,
    required super.isMandatoryInternship,
    required super.classShift,
    required super.internshipShift,
    required super.supervisorId,
    required super.totalHoursCompleted,
    required super.totalHoursRequired,
    required super.weeklyHoursTarget,
    required super.contractStartDate,
    required super.contractEndDate,
    required super.isOnTrack,
    required super.createdAt,
    required super.role,
    super.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      course: json['course'] as String,
      advisorName: json['advisor_name'] as String,
      isMandatoryInternship: json['is_mandatory_internship'] as bool,
      classShift: ClassShift.values.firstWhere(
        (e) => e.name == json['class_shift'],
        orElse: () => ClassShift.morning,
      ),
      internshipShift: InternshipShift.values.firstWhere(
        (e) => e.name == json['internship_shift'],
        orElse: () => InternshipShift.morning,
      ),
      supervisorId: json['supervisor_id'] as String,
      totalHoursCompleted: (json['total_hours_completed'] as num).toDouble(),
      totalHoursRequired: (json['total_hours_required'] as num).toDouble(),
      weeklyHoursTarget: (json['weekly_hours_target'] as num).toDouble(),
      contractStartDate: DateTime.parse(json['contract_start_date'] as String),
      contractEndDate: DateTime.parse(json['contract_end_date'] as String),
      isOnTrack: json['is_on_track'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.student,
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'course': course,
      'advisor_name': advisorName,
      'is_mandatory_internship': isMandatoryInternship,
      'class_shift': classShift.name,
      'internship_shift': internshipShift.name,
      'supervisor_id': supervisorId,
      'total_hours_completed': totalHoursCompleted,
      'total_hours_required': totalHoursRequired,
      'weekly_hours_target': weeklyHoursTarget,
      'contract_start_date': contractStartDate.toIso8601String(),
      'contract_end_date': contractEndDate.toIso8601String(),
      'is_on_track': isOnTrack,
      'created_at': createdAt.toIso8601String(),
      'role': role.name,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  StudentModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? course,
    String? advisorName,
    bool? isMandatoryInternship,
    ClassShift? classShift,
    InternshipShift? internshipShift,
    String? supervisorId,
    double? totalHoursCompleted,
    double? totalHoursRequired,
    double? weeklyHoursTarget,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    bool? isOnTrack,
    DateTime? createdAt,
    UserRole? role,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      course: course ?? this.course,
      advisorName: advisorName ?? this.advisorName,
      isMandatoryInternship:
          isMandatoryInternship ?? this.isMandatoryInternship,
      classShift: classShift ?? this.classShift,
      internshipShift: internshipShift ?? this.internshipShift,
      supervisorId: supervisorId ?? this.supervisorId,
      totalHoursCompleted: totalHoursCompleted ?? this.totalHoursCompleted,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      weeklyHoursTarget: weeklyHoursTarget ?? this.weeklyHoursTarget,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      isOnTrack: isOnTrack ?? this.isOnTrack,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      userId: userId,
      fullName: fullName,
      email: email,
      course: course,
      advisorName: advisorName,
      isMandatoryInternship: isMandatoryInternship,
      classShift: classShift,
      internshipShift: internshipShift,
      supervisorId: supervisorId,
      totalHoursCompleted: totalHoursCompleted,
      totalHoursRequired: totalHoursRequired,
      weeklyHoursTarget: weeklyHoursTarget,
      contractStartDate: contractStartDate,
      contractEndDate: contractEndDate,
      isOnTrack: isOnTrack,
      createdAt: createdAt,
      role: role,
      updatedAt: updatedAt,
    );
  }

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      course: entity.course,
      advisorName: entity.advisorName,
      isMandatoryInternship: entity.isMandatoryInternship,
      classShift: entity.classShift,
      internshipShift: entity.internshipShift,
      supervisorId: entity.supervisorId,
      totalHoursCompleted: entity.totalHoursCompleted,
      totalHoursRequired: entity.totalHoursRequired,
      weeklyHoursTarget: entity.weeklyHoursTarget,
      contractStartDate: entity.contractStartDate,
      contractEndDate: entity.contractEndDate,
      isOnTrack: entity.isOnTrack,
      createdAt: entity.createdAt,
      role: entity.role,
      updatedAt: entity.updatedAt,
    );
  }
}

class FilterStudentsParams extends Equatable {
  final String? searchTerm;
  final student_status.StudentStatus? status;
  final bool? hasActiveContract;
  final DateTime? contractStartDateFrom;
  final DateTime? contractStartDateTo;
  final DateTime? contractEndDateFrom;
  final DateTime? contractEndDateTo;

  const FilterStudentsParams({
    this.searchTerm,
    this.status,
    this.hasActiveContract,
    this.contractStartDateFrom,
    this.contractStartDateTo,
    this.contractEndDateFrom,
    this.contractEndDateTo,
  });

  @override
  List<Object?> get props => [
        searchTerm,
        status,
        hasActiveContract,
        contractStartDateFrom,
        contractStartDateTo,
        contractEndDateFrom,
        contractEndDateTo,
      ];

  FilterStudentsParams copyWith({
    String? searchTerm,
    student_status.StudentStatus? status,
    bool? hasActiveContract,
    DateTime? contractStartDateFrom,
    DateTime? contractStartDateTo,
    DateTime? contractEndDateFrom,
    DateTime? contractEndDateTo,
  }) {
    return FilterStudentsParams(
      searchTerm: searchTerm ?? this.searchTerm,
      status: status ?? this.status,
      hasActiveContract: hasActiveContract ?? this.hasActiveContract,
      contractStartDateFrom:
          contractStartDateFrom ?? this.contractStartDateFrom,
      contractStartDateTo: contractStartDateTo ?? this.contractStartDateTo,
      contractEndDateFrom: contractEndDateFrom ?? this.contractEndDateFrom,
      contractEndDateTo: contractEndDateTo ?? this.contractEndDateTo,
    );
  }
}
