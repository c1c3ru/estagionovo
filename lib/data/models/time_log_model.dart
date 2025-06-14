import '../../domain/entities/time_log_entity.dart';

class TimeLogModel {
  final String id;
  final String studentId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeLogModel({
    required this.id,
    required this.studentId,
    required this.clockIn,
    this.clockOut,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    return TimeLogModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      clockIn: DateTime.parse(json['clock_in'] as String),
      clockOut: json['clock_out'] != null 
          ? DateTime.parse(json['clock_out'] as String) 
          : null,
      description: json["notes"] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'clock_in': clockIn.toIso8601String(),
      'clock_out': clockOut?.toIso8601String(),
      'notes': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TimeLogEntity toEntity() {
    return TimeLogEntity(
      id: id,
      studentId: studentId,
      clockIn: clockIn,
      clockOut: clockOut,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TimeLogModel.fromEntity(TimeLogEntity entity) {
    return TimeLogModel(
      id: entity.id,
      studentId: entity.studentId,
      clockIn: entity.clockIn,
      clockOut: entity.clockOut,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TimeLogModel copyWith({
    String? id,
    String? studentId,
    DateTime? clockIn,
    DateTime? clockOut,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeLogModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration? get totalHours {
    if (clockOut == null) return null;
    return clockOut!.difference(clockIn);
  }

  bool get isActive => clockOut == null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeLogModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.clockIn == clockIn &&
        other.clockOut == clockOut &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        clockIn.hashCode ^
        clockOut.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'TimeLogModel(id: $id, studentId: $studentId, clockIn: $clockIn, clockOut: $clockOut, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

