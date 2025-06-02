
// lib/domain/entities/contract_entity.dart
import 'package:equatable/equatable.dart';
import '../../core/enum/contract_status.dart';

class ContractEntity extends Equatable {
  final String id;
  final String studentId;
  final String supervisorId;
  final String companyName;
  final String companyAddress;
  final String companyCnpj;
  final DateTime startDate;
  final DateTime endDate;
  final int totalHoursRequired;
  final ContractStatus status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContractEntity({
    required this.id,
    required this.studentId,
    required this.supervisorId,
    required this.companyName,
    required this.companyAddress,
    required this.companyCnpj,
    required this.startDate,
    required this.endDate,
    required this.totalHoursRequired,
    required this.status,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        supervisorId,
        companyName,
        companyAddress,
        companyCnpj,
        startDate,
        endDate,
        totalHoursRequired,
        status,
        description,
        createdAt,
        updatedAt,
      ];

  ContractEntity copyWith({
    String? id,
    String? studentId,
    String? supervisorId,
    String? companyName,
    String? companyAddress,
    String? companyCnpj,
    DateTime? startDate,
    DateTime? endDate,
    int? totalHoursRequired,
    ContractStatus? status,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContractEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      supervisorId: supervisorId ?? this.supervisorId,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyCnpj: companyCnpj ?? this.companyCnpj,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalHoursRequired: totalHoursRequired ?? this.totalHoursRequired,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
