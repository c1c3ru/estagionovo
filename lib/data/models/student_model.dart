// lib/data/models/student_model.dart
import 'package:equatable/equatable.dart';
import 'dart:math';

import 'package:estagio/core/enum/class_shift.dart';
import 'package:estagio/core/enum/internship_shift.dart'; // Para min e max nos getters calculados

class StudentModel extends Equatable {
  final String id; // UUID PRIMARY KEY REFERENCES users(id)
  final String fullName; // VARCHAR NOT NULL
  final String registrationNumber; // VARCHAR NOT NULL UNIQUE
  final String course; // VARCHAR NOT NULL
  final String advisorName; // VARCHAR NOT NULL
  final bool isMandatoryInternship; // BOOLEAN NOT NULL
  final ClassShift classShift; // VARCHAR NOT NULL CHECK
  final InternshipShift internshipShift1; // VARCHAR NOT NULL CHECK
  final InternshipShift? internshipShift2; // VARCHAR CHECK (opcional)
  final DateTime birthDate; // DATE NOT NULL
  final DateTime contractStartDate; // DATE NOT NULL
  final DateTime contractEndDate; // DATE NOT NULL
  final double totalHoursRequired; // NUMERIC(6, 2) DEFAULT 0.00
  final double totalHoursCompleted; // NUMERIC(6, 2) DEFAULT 0.00
  final double weeklyHoursTarget; // NUMERIC(4,2) DEFAULT 0.00
  final String? profilePictureUrl; // TEXT
  final String? phoneNumber; // VARCHAR(20)
  final DateTime createdAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  final DateTime? updatedAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()

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
    this.totalHoursRequired = 0.0,
    this.totalHoursCompleted = 0.0,
    this.weeklyHoursTarget = 0.0,
    this.profilePictureUrl,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
  });

  // Getters Calculados (semelhantes aos que discutimos anteriormente)
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
    // Uma lógica simplificada para isOnTrack. Pode ser mais complexa.
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
  ];

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      registrationNumber: json['registration_number'] as String,
      course: json['course'] as String,
      advisorName: json['advisor_name'] as String,
      isMandatoryInternship: json['is_mandatory_internship'] as bool? ?? false,
      classShift: ClassShift.fromString(json['class_shift'] as String?),
      internshipShift1: InternshipShift.fromString(
        json['internship_shift_1'] as String?,
      ),
      internshipShift2: json['internship_shift_2'] != null
          ? InternshipShift.fromString(json['internship_shift_2'] as String?)
          : null,
      birthDate: DateTime.parse(json['birth_date'] as String),
      contractStartDate: DateTime.parse(json['contract_start_date'] as String),
      contractEndDate: DateTime.parse(json['contract_end_date'] as String),
      totalHoursRequired:
          (json['total_hours_required'] as num?)?.toDouble() ?? 0.0,
      totalHoursCompleted:
          (json['total_hours_completed'] as num?)?.toDouble() ?? 0.0,
      weeklyHoursTarget:
          (json['weekly_hours_target'] as num?)?.toDouble() ?? 0.0,
      profilePictureUrl: json['profile_picture_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
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
      'class_shift': classShift.value,
      'internship_shift_1': internshipShift1.value,
      'internship_shift_2': internshipShift2?.value,
      'birth_date': birthDate.toIso8601String().substring(
        0,
        10,
      ), // Formato YYYY-MM-DD para DATE
      'contract_start_date': contractStartDate.toIso8601String().substring(
        0,
        10,
      ),
      'contract_end_date': contractEndDate.toIso8601String().substring(0, 10),
      'total_hours_required': totalHoursRequired,
      'total_hours_completed': totalHoursCompleted,
      'weekly_hours_target': weeklyHoursTarget,
      'profile_picture_url': profilePictureUrl,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StudentModel copyWith({
    String? id,
    String? fullName,
    String? registrationNumber,
    String? course,
    String? advisorName,
    bool? isMandatoryInternship,
    ClassShift? classShift,
    InternshipShift? internshipShift1,
    InternshipShift? internshipShift2,
    bool? clearInternshipShift2, // Para permitir definir como null
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
    );
  }
}
