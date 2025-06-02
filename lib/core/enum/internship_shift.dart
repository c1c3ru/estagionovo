// lib/core/enums/internship_shift.dart
enum InternshipShift {
  morning,
  afternoon,
  evening,
  unknown;

  static InternshipShift fromString(String? shiftString) {
    switch (shiftString?.toLowerCase()) {
      case 'morning':
        return InternshipShift.morning;
      case 'afternoon':
        return InternshipShift.afternoon;
      case 'evening':
        return InternshipShift.evening;
      default:
        return InternshipShift.unknown;
    }
  }

  String get value {
    switch (this) {
      case InternshipShift.morning:
        return 'morning';
      case InternshipShift.afternoon:
        return 'afternoon';
      case InternshipShift.evening:
        return 'evening';
      default:
        return 'unknown';
    }
  }

  String get displayName {
    switch (this) {
      case InternshipShift.morning:
        return 'Manhã';
      case InternshipShift.afternoon:
        return 'Tarde';
      case InternshipShift.evening:
        return 'Noite';
      default:
        return 'Desconhecido';
    }
  }
}
