// lib/domain/repositories/i_contract_repository.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/core/enum/contract_status.dart';
import '../entities/contract_entity.dart';
import '../../core/errors/app_exceptions.dart';

// Parâmetros para criar/atualizar um contrato
class UpsertContractParams {
  final String? id; // Nulo para criação, preenchido para atualização
  final String studentId;
  final String? supervisorId;
  final String contractType;
  final ContractStatus status; // Usando o enum ContractStatus
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String? documentUrl;
  final String
      createdBy; // ID do usuário (supervisor/admin) que está a criar/atualizar

  UpsertContractParams({
    this.id,
    required this.studentId,
    this.supervisorId,
    required this.contractType,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.description,
    this.documentUrl,
    required this.createdBy,
  });
}

abstract class IContractRepository {
  /// Cria um novo contrato.
  Future<Either<AppFailure, ContractEntity>> createContract(
      UpsertContractParams params);

  /// Obtém um contrato específico pelo seu ID.
  Future<Either<AppFailure, ContractEntity>> getContractById(String contractId);

  /// Obtém todos os contratos para um estudante específico.
  Future<Either<AppFailure, List<ContractEntity>>> getContractsForStudent(
      String studentId);

  /// Obtém todos os contratos (geralmente para um supervisor ou admin).
  /// Pode incluir filtros por status, supervisor, etc.
  Future<Either<AppFailure, List<ContractEntity>>> getAllContracts({
    String? studentId,
    String? supervisorId,
    ContractStatus? status,
  });

  /// Atualiza um contrato existente.
  Future<Either<AppFailure, ContractEntity>> updateContract(
      UpsertContractParams params);

  /// Remove um contrato.
  Future<Either<AppFailure, Unit>> deleteContract(
      String contractId); // CORRIGIDO: de void para Unit
}
