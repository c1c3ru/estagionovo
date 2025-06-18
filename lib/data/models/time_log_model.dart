import '../../domain/entities/time_log_entity.dart';

class TimeLogModel {
  final String id;
  final String studentId;
  final String supervisorId;
  final DateTime date;
  final double hours;
  final String description;
  final bool isApproved;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TimeLogModel({
    required this.id,
    required this.studentId,
    required this.supervisorId,
    required this.date,
    required this.hours,
    required this.description,
    required this.isApproved,
    this.rejectionReason,
    required this.createdAt,
    this.updatedAt,
  });

  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    return TimeLogModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      supervisorId: json['supervisor_id'] as String,
      date: DateTime.parse(json['date'] as String),
      hours: (json['hours'] as num).toDouble(),
      description: json['description'] as String,
      isApproved: json['is_approved'] as bool,
      rejectionReason: json['rejection_reason'] as String?,
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
      'supervisor_id': supervisorId,
      'date': date.toIso8601String(),
      'hours': hours,
      'description': description,
      'is_approved': isApproved,
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  TimeLogEntity toEntity() {
    return TimeLogEntity(
      id: id,
      studentId: studentId,
      supervisorId: supervisorId,
      date: date,
      hours: hours,
      description: description,
      isApproved: isApproved,
      rejectionReason: rejectionReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TimeLogModel.fromEntity(TimeLogEntity entity) {
    return TimeLogModel(
      id: entity.id,
      studentId: entity.studentId,
      supervisorId: entity.supervisorId,
      date: entity.date,
      hours: entity.hours,
      description: entity.description,
      isApproved: entity.isApproved,
      rejectionReason: entity.rejectionReason,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TimeLogModel copyWith({
    String? id,
    String? studentId,
    String? supervisorId,
    DateTime? date,
    double? hours,
    String? description,
    bool? isApproved,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeLogModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      supervisorId: supervisorId ?? this.supervisorId,
      date: date ?? this.date,
      hours: hours ?? this.hours,
      description: description ?? this.description,
      isApproved: isApproved ?? this.isApproved,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration? get totalHours {
    if (updatedAt == null) return null;
    return updatedAt!.difference(date);
  }

  bool get isActive => updatedAt == null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeLogModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.supervisorId == supervisorId &&
        other.date == date &&
        other.hours == hours &&
        other.description == description &&
        other.isApproved == isApproved &&
        other.rejectionReason == rejectionReason &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        supervisorId.hashCode ^
        date.hashCode ^
        hours.hashCode ^
        description.hashCode ^
        isApproved.hashCode ^
        rejectionReason.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'TimeLogModel(id: $id, studentId: $studentId, supervisorId: $supervisorId, date: $date, hours: $hours, description: $description, isApproved: $isApproved, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
