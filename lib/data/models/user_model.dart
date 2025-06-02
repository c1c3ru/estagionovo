// lib/data/models/user_model.dart
import 'package:equatable/equatable.dart';
import 'enums.dart'; // Importa os enums definidos anteriormente

class UserModel extends Equatable {
  final String id; // UUID PRIMARY KEY REFERENCES auth.users (id)
  final String email; // VARCHAR NOT NULL UNIQUE
  final UserRole role; // VARCHAR NOT NULL CHECK (role IN ('student', 'supervisor', 'admin'))
  final bool isActive; // BOOLEAN DEFAULT TRUE
  final DateTime createdAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  final DateTime? updatedAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: UserRole.fromString(json['role'] as String?),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.value,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? clearUpdatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
    );
  }
}
