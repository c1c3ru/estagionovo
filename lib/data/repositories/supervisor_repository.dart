import '../../domain/repositories/i_supervisor_repository.dart';
import '../../domain/entities/supervisor_entity.dart';
import '../datasources/supabase/supervisor_datasource.dart';
import '../models/supervisor_model.dart';

class SupervisorRepository implements ISupervisorRepository {
  final SupervisorDatasource _supervisorDatasource;

  SupervisorRepository(this._supervisorDatasource);

  @override
  Future<List<SupervisorEntity>> getAllSupervisors() async {
    try {
      final supervisorsData = await _supervisorDatasource.getAllSupervisors();
      return supervisorsData
          .map((data) => SupervisorModel.fromJson(data).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar supervisores: $e');
    }
  }

  @override
  Future<SupervisorEntity?> getSupervisorById(String id) async {
    try {
      final supervisorData = await _supervisorDatasource.getSupervisorById(id);
      if (supervisorData == null) return null;
      return SupervisorModel.fromJson(supervisorData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar supervisor: $e');
    }
  }

  @override
  Future<SupervisorEntity?> getSupervisorByUserId(String userId) async {
    try {
      final supervisorData = await _supervisorDatasource.getSupervisorByUserId(userId);
      if (supervisorData == null) return null;
      return SupervisorModel.fromJson(supervisorData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao buscar supervisor por usuário: $e');
    }
  }

  @override
  Future<SupervisorEntity> createSupervisor(SupervisorEntity supervisor) async {
    try {
      final supervisorModel = SupervisorModel.fromEntity(supervisor);
      final createdData = await _supervisorDatasource.createSupervisor(supervisorModel.toJson());
      return SupervisorModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao criar supervisor: $e');
    }
  }

  @override
  Future<SupervisorEntity> updateSupervisor(SupervisorEntity supervisor) async {
    try {
      final supervisorModel = SupervisorModel.fromEntity(supervisor);
      final updatedData = await _supervisorDatasource.updateSupervisor(
        supervisor.id,
        supervisorModel.toJson(),
      );
      return SupervisorModel.fromJson(updatedData).toEntity();
    } catch (e) {
      throw Exception('Erro no repositório ao atualizar supervisor: $e');
    }
  }

  @override
  Future<void> deleteSupervisor(String id) async {
    try {
      await _supervisorDatasource.deleteSupervisor(id);
    } catch (e) {
      throw Exception('Erro no repositório ao excluir supervisor: $e');
    }
  }
}

