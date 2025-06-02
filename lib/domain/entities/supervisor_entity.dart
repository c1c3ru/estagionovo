
// lib/domain/entities/supervisor_entity.dart
import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class SupervisorEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String department;
  final String? specialization;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupervisorEntity({
    required this.id,
    required this.user,
    required this.department,
    this.specialization,
    this.phoneNumber,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        department,
        specialization,
        phoneNumber,
        profilePictureUrl,
        createdAt,
        updatedAt,
      ];

  SupervisorEntity copyWith({
    String? id,
    UserEntity? user,
    String? department,
    String? specialization,
    String? phoneNumber,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupervisorEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      department: department ?? this.department,
      specialization: specialization ?? this.specialization,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
