import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Enum representing the status of a time log entry.
enum TimeLogStatus { pending, approved, rejected }

// Represents a time log entry, inheriting from Equatable for value comparison.
class TimeLogEntity extends Equatable {
  final String id;
  final String studentId;
  final DateTime logDate;
  final TimeOfDay checkInTime;
  final TimeOfDay? checkOutTime;

  // Details
  final String? description;
  final double? hoursLogged;
  final bool approved;
  final DateTime? approvedAt;
  final String? supervisorId;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TimeLogEntity({
    required this.id,
    required this.studentId,
    required this.logDate,
    required this.checkInTime,
    this.checkOutTime,
    this.description,
    this.hoursLogged,
    this.approved = false,
    this.approvedAt,
    this.supervisorId,
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
        description,
        hoursLogged,
        approved,
        approvedAt,
        supervisorId,
        createdAt,
        updatedAt,
      ];

  // copyWith method to create a new instance with updated fields.
  TimeLogEntity copyWith({
    String? id,
    String? studentId,
    DateTime? logDate,
    TimeOfDay? checkInTime,
    TimeOfDay? checkOutTime,
    String? description,
    double? hoursLogged,
    bool? approved,
    DateTime? approvedAt,
    String? supervisorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeLogEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      logDate: logDate ?? this.logDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      description: description ?? this.description,
      hoursLogged: hoursLogged ?? this.hoursLogged,
      approved: approved ?? this.approved,
      approvedAt: approvedAt ?? this.approvedAt,
      supervisorId: supervisorId ?? this.supervisorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
