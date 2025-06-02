  // lib/data/repositories/supervisor_repository.dart
  import 'package:dartz/dartz.dart';
  import 'package:flutter/material.dart'; // Para TimeOfDay, se necessário em mapeamentos
  import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

  import '../../../core/errors/app_exceptions.dart';
  import '../../domain/entities/contract_entity.dart';
  import '../../domain/entities/student_entity.dart';
  import '../../domain/entities/supervisor_entity.dart';
  import '../../domain/entities/time_log_entity.dart';
  import '../../domain/repositories/i_supervisor_repository.dart';
  import '../datasources/supabase/contract_datasource.dart';
  import '../datasources/supabase/student_datasource.dart';
  import '../datasources/supabase/supervisor_datasource.dart';
  import '../datasources/supabase/time_log_datasource.dart';
  import '../models/enums.dart'; // Para UserRole, StudentStatus, ContractStatus, etc.

  class SupervisorRepository implements ISupervisorRepository {
    final ISupervisorSupabaseDatasource _supervisorDatasource;
    final IStudentSupabaseDatasource _studentDatasource;
    final ITimeLogSupabaseDatasource _timeLogDatasource;
    final IContractSupabaseDatasource _contractDatasource;
    // final Logger logger; // Descomente se precisar de logging

    SupervisorRepository(
      this._supervisorDatasource,
      this._studentDatasource,
      this._timeLogDatasource,
      this._contractDatasource,
      // this.logger,
    );

    // --- Funções Auxiliares de Mapeamento ---

    SupervisorEntity _mapDataToSupervisorEntity(Map<String, dynamic> data) {
      return SupervisorEntity(
        id: data['id'] as String,
        fullName: data['full_name'] as String,
        department: data['department'] as String?,
        position: data['position'] as String?,
        jobCode: data['job_code'] as String?,
        profilePictureUrl: data['profile_picture_url'] as String?,
        phoneNumber: data['phone_number'] as String?,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null
            ? DateTime.parse(data['updated_at'] as String)
            : null,
        role: UserRole.supervisor, // Assumindo que esta entidade é sempre um supervisor
      );
    }

    StudentEntity _mapDataToStudentEntity(Map<String, dynamic> data) {
      return StudentEntity(
        id: data['id'] as String,
        fullName: data['full_name'] as String,
        registrationNumber: data['registration_number'] as String,
        course: data['course'] as String,
        advisorName: data['advisor_name'] as String,
        isMandatoryInternship: data['is_mandatory_internship'] as bool? ?? false,
        classShift: ClassShift.fromString(data['class_shift'] as String?),
        internshipShift1: InternshipShift.fromString(data['internship_shift_1'] as String?),
        internshipShift2: data['internship_shift_2'] != null
            ? InternshipShift.fromString(data['internship_shift_2'] as String?)
            : null,
        birthDate: DateTime.parse(data['birth_date'] as String),
        contractStartDate: DateTime.parse(data['contract_start_date'] as String),
        contractEndDate: DateTime.parse(data['contract_end_date'] as String),
        totalHoursRequired: (data['total_hours_required'] as num?)?.toDouble() ?? 0.0,
        totalHoursCompleted: (data['total_hours_completed'] as num?)?.toDouble() ?? 0.0,
        weeklyHoursTarget: (data['weekly_hours_target'] as num?)?.toDouble() ?? 0.0,
        profilePictureUrl: data['profile_picture_url'] as String?,
        phoneNumber: data['phone_number'] as String?,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null
            ? DateTime.parse(data['updated_at'] as String)
            : null,
        role: UserRole.student, // Assumindo que StudentEntity sempre tem role student
      );
    }

    TimeLogEntity _mapDataToTimeLogEntity(Map<String, dynamic> data) {
      final checkInTimeStr = data['check_in_time'] as String?;
      final checkOutTimeStr = data['check_out_time'] as String?;

      TimeOfDay? parseTime(String? timeStr) {
        if (timeStr == null) return null;
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        return null;
      }
      final checkIn = parseTime(checkInTimeStr);
      if (checkIn == null) {
        throw const FormatException("check_in_time inválido ou ausente nos dados do time_log.");
      }

      return TimeLogEntity(
        id: data['id'] as String,
        studentId: data['student_id'] as String,
        logDate: DateTime.parse(data['log_date'] as String),
        checkInTime: checkIn,
        checkOutTime: parseTime(checkOutTimeStr),
        hoursLogged: (data['hours_logged'] as num?)?.toDouble(),
        description: data['description'] as String?,
        approved: data['approved'] as bool? ?? false,
        supervisorId: data['supervisor_id'] as String?,
        approvedAt: data['approved_at'] != null
            ? DateTime.parse(data['approved_at'] as String)
            : null,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null
            ? DateTime.parse(data['updated_at'] as String)
            : null,
      );
    }

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

    // --- Implementação dos Métodos da Interface ---

    @override
    Future<Either<AppFailure, SupervisorEntity>> getSupervisorDetails(String userId) async {
      try {
        final supervisorData = await _supervisorDatasource.getSupervisorDataById(userId);
        if (supervisorData != null) {
          return Right(_mapDataToSupervisorEntity(supervisorData));
        } else {
          return Left(NotFoundFailure(message: 'Perfil de supervisor não encontrado para o ID: $userId'));
        }
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter detalhes do supervisor: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao obter detalhes do supervisor: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, List<StudentEntity>>> getAllStudents(FilterStudentsParams? params) async {
      try {
        // O datasource lida com os filtros. O repositório apenas mapeia.
        final studentsData = await _studentDatasource.getAllStudentsData(
          nameFilter: params?.name,
          courseFilter: params?.course,
          statusFilter: params?.status?.value, // Passa o valor string do enum
        );
        final studentEntities = studentsData.map((data) => _mapDataToStudentEntity(data)).toList();
        return Right(studentEntities);
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter lista de estudantes: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao obter lista de estudantes: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, StudentEntity>> getStudentDetailsForSupervisor(String studentId) async {
      try {
        final studentData = await _studentDatasource.getStudentDataById(studentId);
        if (studentData != null) {
          return Right(_mapDataToStudentEntity(studentData));
        } else {
          return Left(NotFoundFailure(message: 'Estudante não encontrado com ID: $studentId'));
        }
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter detalhes do estudante: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao obter detalhes do estudante: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, StudentEntity>> createStudent(StudentEntity studentData) async {
      try {
        // O supervisor cria um estudante. Primeiro, o usuário precisa existir no Supabase Auth.
        // Esta função assume que o usuário já foi criado no Auth e na tabela 'users'
        // e agora estamos a criar o perfil na tabela 'students'.
        // A StudentEntity já deve ter o ID do usuário.
        final Map<String, dynamic> dataToCreate = {
          'id': studentData.id, // ID do auth.users
          'full_name': studentData.fullName,
          'registration_number': studentData.registrationNumber,
          'course': studentData.course,
          'advisor_name': studentData.advisorName,
          'is_mandatory_internship': studentData.isMandatoryInternship,
          'class_shift': studentData.classShift.value,
          'internship_shift_1': studentData.internshipShift1.value,
          if (studentData.internshipShift2 != null) 'internship_shift_2': studentData.internshipShift2!.value,
          'birth_date': studentData.birthDate.toIso8601String().substring(0,10),
          'contract_start_date': studentData.contractStartDate.toIso8601String().substring(0,10),
          'contract_end_date': studentData.contractEndDate.toIso8601String().substring(0,10),
          'total_hours_required': studentData.totalHoursRequired,
          'total_hours_completed': studentData.totalHoursCompleted,
          'weekly_hours_target': studentData.weeklyHoursTarget,
          'profile_picture_url': studentData.profilePictureUrl,
          'phone_number': studentData.phoneNumber,
          // created_at e updated_at são geridos pelo DB/trigger
        };
        final createdStudentData = await _studentDatasource.createStudentData(dataToCreate);
        return Right(_mapDataToStudentEntity(createdStudentData));
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao criar estudante: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao criar estudante: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, StudentEntity>> updateStudentBySupervisor(StudentEntity studentData) async {
      try {
        final Map<String, dynamic> dataToUpdate = {
          // ID não é atualizado
          'full_name': studentData.fullName,
          'registration_number': studentData.registrationNumber,
          'course': studentData.course,
          'advisor_name': studentData.advisorName,
          'is_mandatory_internship': studentData.isMandatoryInternship,
          'class_shift': studentData.classShift.value,
          'internship_shift_1': studentData.internshipShift1.value,
          'internship_shift_2': studentData.internshipShift2?.value, // Envia null se for null
          'birth_date': studentData.birthDate.toIso8601String().substring(0,10),
          'contract_start_date': studentData.contractStartDate.toIso8601String().substring(0,10),
          'contract_end_date': studentData.contractEndDate.toIso8601String().substring(0,10),
          'total_hours_required': studentData.totalHoursRequired,
          'total_hours_completed': studentData.totalHoursCompleted,
          'weekly_hours_target': studentData.weeklyHoursTarget,
          'profile_picture_url': studentData.profilePictureUrl,
          'phone_number': studentData.phoneNumber,
        };
        final updatedStudentData = await _studentDatasource.updateStudentData(studentData.id, dataToUpdate);
        return Right(_mapDataToStudentEntity(updatedStudentData));
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao atualizar estudante: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao atualizar estudante: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, void>> deleteStudent(String studentId) async {
      try {
        // A remoção na tabela 'students' deve, devido ao ON DELETE CASCADE,
        // também remover o utilizador da tabela 'users' e, por sua vez, do auth.users.
        // Verifique se a sua RLS e triggers permitem isso corretamente.
        // Primeiro, pode ser necessário remover de tabelas dependentes como time_logs e contracts se não houver CASCADE nelas.
        // No nosso esquema, time_logs e contracts têm ON DELETE CASCADE para students.id.
        // A tabela students tem ON DELETE CASCADE para users.id.
        // A tabela users tem ON DELETE CASCADE para auth.users.id.
        // Então, remover de 'students' deveria propagar.
        // No entanto, é mais seguro remover o utilizador do Supabase Auth, o que deve propagar para 'users' e depois para 'students'.
        // Mas a interface do repositório de supervisor não tem acesso direto ao AuthRepository.
        // Uma alternativa é ter um AdminSupabaseDatasource para remover utilizadores do auth.
        // Por agora, vamos assumir que a remoção da tabela 'students' é suficiente ou que
        // a lógica de remoção completa do utilizador (auth + tabelas) está num usecase de admin.
        // Se o objetivo é apenas remover o registo de 'students':
        await _studentDatasource.deleteStudentData(studentId);
        return const Right(null);
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao remover estudante: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao remover estudante: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, List<TimeLogEntity>>> getAllTimeLogs({
      String? studentId,
      bool? pendingApprovalOnly,
    }) async {
      try {
        final timeLogsData = await _timeLogDatasource.getAllTimeLogsData(
          studentId: studentId,
          approved: pendingApprovalOnly == true ? false : null, // Se pendingOnly, approved deve ser false
        );
        final timeLogEntities = timeLogsData.map((data) => _mapDataToTimeLogEntity(data)).toList();
        return Right(timeLogEntities);
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter todos os registos de tempo: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao obter todos os registos de tempo: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, TimeLogEntity>> approveOrRejectTimeLog({
      required String timeLogId,
      required bool approved,
      required String supervisorId, // ID do supervisor que está a aprovar/rejeitar
      String? rejectionReason, // Não usado diretamente aqui, mas pode ser logado ou adicionado à descrição
    }) async {
      try {
        final Map<String, dynamic> dataToUpdate = {
          'approved': approved,
          'supervisor_id': supervisorId,
          'approved_at': DateTime.now().toIso8601String(),
        };
        // Se for rejeitado e houver um motivo, você pode querer adicioná-lo à descrição do log.
        // Isso exigiria buscar o log primeiro para anexar à descrição existente.
        // Por simplicidade, esta implementação apenas atualiza os campos de aprovação.

        final updatedTimeLogData = await _timeLogDatasource.updateTimeLogData(timeLogId, dataToUpdate);
        return Right(_mapDataToTimeLogEntity(updatedTimeLogData));
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao aprovar/rejeitar registo de tempo: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao aprovar/rejeitar registo de tempo: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, List<ContractEntity>>> getAllContracts(String? studentIdFilter) async {
      try {
        final contractsData = await _contractDatasource.getAllContractsData(
          studentId: studentIdFilter,
          // Adicione outros filtros se a interface do datasource suportar
        );
        final contractEntities = contractsData.map((data) => _mapDataToContractEntity(data)).toList();
        return Right(contractEntities);
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao obter contratos: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao obter contratos: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, ContractEntity>> createContract(ContractEntity contractData) async {
      try {
        final Map<String, dynamic> dataToCreate = {
          'student_id': contractData.studentId,
          'supervisor_id': contractData.supervisorId,
          'contract_type': contractData.contractType,
          'status': contractData.status.value,
          'start_date': contractData.startDate.toIso8601String().substring(0,10),
          'end_date': contractData.endDate.toIso8601String().substring(0,10),
          'description': contractData.description,
          'document_url': contractData.documentUrl,
          'created_by': contractData.createdBy, // ID do auth.user que está a criar
        };
        final createdContractData = await _contractDatasource.createContractData(dataToCreate);
        return Right(_mapDataToContractEntity(createdContractData));
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao criar contrato: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao criar contrato: ${e.toString()}', originalException: e));
      }
    }

    @override
    Future<Either<AppFailure, ContractEntity>> updateContract(ContractEntity contractData) async {
      try {
        final Map<String, dynamic> dataToUpdate = {
          // student_id geralmente não é alterado num update de contrato, mas sim o contrato é substituído ou terminado.
          // Se for permitido, adicione aqui.
          'supervisor_id': contractData.supervisorId,
          'contract_type': contractData.contractType,
          'status': contractData.status.value,
          'start_date': contractData.startDate.toIso8601String().substring(0,10),
          'end_date': contractData.endDate.toIso8601String().substring(0,10),
          'description': contractData.description,
          'document_url': contractData.documentUrl,
          // created_by e created_at não são atualizados
        };
        final updatedContractData = await _contractDatasource.updateContractData(contractData.id, dataToUpdate);
        return Right(_mapDataToContractEntity(updatedContractData));
      } on PostgrestException catch (e) {
        return Left(SupabaseServerFailure(message: 'Erro do Supabase ao atualizar contrato: ${e.message}', originalException: e));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, originalException: e.originalException));
      } catch (e) {
        return Left(ServerFailure(message: 'Erro desconhecido ao atualizar contrato: ${e.toString()}', originalException: e));
      }
    }
  }
