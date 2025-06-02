  // lib/core/enums/user_role.dart
enum UserRole {
  student,
  supervisor,
  admin,
  unknown;

  static UserRole fromString(String? roleString) {
    switch (roleString?.toLowerCase()) {
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

  String get value {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.supervisor:
        return 'supervisor';
      case UserRole.admin:
        return 'admin';
      default:
        return 'unknown';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Estudante';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.admin:
        return 'Administrador';
      default:
        return 'Desconhecido';
    }
  }

  /// Verifica se a role é válida (não é unknown).
  bool isValid() => this != UserRole.unknown;
}
