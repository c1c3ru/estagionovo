// lib/domain/entities/student_entity.dart
import 'package:equatable/equatable.dart';
import 'dart:math';

import 'package:estagio/core/enum/class_shift.dart';
import 'package:estagio/core/enum/internship_shift.dart';
import 'package:estagio/core/enum/user_role.dart'; // Para min e max nos getters calculados
// Importa os enums da camada de dados.

class StudentEntity extends Equatable {
  final String id;
  final String fullName;
  final String registrationNumber;
  final String course;
  final String advisorName;
  final bool isMandatoryInternship;
  final ClassShift classShift;
  final InternshipShift internshipShift1;
  final InternshipShift? internshipShift2;
  final DateTime birthDate;
  final DateTime contractStartDate;
  final DateTime contractEndDate;
  final double totalHoursRequired;
  final double totalHoursCompleted;
  final double weeklyHoursTarget;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // Adicionando o UserRole aqui, pois um estudante é um tipo de usuário
  final UserRole role;

  const StudentEntity({
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
    this.role = UserRole.student, // Define o papel padrão como estudante
  });

  // Getters Calculados
  double get progressPercentage {
    if (totalHoursRequired <= 0) return 0.0;
    final percentage = (totalHoursCompleted / totalHoursRequired) * 100;
    return min(max(percentage, 0.0), 100.0);
  }

  double get remainingHours {
    final remaining = totalHoursRequired - totalHoursCompleted;
    return max(remaining, 0.0);
  }

  bool get isOnTrack {
    if (totalHoursRequired <= 0 || contractStartDate.isAfter(DateTime.now()))
      return true;
    if (contractEndDate.isBefore(DateTime.now()))
      return totalHoursCompleted >= totalHoursRequired;

    final totalDays = contractEndDate.difference(contractStartDate).inDays;
    if (totalDays <= 0) return true;

    final daysElapsed = DateTime.now().difference(contractStartDate).inDays;
    final effectiveDaysElapsed = min(max(daysElapsed, 0), totalDays);
    final expectedProgress =
        (effectiveDaysElapsed / totalDays) * totalHoursRequired;
    return totalHoursCompleted >= expectedProgress;
  }

  int get daysRemainingInContract {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final end = DateTime(
      contractEndDate.year,
      contractEndDate.month,
      contractEndDate.day,
    );
    if (end.isBefore(now)) return 0;
    return end.difference(now).inDays;
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    registrationNumber,
    course,
    advisorName,
    isMandatoryInternship,
    classShift,
    internshipShift1,
    internshipShift2,
    birthDate,
    contractStartDate,
    contractEndDate,
    totalHoursRequired,
    totalHoursCompleted,
    weeklyHoursTarget,
    profilePictureUrl,
    phoneNumber,
    createdAt,
    updatedAt,
    role,
  ];

  StudentEntity copyWith({
    String? id,
    String? fullName,
    String? registrationNumber,
    String? course,
    String? advisorName,
    bool? isMandatoryInternship,
    ClassShift? classShift,
    InternshipShift? internshipShift1,
    InternshipShift? internshipShift2,
    bool? clearInternshipShift2,
    DateTime? birthDate,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    double? totalHoursRequired,
    double? totalHoursCompleted,
    double? weeklyHoursTarget,
    String? profilePictureUrl,
    bool? clearProfilePictureUrl,
    String? phoneNumber,
    bool? clearPhoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? clearUpdatedAt,
    UserRole? role,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      course: course ?? this.course,
      advisorName: advisorName ?? this.advisorName,
      isMandatoryInternship:
          isMandatoryInternship ?? this.isMandatoryInternship,
      classShift: classShift ?? this.classShift,
      internshipShift1: internshipShift1 ?? this.internshipShift1,
      internshipShift2: clearInternshipShift2 == true
          ? null
          : internshipShift2 ?? this.internshipShift2,
      birthDate: birthDate ?? this.birthDate,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      totalHoursCompleted: totalHoursCompleted ?? this.totalHoursCompleted,
      weeklyHoursTarget: weeklyHoursTarget ?? this.weeklyHoursTarget,
      profilePictureUrl: clearProfilePictureUrl == true
          ? null
          : profilePictureUrl ?? this.profilePictureUrl,
      phoneNumber: clearPhoneNumber == true
          ? null
          : phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }
}
