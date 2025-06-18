import '../../core/enums/contract_status.dart';

class ContractEntity {
  final String id;
  final String studentId;
  final String supervisorId;
  final DateTime startDate;
  final DateTime endDate;
  final int weeklyHours;
  final String company;
  final String position;
  final double? salary;
  final ContractStatus status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContractEntity({
    required this.id,
    required this.studentId,
    required this.supervisorId,
    required this.startDate,
    required this.endDate,
    required this.weeklyHours,
    required this.company,
    required this.position,
    this.salary,
    required this.status,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == ContractStatus.active;

  Duration get totalDuration => endDate.difference(startDate);

  int get totalExpectedHours {
    final weeks = totalDuration.inDays / 7;
    return (weeks * weeklyHours).round();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContractEntity &&
        other.id == id &&
        other.studentId == studentId &&
        other.supervisorId == supervisorId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.weeklyHours == weeklyHours &&
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
        startDate.hashCode ^
        endDate.hashCode ^
        weeklyHours.hashCode ^
        status.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  get contractType => null;

  get documentUrl => null;

  @override
  String toString() {
    return 'ContractEntity(id: $id, studentId: $studentId, supervisorId: $supervisorId, startDate: $startDate, endDate: $endDate, weeklyHours: $weeklyHours, status: $status, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
