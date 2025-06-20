import 'package:equatable/equatable.dart';
import '../../core/enums/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        profilePictureUrl,
        role,
        createdAt,
        updatedAt,
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.profilePictureUrl == profilePictureUrl &&
        other.role == role &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        fullName.hashCode ^
        phoneNumber.hashCode ^
        profilePictureUrl.hashCode ^
        role.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, profilePictureUrl: $profilePictureUrl, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
