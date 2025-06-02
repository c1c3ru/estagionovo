// lib/data/models/contract_model.dart
import 'package:equatable/equatable.dart';
import 'package:estagio/core/enum/contract_status.dart';

class ContractModel extends Equatable {
  final String id; // UUID PRIMARY KEY DEFAULT gen_random_uuid()
  final String studentId; // UUID NOT NULL REFERENCES students(id)
  final String? supervisorId; // UUID REFERENCES supervisors(id) (opcional)
  final String contractType; // VARCHAR(50) NOT NULL DEFAULT 'internship'
  final ContractStatus status; // VARCHAR(50) NOT NULL DEFAULT 'active' CHECK
  final DateTime startDate; // DATE NOT NULL
  final DateTime endDate; // DATE NOT NULL
  final String? description; // TEXT (opcional)
  final String? documentUrl; // TEXT (opcional)
  final String?
  createdBy; // UUID REFERENCES auth.users(id) (opcional, quem criou o registro)
  final DateTime createdAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  final DateTime? updatedAt; // TIMESTAMP WITH TIME ZONE DEFAULT NOW()

  const ContractModel({
    required this.id,
    required this.studentId,
    this.supervisorId,
    this.contractType = 'internship',
    this.status = ContractStatus.active,
    required this.startDate,
    required this.endDate,
    this.description,
    this.documentUrl,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    supervisorId,
    contractType,
    status,
    startDate,
    endDate,
    description,
    documentUrl,
    createdBy,
    createdAt,
    updatedAt,
  ];

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      supervisorId: json['supervisor_id'] as String?,
      contractType: json['contract_type'] as String? ?? 'internship',
      status: ContractStatus.fromString(json['status'] as String?),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      description: json['description'] as String?,
      documentUrl: json['document_url'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'supervisor_id': supervisorId,
      'contract_type': contractType,
      'status': status.value,
      'start_date': startDate.toIso8601String().substring(
        0,
        10,
      ), // Formato YYYY-MM-DD para DATE
      'end_date': endDate.toIso8601String().substring(0, 10),
      'description': description,
      'document_url': documentUrl,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ContractModel copyWith({
    String? id,
    String? studentId,
    String? supervisorId,
    bool? clearSupervisorId,
    String? contractType,
    ContractStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? clearDescription,
    String? documentUrl,
    bool? clearDocumentUrl,
    String? createdBy,
    bool? clearCreatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? clearUpdatedAt,
  }) {
    return ContractModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      supervisorId: clearSupervisorId == true
          ? null
          : supervisorId ?? this.supervisorId,
      contractType: contractType ?? this.contractType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: clearDescription == true
          ? null
          : description ?? this.description,
      documentUrl: clearDocumentUrl == true
          ? null
          : documentUrl ?? this.documentUrl,
      createdBy: clearCreatedBy == true ? null : createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt == true ? null : updatedAt ?? this.updatedAt,
    );
  }
}
