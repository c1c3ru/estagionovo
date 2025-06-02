// lib/domain/entities/time_log_entity.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Para TimeOfDay

class TimeLogEntity extends Equatable {
  final String id;
  final String studentId;
  final DateTime logDate;
  final TimeOfDay checkInTime;
  final TimeOfDay? checkOutTime;
  final double? hoursLogged;
  final String? description;
  final bool approved;
  final String? supervisorId;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TimeLogEntity({
    required this.id,
    required this.studentId,
    required this.logDate,
    required this.checkInTime,
    this.checkOutTime,
    this.hoursLogged,
    this.description,
    required this.approved,
    this.supervisorId,
    this.approvedAt,
    required this.createdAt,
    this.updatedAt,
  });

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

  TimeLogEntity copyWith({
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
    return TimeLogEntity(
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
