import 'package:equatable/equatable.dart';
import 'package:estagio/core/enum/user_role.dart';
import '../../core/enum/class_shift.dart';
import '../../core/enum/internship_shift.dart';
import 'user_entity.dart';

// Enum for the student's status with an extension for display names.
enum StudentStatus {
  active,
  inactive,
  suspended,
  graduated,
  pending,
  completed,
  terminated,
  unknown,
}

extension StudentStatusExtension on StudentStatus {
  String get displayName {
    switch (this) {
      case StudentStatus.active:
        return 'Ativo';
      case StudentStatus.inactive:
        return 'Inativo';
      case StudentStatus.suspended:
        return 'Suspenso';
      case StudentStatus.graduated:
        return 'Formado';
      case StudentStatus.pending:
        return 'Pendente';
      case StudentStatus.completed:
        return 'Concluído';
      case StudentStatus.terminated:
        return 'Rescindido';
      case StudentStatus.unknown:
        return 'Desconhecido';
    }
  }
}

// Represents a student, inheriting from Equatable for value comparison.
class StudentEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String fullName;
  final String registrationNumber;
  final String? profilePictureUrl;
  final UserRole role;

  // Course and Institution Info
  final String? course;
  final String? institution;
  final String? advisorName;

  // Personal Info
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? address;
  final String? emergencyContact;
  final String? emergencyContactPhone;

  // Internship Details
  final bool isMandatoryInternship;
  final ClassShift? classShift;
  final InternshipShift? internshipShift;
  final String? supervisorId;
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;

  // Academic/Hour Details
  final StudentStatus status;
  final double? totalHoursRequired;
  final double? totalHoursCompleted;
  final double? weeklyHoursTarget;

  // Tracking Timestamps
  final DateTime? lastCheckIn;
  final DateTime? lastCheckOut;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const StudentEntity({
    required this.id,
    required this.user,
    required this.fullName,
    required this.registrationNumber,
    this.profilePictureUrl,
    this.role = UserRole.student,
    this.course,
    this.institution,
    this.advisorName,
    this.birthDate,
    this.phoneNumber,
    this.address,
    this.emergencyContact,
    this.emergencyContactPhone,
    this.isMandatoryInternship = false,
    this.classShift,
    this.internshipShift,
    this.supervisorId,
    this.contractStartDate,
    this.contractEndDate,
    this.status = StudentStatus.active,
    this.totalHoursRequired,
    this.totalHoursCompleted,
    this.weeklyHoursTarget,
    this.lastCheckIn,
    this.lastCheckOut,
    this.isOnline = false,
    required this.createdAt,
    this.updatedAt,
    required InternshipShift internshipShift1,
    InternshipShift? internshipShift2,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        fullName,
        registrationNumber,
        profilePictureUrl,
        role,
        course,
        institution,
        advisorName,
        birthDate,
        phoneNumber,
        address,
        emergencyContact,
        emergencyContactPhone,
        isMandatoryInternship,
        classShift,
        internshipShift,
        supervisorId,
        contractStartDate,
        contractEndDate,
        status,
        totalHoursRequired,
        totalHoursCompleted,
        weeklyHoursTarget,
        lastCheckIn,
        lastCheckOut,
        isOnline,
        createdAt,
        updatedAt,
      ];

  // copyWith method to create a new instance with updated fields.
  StudentEntity copyWith({
    String? id,
    UserEntity? user,
    String? fullName,
    String? registrationNumber,
    String? profilePictureUrl,
    UserRole? role,
    String? course,
    String? institution,
    String? advisorName,
    DateTime? birthDate,
    String? phoneNumber,
    String? address,
    String? emergencyContact,
    String? emergencyContactPhone,
    bool? isMandatoryInternship,
    ClassShift? classShift,
    InternshipShift? internshipShift,
    String? supervisorId,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    StudentStatus? status,
    double? totalHoursRequired,
    double? totalHoursCompleted,
    double? weeklyHoursTarget,
    DateTime? lastCheckIn,
    DateTime? lastCheckOut,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      fullName: fullName ?? this.fullName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      role: role ?? this.role,
      course: course ?? this.course,
      institution: institution ?? this.institution,
      advisorName: advisorName ?? this.advisorName,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      isMandatoryInternship:
          isMandatoryInternship ?? this.isMandatoryInternship,
      classShift: classShift ?? this.classShift,
      internshipShift: internshipShift ?? this.internshipShift,
      supervisorId: supervisorId ?? this.supervisorId,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      status: status ?? this.status,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      totalHoursCompleted: totalHoursCompleted ?? this.totalHoursCompleted,
      weeklyHoursTarget: weeklyHoursTarget ?? this.weeklyHoursTarget,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      lastCheckOut: lastCheckOut ?? this.lastCheckOut,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      internshipShift1: internshipShift ?? this.internshipShift!,
    );
  }
}
