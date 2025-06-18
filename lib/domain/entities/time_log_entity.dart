import 'package:equatable/equatable.dart';

class TimeLogEntity extends Equatable {
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

  const TimeLogEntity({
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

  factory TimeLogEntity.fromJson(Map<String, dynamic> json) {
    return TimeLogEntity(
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

  @override
  List<Object?> get props => [
        id,
        studentId,
        supervisorId,
        date,
        hours,
        description,
        isApproved,
        rejectionReason,
        createdAt,
        updatedAt,
      ];

  TimeLogEntity copyWith({
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
    return TimeLogEntity(
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

  bool get isActive => updatedAt == null;

  Duration get calculatedHours {
    if (updatedAt == null) return Duration.zero;
    return updatedAt!.difference(date);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeLogEntity &&
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

  get checkOutTime => updatedAt;

  get logDate => date;

  get checkInTime => date;

  bool get approved => isApproved;

  get hoursLogged => hours;

  @override
  String toString() {
    return 'TimeLogEntity(id: $id, studentId: $studentId, supervisorId: $supervisorId, date: $date, hours: $hours, description: $description, isApproved: $isApproved, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
