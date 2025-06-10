import 'package:equatable/equatable.dart';
import '../../core/enum/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isEmailVerified;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.isEmailVerified = false,
    required bool isActive,
    String? profilePictureUrl,
    String? phoneNumber,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        role,
        createdAt,
        updatedAt,
        isEmailVerified,
      ];

  get registrationNumber => null;

  get advisorName => null;

  get birthDate => null;

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: true,
    );
  }
}
