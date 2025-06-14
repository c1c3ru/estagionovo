enum ClassShift {
  morning('morning', 'Manhã'),
  afternoon('afternoon', 'Tarde'),
  evening('evening', 'Noite'),
  fullTime('full_time', 'Integral');

  const ClassShift(this.value, this.displayName);

  final String value;
  final String displayName;

  static ClassShift fromString(String value) {
    return ClassShift.values.firstWhere(
      (shift) => shift.value == value,
      orElse: () => ClassShift.morning,
    );
  }

  @override
  String toString() => value;
}

