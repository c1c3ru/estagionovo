// lib/data/models/time_log_model.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Para TimeOfDay

class TimeLogModel extends Equatable {
  final String id; // UUID PRIMARY KEY DEFAULT gen_random_uuid()
  final String studentId; // UUID NOT NULL REFERENCES students(id)
  final DateTime logDate; // DATE NOT NULL
  final TimeOfDay checkInTime; // TIME NOT NULL
  final TimeOfDay? checkOutTime; // TIME (opcional)
  final double? hoursLogged; // NUMERIC(4,2) (opcional)
  final String? description; // TEXT (opcional)
  final bool approved; // BOOLEAN DEFAULT FALSE
  final String? supervisorId; // UUID REFERENCES supervisors(id) (opcional)
  final DateTime? approvedAt; // TIMESTAMP WITH TIME ZONE (opcional)
  final DateTime createdAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  final DateTime? updatedAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()

  const TimeLogModel({
    required this.id,
    required this.studentId,
    required this.logDate,
    required this.checkInTime,
    this.checkOutTime,
    this.hoursLogged,
    this.description,
    this.approved = false,
    this.supervisorId,
    this.approvedAt,
    required this.createdAt,
    this.updatedAt,
  });

  // Helper para converter string 'HH:mm:ss' ou 'HH:mm' para TimeOfDay
  static TimeOfDay? _timeOfDayFromString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }
    return null;
  }

  // Helper para converter TimeOfDay para string 'HH:mm:ss'
  static String? _stringFromTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return null;
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // Adiciona segundos para consistência com o tipo TIME do DB
  }

  @override
  List<Object?> get props => [
        id,
        studentId,
        logDate,
        checkInTime,
        checkOutTime,
        hoursLogged,
        description,
        approved,
        supervisorId,
        approvedAt,
        createdAt,
        updatedAt,
      ];

  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    final checkIn = _timeOfDayFromString(json['check_in_time'] as String?);
    if (checkIn == null) {
      throw FormatException("check_in_time inválido ou ausente no JSON: ${json['check_in_time']}");
    }

    return TimeLogModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      logDate: DateTime.parse(json['log_date'] as String),
      checkInTime: checkIn,
      checkOutTime: _timeOfDayFromString(json['check_out_time'] as String?),
      hoursLogged: (json['hours_logged'] as num?)?.toDouble(),
      description: json['description'] as String?,
      approved: json['approved'] as bool? ?? false,
      supervisorId: json['supervisor_id'] as String?,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'log_date': logDate.toIso8601String().substring(0,10), // Formato YYYY-MM-DD para DATE
      'check_in_time': _stringFromTimeOfDay(checkInTime),
      'check_out_time': _stringFromTimeOfDay(checkOutTime),
      'hours_logged': hoursLogged,
      'description': description,
      'approved': approved,
      'supervisor_id': supervisorId,
      'approved_at': approvedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  TimeLogModel copyWith({
    String? id,
    String? studentId,
    DateTime? logDate,
    TimeOfDay? checkInTime,
    TimeOfDay? checkOutTime,
    bool? clearCheckOutTime,
    double? hoursLogged,
    bool? clearHoursLogged,
    String? description,
    bool? clearDescription,
    bool? approved,
    String? supervisorId,
    bool? clearSupervisorId,
    DateTime? approvedAt,
    bool? clearApprovedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? clearUpdatedAt,
  }) {
    return TimeLogModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      logDate: logDate ?? this.logDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: clearCheckOutTime == true ? null : checkOutTime ?? this.checkOutTime,
      hoursLogged: clearHoursLogged == true ? null : hoursLogged ?? this.hoursLogged,
      description: clearDescription == true ? null : description ?? this.description,
      approved: approved ?? this.approved,
      supervisorId: clearSupervisorId == true ? null : supervisorId ?? this.supervisorId,
      approvedAt: clearApprovedAt == true ? null : approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
    );
  }
}
