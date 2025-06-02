// lib/core/enum/user_role.dart
enum UserRole {
  unknown,
  student,
  supervisor,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Estudante';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.admin:
        return 'Administrador';
      case UserRole.unknown:
        return 'Desconhecido';
    }
  }

  String get value {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.supervisor:
        return 'supervisor';
      case UserRole.admin:
        return 'admin';
      case UserRole.unknown:
        return 'unknown';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'supervisor':
        return UserRole.supervisor;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }
}
