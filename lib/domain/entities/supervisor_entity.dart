import 'package:equatable/equatable.dart';
import 'package:estagio/core/enum/user_role.dart';
import 'user_entity.dart';

// Represents a supervisor, inheriting from Equatable for value comparison.
class SupervisorEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String fullName;
  final UserRole role;

  // Professional Information
  final String department;
  final String? position;
  final String? jobCode;
  final String? specialization;

  // Contact and Personalization
  final String? phoneNumber;
  final String? profilePictureUrl;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SupervisorEntity({
    required this.id,
    required this.user,
    required this.fullName,
    this.role = UserRole.supervisor,
    required this.department,
    this.position,
    this.jobCode,
    this.specialization,
    this.phoneNumber,
    this.profilePictureUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        fullName,
        role,
        department,
        position,
        jobCode,
        specialization,
        phoneNumber,
        profilePictureUrl,
        createdAt,
        updatedAt,
      ];

  // copyWith method to create a new instance with updated fields.
  SupervisorEntity copyWith({
    String? id,
    UserEntity? user,
    String? fullName,
    UserRole? role,
    String? department,
    String? position,
    String? jobCode,
    String? specialization,
    String? phoneNumber,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupervisorEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      department: department ?? this.department,
      position: position ?? this.position,
      jobCode: jobCode ?? this.jobCode,
      specialization: specialization ?? this.specialization,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
