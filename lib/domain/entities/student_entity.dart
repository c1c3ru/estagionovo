
import 'package:equatable/equatable.dart';
import '../../core/enum/class_shift.dart';
import '../../core/enum/internship_shift.dart';
import 'user_entity.dart';

enum StudentStatus {
  active,
  inactive,
  suspended,
  graduated,
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
    }
  }
}

class StudentEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String? course;
  final String? institution;
  final ClassShift? classShift;
  final InternshipShift? internshipShift;
  final String? supervisorId;
  final StudentStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? phoneNumber;
  final String? address;
  final String? emergencyContact;
  final String? emergencyContactPhone;
  final DateTime? lastCheckIn;
  final DateTime? lastCheckOut;
  final bool isOnline;

  const StudentEntity({
    required this.id,
    required this.user,
    this.course,
    this.institution,
    this.classShift,
    this.internshipShift,
    this.supervisorId,
    this.status = StudentStatus.active,
    this.startDate,
    this.endDate,
    this.phoneNumber,
    this.address,
    this.emergencyContact,
    this.emergencyContactPhone,
    this.lastCheckIn,
    this.lastCheckOut,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        course,
        institution,
        classShift,
        internshipShift,
        supervisorId,
        status,
        startDate,
        endDate,
        phoneNumber,
        address,
        emergencyContact,
        emergencyContactPhone,
        lastCheckIn,
        lastCheckOut,
        isOnline,
      ];

  StudentEntity copyWith({
    String? id,
    UserEntity? user,
    String? course,
    String? institution,
    ClassShift? classShift,
    InternshipShift? internshipShift,
    String? supervisorId,
    StudentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? phoneNumber,
    String? address,
    String? emergencyContact,
    String? emergencyContactPhone,
    DateTime? lastCheckIn,
    DateTime? lastCheckOut,
    bool? isOnline,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      course: course ?? this.course,
      institution: institution ?? this.institution,
      classShift: classShift ?? this.classShift,
      internshipShift: internshipShift ?? this.internshipShift,
      supervisorId: supervisorId ?? this.supervisorId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      lastCheckOut: lastCheckOut ?? this.lastCheckOut,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
