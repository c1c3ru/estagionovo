// lib/data/repositories/contract_repository.dart
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../../core/errors/app_exceptions.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/i_contract_repository.dart'; // Contém UpsertContractParams
import '../datasources/supabase/contract_datasource.dart';
import '../models/enums.dart'; // Para ContractStatus

class ContractRepository implements IContractRepository {
  final IContractSupabaseDatasource _contractDatasource;
  // final Logger logger;

  ContractRepository(this._contractDatasource /*, this.logger*/);

  ContractEntity _mapDataToContractEntity(Map<String, dynamic> data) {
    return ContractEntity(
      id: data['id'] as String,
      studentId: data['student_id'] as String,
      supervisorId: data['supervisor_id'] as String?,
      contractType: data['contract_type'] as String? ?? 'internship',
      status: ContractStatus.fromString(data['status'] as String?),
      startDate: DateTime.parse(data['start_date'] as String),
      endDate: DateTime.parse(data['end_date'] as String),
      description: data['description'] as String?,
      documentUrl: data['document_url'] as String?,
      createdBy: data['created_by'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> _mapUpsertParamsToData(UpsertContractParams params, {bool isCreating = false}) {
    final Map<String, dynamic> data = {
      'student_id': params.studentId,
      'supervisor_id': params.supervisorId,
      'contract_type': params.contractType,
      'status': params.status.value,
      'start_date': params.startDate.toIso8601String().substring(0, 10),
      'end_date': params.endDate.toIso8601String().substring(0, 10),
      'description': params.description,
      'document_url': params.documentUrl,
      // 'created_by' é definido na criação, não é atualizado tipicamente
    };
    if (isCreating) {
      data['created_by'] = params.createdBy;
      // 'id' é gerado pelo DB na criação
    }
    return data;
  }


  @override
  Future<Either<AppFailure, ContractEntity>> createContract(UpsertContractParams params) async {
    try {
      final dataToCreate = _mapUpsertParamsToData(params, isCreating: true);
      final newContractData = await _contractDatasource.createContractData(dataToCreate);
      return Right(_mapDataToContractEntity(newContractData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(message: 'Erro do Supabase ao criar contrato: ${e.message}', originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido ao criar contrato: ${e.toString()}', originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, ContractEntity>> getContractById(String contractId) async {
    try {
      final contractData = await _contractDatasource.getContractDataById(contractId);
      if (contractData != null) {
        return Right(_mapDataToContractEntity(contractData));
      } else {
        return Left(NotFoundFailure(message: 'Contrato não encontrado com ID: $contractId'));
      }
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter contrato: ${e.message}', originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido ao obter contrato: ${e.toString()}', originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, List<ContractEntity>>> getContractsForStudent(String studentId) async {
    try {
      final contractsData = await _contractDatasource.getContractsDataForStudent(studentId);
      final contractEntities = contractsData.map((data) => _mapDataToContractEntity(data)).toList();
      return Right(contractEntities);
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter contratos do estudante: ${e.message}', originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido ao obter contratos do estudante: ${e.toString()}', originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, List<ContractEntity>>> getAllContracts({
    String? studentId,
    String? supervisorId,
    ContractStatus? status,
  }) async {
    try {
      final contractsData = await _contractDatasource.getAllContractsData(
        studentId: studentId,
        supervisorId: supervisorId,
        status: status?.value, // Passa o valor string do enum
      );
      final contractEntities = contractsData.map((data) => _mapDataToContractEntity(data)).toList();
      return Right(contractEntities);
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter todos os contratos: ${e.message}', originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido ao obter todos os contratos: ${e.toString()}', originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, ContractEntity>> updateContract(UpsertContractParams params) async {
    try {
      if (params.id == null) {
        return Left(ValidationFailure(message: 'ID do contrato é obrigatório para atualização.'));
      }
      final dataToUpdate = _mapUpsertParamsToData(params, isCreating: false);
      final updatedContractData = await _contractDatasource.updateContractData(params.id!, dataToUpdate);
      return Right(_mapDataToContractEntity(updatedContractData));
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(message: 'Erro do Supabase ao atualizar contrato: ${e.message}', originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido ao atualizar contrato: ${e.toString()}', originalException: e));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteContract(String contractId) async {
    try {
      await _contractDatasource.deleteContractData(contractId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(SupabaseServerFailure(message: 'Erro do Supabase ao remover contrato: ${e.message}', originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, originalException: e.originalException));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido ao remover contrato: ${e.toString()}', originalException: e));
    }
  }
}
