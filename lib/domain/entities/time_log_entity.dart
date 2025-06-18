class TimeLogEntity {
  final String id;
  final String studentId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final String? description;
  final Duration? totalHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimeLogEntity({
    required this.id,
    required this.studentId,
    required this.clockIn,
    this.clockOut,
    this.description,
    this.totalHours,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => clockOut == null;

  Duration get calculatedHours {
    if (clockOut == null) return Duration.zero;
    return clockOut!.difference(clockIn);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeLogEntity &&
        other.id == id &&
        other.studentId == studentId &&
        other.clockIn == clockIn &&
        other.clockOut == clockOut &&
        other.description == description &&
        other.totalHours == totalHours &&
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
        totalHours.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  get checkOutTime => null;

  get logDate => null;

  get checkInTime => null;

  bool get approved => false;

  get hoursLogged => null;

  @override
  String toString() {
    return 'TimeLogEntity(id: $id, studentId: $studentId, clockIn: $clockIn, clockOut: $clockOut, description: $description, totalHours: $totalHours, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
