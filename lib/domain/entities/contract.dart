// lib/domain/entities/contract_entity.dart
import 'package:equatable/equatable.dart';
import 'package:estagio/core/enum/contract_status.dart';
// Importa o enum ContractStatus da camada de dados.

class ContractEntity extends Equatable {
  final String id;
  final String studentId;
  final String? supervisorId;
  final String contractType;
  final ContractStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String? documentUrl;
  final String? createdBy; // UUID do usuário que criou o registro do contrato
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ContractEntity({
    required this.id,
    required this.studentId,
    this.supervisorId,
    required this.contractType,
    required this.status,
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

  ContractEntity copyWith({
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
    return ContractEntity(
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
