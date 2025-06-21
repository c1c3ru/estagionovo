import 'package:equatable/equatable.dart';
import 'dart:math';

import 'package:gestao_de_estagio/core/enums/class_shift.dart';
import 'package:gestao_de_estagio/core/enums/internship_shift.dart';
import 'package:gestao_de_estagio/core/enums/user_role.dart';
import 'package:gestao_de_estagio/core/enums/student_status.dart';

class StudentEntity extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final DateTime? birthDate;
  final String course;
  final String advisorName;
  final String registrationNumber;
  final bool isMandatoryInternship;
  final ClassShift classShift;
  final InternshipShift internshipShift;
  final String supervisorId;
  final double totalHoursCompleted;
  final double totalHoursRequired;
  final double weeklyHoursTarget;
  final DateTime contractStartDate;
  final DateTime contractEndDate;
  final bool isOnTrack;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserRole role;

  const StudentEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.birthDate,
    required this.course,
    required this.advisorName,
    required this.registrationNumber,
    required this.isMandatoryInternship,
    required this.classShift,
    required this.internshipShift,
    required this.supervisorId,
    required this.totalHoursCompleted,
    required this.totalHoursRequired,
    required this.weeklyHoursTarget,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.isOnTrack,
    required this.createdAt,
    this.updatedAt,
    this.role = UserRole.student,
  });

  double get progressPercentage {
    if (totalHoursRequired <= 0) return 0.0;
    final percentage = (totalHoursCompleted / totalHoursRequired) * 100;
    return min(max(percentage, 0.0), 100.0);
  }

  double get remainingHours {
    final remaining = totalHoursRequired - totalHoursCompleted;
    return max(remaining, 0.0);
  }

  int get daysRemainingInContract {
    final now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final end = DateTime(
        contractEndDate.year, contractEndDate.month, contractEndDate.day);
    if (end.isBefore(now)) return 0;
    return end.difference(now).inDays;
  }

  StudentStatus get status {
    final now = DateTime.now();
    if (contractStartDate.isAfter(now)) {
      return StudentStatus.pending;
    }
    if (contractEndDate.isBefore(now)) {
      return totalHoursCompleted >= totalHoursRequired
          ? StudentStatus.completed
          : StudentStatus.terminated;
    }
    return isOnTrack ? StudentStatus.active : StudentStatus.inactive;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        email,
        phoneNumber,
        profilePictureUrl,
        birthDate,
        course,
        advisorName,
        registrationNumber,
        isMandatoryInternship,
        classShift,
        internshipShift,
        supervisorId,
        totalHoursCompleted,
        totalHoursRequired,
        weeklyHoursTarget,
        contractStartDate,
        contractEndDate,
        isOnTrack,
        createdAt,
        updatedAt,
        role,
      ];

  StudentEntity copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    DateTime? birthDate,
    String? course,
    String? advisorName,
    String? registrationNumber,
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
    DateTime? updatedAt,
    UserRole? role,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      birthDate: birthDate ?? this.birthDate,
      course: course ?? this.course,
      advisorName: advisorName ?? this.advisorName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
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
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentEntity &&
        other.id == id &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.profilePictureUrl == profilePictureUrl &&
        other.birthDate == birthDate &&
        other.course == course &&
        other.advisorName == advisorName &&
        other.registrationNumber == registrationNumber &&
        other.isMandatoryInternship == isMandatoryInternship &&
        other.classShift == classShift &&
        other.internshipShift == internshipShift &&
        other.supervisorId == supervisorId &&
        other.totalHoursCompleted == totalHoursCompleted &&
        other.totalHoursRequired == totalHoursRequired &&
        other.weeklyHoursTarget == weeklyHoursTarget &&
        other.contractStartDate == contractStartDate &&
        other.contractEndDate == contractEndDate &&
        other.isOnTrack == isOnTrack &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        profilePictureUrl.hashCode ^
        birthDate.hashCode ^
        course.hashCode ^
        advisorName.hashCode ^
        registrationNumber.hashCode ^
        isMandatoryInternship.hashCode ^
        classShift.hashCode ^
        internshipShift.hashCode ^
        supervisorId.hashCode ^
        totalHoursCompleted.hashCode ^
        totalHoursRequired.hashCode ^
        weeklyHoursTarget.hashCode ^
        contractStartDate.hashCode ^
        contractEndDate.hashCode ^
        isOnTrack.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        role.hashCode;
  }

  @override
  String toString() {
    return 'StudentEntity(id: $id, fullName: $fullName, email: $email, course: $course, advisorName: $advisorName, registrationNumber: $registrationNumber, isMandatoryInternship: $isMandatoryInternship, classShift: $classShift, internshipShift: $internshipShift, supervisorId: $supervisorId, totalHoursCompleted: $totalHoursCompleted, totalHoursRequired: $totalHoursRequired, weeklyHoursTarget: $weeklyHoursTarget, contractStartDate: $contractStartDate, contractEndDate: $contractEndDate, isOnTrack: $isOnTrack, createdAt: $createdAt, updatedAt: $updatedAt, role: $role)';
  }
}
