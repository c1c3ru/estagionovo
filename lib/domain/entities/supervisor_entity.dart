class SupervisorEntity {
  final String id;
  final String userId;
  final String department;
  final String position;
  final String specialization;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupervisorEntity({
    required this.id,
    required this.userId,
    required this.department,
    required this.position,
    required this.specialization,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupervisorEntity &&
        other.id == id &&
        other.userId == userId &&
        other.department == department &&
        other.position == position &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        department.hashCode ^
        position.hashCode ^
        phone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'SupervisorEntity(id: $id, userId: $userId, department: $department, position: $position, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

