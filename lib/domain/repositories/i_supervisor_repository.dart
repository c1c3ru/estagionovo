import '../entities/supervisor_entity.dart';

abstract class ISupervisorRepository {
  Future<List<SupervisorEntity>> getAllSupervisors();
  Future<SupervisorEntity?> getSupervisorById(String id);
  Future<SupervisorEntity?> getSupervisorByUserId(String userId);
  Future<SupervisorEntity> createSupervisor(SupervisorEntity supervisor);
  Future<SupervisorEntity> updateSupervisor(SupervisorEntity supervisor);
  Future<void> deleteSupervisor(String id);
}

