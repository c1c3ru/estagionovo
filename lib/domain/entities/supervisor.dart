// lib/domain/entities/supervisor_entity.dart
import 'package:equatable/equatable.dart';
import 'package:gestao_de_estagio/core/enums/user_role.dart';
// Importa o enum UserRole da camada de dados.

class SupervisorEntity extends Equatable {
  final String id;
  final String fullName;
  final String siapeRegistration;
  final String? department;
  final String? position;
  final String? jobCode;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // Adicionando o UserRole aqui, pois um supervisor é um tipo de usuário
  final UserRole role;

  const SupervisorEntity({
    required this.id,
    required this.fullName,
    required this.siapeRegistration,
    this.department,
    this.position,
    this.jobCode,
    this.profilePictureUrl,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
    this.role = UserRole.supervisor, // Define o papel padrão como supervisor
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        siapeRegistration,
        department,
        position,
        jobCode,
        profilePictureUrl,
        phoneNumber,
        createdAt,
        updatedAt,
        role,
      ];

  SupervisorEntity copyWith({
    String? id,
    String? fullName,
    String? siapeRegistration,
    String? department,
    bool? clearDepartment,
    String? position,
    bool? clearPosition,
    String? jobCode,
    bool? clearJobCode,
    String? profilePictureUrl,
    bool? clearProfilePictureUrl,
    String? phoneNumber,
    bool? clearPhoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? clearUpdatedAt,
    UserRole? role,
  }) {
    return SupervisorEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      siapeRegistration: siapeRegistration ?? this.siapeRegistration,
      department:
          clearDepartment == true ? null : department ?? this.department,
      position: clearPosition == true ? null : position ?? this.position,
      jobCode: clearJobCode == true ? null : jobCode ?? this.jobCode,
      profilePictureUrl: clearProfilePictureUrl == true
          ? null
          : profilePictureUrl ?? this.profilePictureUrl,
      phoneNumber:
          clearPhoneNumber == true ? null : phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }
}
