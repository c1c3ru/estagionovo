// lib/domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';
import 'package:estagio/core/enum/user_role.dart';
// Importa o enum UserRole da camada de dados.
// Se preferir uma separação mais estrita, você pode definir um UserRoleEntity aqui.

class UserEntity extends Equatable {
  final String id;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, role, isActive, createdAt, updatedAt];

  UserEntity copyWith({
    String? id,
    String? email,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? clearUpdatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
    );
  }
}
