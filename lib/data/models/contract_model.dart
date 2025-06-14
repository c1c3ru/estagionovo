import '../../domain/entities/contract_entity.dart';
import '../../core/enums/contract_status.dart';

class ContractModel {
  final String id;
  final String studentId;
  final String supervisorId;
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime endDate;
  final int weeklyHours;
  final double? salary;
  final String status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContractModel({
    required this.id,
    required this.studentId,
    required this.supervisorId,
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.weeklyHours,
    this.salary,
    required this.status,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      supervisorId: json['supervisor_id'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      weeklyHours: json['weekly_hours'] as int,
      salary: json['salary'] != null ? (json['salary'] as num).toDouble() : null,
      status: json['status'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'supervisor_id': supervisorId,
      'company': company,
      'position': position,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'weekly_hours': weeklyHours,
      'salary': salary,
      'status': status,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ContractEntity toEntity() {
    return ContractEntity(
      id: id,
      studentId: studentId,
      supervisorId: supervisorId,
      company: company,
      position: position,
      startDate: startDate,
      endDate: endDate,
      weeklyHours: weeklyHours,
      salary: salary,
      status: ContractStatus.fromString(status),
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ContractModel.fromEntity(ContractEntity entity) {
    return ContractModel(
      id: entity.id,
      studentId: entity.studentId,
      supervisorId: entity.supervisorId,
      company: entity.company,
      position: entity.position,
      startDate: entity.startDate,
      endDate: entity.endDate,
      weeklyHours: entity.weeklyHours,
      salary: entity.salary,
      status: entity.status.value,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ContractModel copyWith({
    String? id,
    String? studentId,
    String? supervisorId,
    String? company,
    String? position,
    DateTime? startDate,
    DateTime? endDate,
    int? weeklyHours,
    double? salary,
    String? status,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContractModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      supervisorId: supervisorId ?? this.supervisorId,
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      salary: salary ?? this.salary,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == ContractStatus.active.value;
  bool get isExpired => DateTime.now().isAfter(endDate);
  Duration get duration => endDate.difference(startDate);
  Duration get remainingTime => endDate.difference(DateTime.now());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContractModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.supervisorId == supervisorId &&
        other.company == company &&
        other.position == position &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.weeklyHours == weeklyHours &&
        other.salary == salary &&
        other.status == status &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        supervisorId.hashCode ^
        company.hashCode ^
        position.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        weeklyHours.hashCode ^
        salary.hashCode ^
        status.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'ContractModel(id: $id, studentId: $studentId, supervisorId: $supervisorId, company: $company, position: $position, startDate: $startDate, endDate: $endDate, weeklyHours: $weeklyHours, salary: $salary, status: $status, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

