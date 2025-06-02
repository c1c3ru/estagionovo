// lib/core/enums/class_shift.dart
enum ClassShift {
  morning,
  afternoon,
  evening,
  fullTime, // Tempo integral
  ead, // Ensino a Distância
  unknown;

  static ClassShift fromString(String? shiftString) {
    switch (shiftString?.toLowerCase()) {
      case 'morning':
        return ClassShift.morning;
      case 'afternoon':
        return ClassShift.afternoon;
      case 'evening':
        return ClassShift.evening;
      case 'full_time':
        return ClassShift.fullTime;
      case 'ead':
        return ClassShift.ead;
      default:
        return ClassShift.unknown;
    }
  }

  String get value {
    switch (this) {
      case ClassShift.morning:
        return 'morning';
      case ClassShift.afternoon:
        return 'afternoon';
      case ClassShift.evening:
        return 'evening';
      case ClassShift.fullTime:
        return 'full_time';
      case ClassShift.ead:
        return 'ead';
      default:
        return 'unknown';
    }
  }

  String get displayName {
    switch (this) {
      case ClassShift.morning:
        return 'Manhã';
      case ClassShift.afternoon:
        return 'Tarde';
      case ClassShift.evening:
        return 'Noite';
      case ClassShift.fullTime:
        return 'Tempo Integral';
      case ClassShift.ead:
        return 'EAD';
      default:
        return 'Desconhecido';
    }
  }
}
