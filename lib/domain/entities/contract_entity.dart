import 'package:equatable/equatable.dart';
import '../../core/enum/contract_status.dart';

// Represents a contract, inheriting from Equatable for value comparison.
class ContractEntity extends Equatable {
  final String id;
  final String studentId;
  final String supervisorId;
  final String? createdBy; // ID of the user who created the contract

  // Company Information
  final String companyName;
  final String companyAddress;
  final String companyCnpj;

  // Contract Details
  final DateTime startDate;
  final DateTime endDate;
  final int totalHoursRequired;
  final ContractStatus status;
  final String contractType;
  final String? description;
  final String? documentUrl;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ContractEntity({
    required this.id,
    required this.studentId,
    required this.supervisorId,
    this.createdBy,
    required this.companyName,
    required this.companyAddress,
    required this.companyCnpj,
    required this.startDate,
    required this.endDate,
    required this.totalHoursRequired,
    required this.status,
    required this.contractType,
    this.description,
    this.documentUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        supervisorId,
        createdBy,
        companyName,
        companyAddress,
        companyCnpj,
        startDate,
        endDate,
        totalHoursRequired,
        status,
        contractType,
        description,
        documentUrl,
        createdAt,
        updatedAt,
      ];

  // copyWith method to create a new instance with updated fields.
  ContractEntity copyWith({
    String? id,
    String? studentId,
    String? supervisorId,
    String? createdBy,
    String? companyName,
    String? companyAddress,
    String? companyCnpj,
    DateTime? startDate,
    DateTime? endDate,
    int? totalHoursRequired,
    ContractStatus? status,
    String? contractType,
    String? description,
    String? documentUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContractEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      supervisorId: supervisorId ?? this.supervisorId,
      createdBy: createdBy ?? this.createdBy,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyCnpj: companyCnpj ?? this.companyCnpj,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      status: status ?? this.status,
      contractType: contractType ?? this.contractType,
      description: description ?? this.description,
      documentUrl: documentUrl ?? this.documentUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
