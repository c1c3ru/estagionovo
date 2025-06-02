// lib/data/models/supervisor_model.dart
import 'package:equatable/equatable.dart';

class SupervisorModel extends Equatable {
  final String id; // UUID PRIMARY KEY REFERENCES users(id)
  final String fullName; // VARCHAR NOT NULL
  final String? department; // VARCHAR
  final String? position; // VARCHAR
  final String? jobCode; // VARCHAR(50)
  final String? profilePictureUrl; // TEXT
  final String? phoneNumber; // VARCHAR(20)
  final DateTime createdAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  final DateTime? updatedAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()

  const SupervisorModel({
    required this.id,
    required this.fullName,
    this.department,
    this.position,
    this.jobCode,
    this.profilePictureUrl,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        department,
        position,
        jobCode,
        profilePictureUrl,
        phoneNumber,
        createdAt,
        updatedAt,
      ];

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      department: json['department'] as String?,
      position: json['position'] as String?,
      jobCode: json['job_code'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'department': department,
      'position': position,
      'job_code': jobCode,
      'profile_picture_url': profilePictureUrl,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SupervisorModel copyWith({
    String? id,
    String? fullName,
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
  }) {
    return SupervisorModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      department: clearDepartment == true ? null : department ?? this.department,
      position: clearPosition == true ? null : position ?? this.position,
      jobCode: clearJobCode == true ? null : jobCode ?? this.jobCode,
      profilePictureUrl: clearProfilePictureUrl == true ? null : profilePictureUrl ?? this.profilePictureUrl,
      phoneNumber: clearPhoneNumber == true ? null : phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
    );
  }
}
