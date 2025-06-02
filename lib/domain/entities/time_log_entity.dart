
// lib/domain/entities/time_log_entity.dart
import 'package:equatable/equatable.dart';

enum TimeLogStatus { pending, approved, rejected }

class TimeLogEntity extends Equatable {
  final String id;
  final String studentId;
  final String? supervisorId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String? description;
  final String? location;
  final TimeLogStatus status;
  final String? supervisorNotes;
  final int? totalMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimeLogEntity({
    required this.id,
    required this.studentId,
    this.supervisorId,
    required this.checkInTime,
    this.checkOutTime,
    this.description,
    this.location,
    this.status = TimeLogStatus.pending,
    this.supervisorNotes,
    this.totalMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        supervisorId,
        checkInTime,
        checkOutTime,
        description,
        location,
        status,
        supervisorNotes,
        totalMinutes,
        createdAt,
        updatedAt,
      ];

  TimeLogEntity copyWith({
    String? id,
    String? studentId,
    String? supervisorId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? description,
    String? location,
    TimeLogStatus? status,
    String? supervisorNotes,
    int? totalMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeLogEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      supervisorId: supervisorId ?? this.supervisorId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      supervisorNotes: supervisorNotes ?? this.supervisorNotes,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
