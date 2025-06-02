// lib/data/datasources/supabase/contract_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_exceptions.dart';
// Importe o enum ContractStatus se precisar de conversões aqui,
// mas geralmente é feito no modelo ou repositório.
// import '../../models/enums.dart';

abstract class IContractSupabaseDatasource {
  /// Cria um novo contrato na tabela 'contracts'.
  Future<Map<String, dynamic>> createContractData(
    Map<String, dynamic> contractData,
  );

  /// Obtém um contrato específico pelo seu ID.
  Future<Map<String, dynamic>?> getContractDataById(String contractId);

  /// Obtém todos os contratos para um estudante específico.
  Future<List<Map<String, dynamic>>> getContractsDataForStudent(
    String studentId,
  );

  /// Obtém todos os contratos, opcionalmente filtrados.
  Future<List<Map<String, dynamic>>> getAllContractsData({
    String? studentId,
    String? supervisorId,
    String? status, // String para o valor do enum ContractStatus
  });

  /// Atualiza um contrato existente.
  Future<Map<String, dynamic>> updateContractData(
    String contractId,
    Map<String, dynamic> dataToUpdate,
  );

  /// Remove um contrato.
  Future<void> deleteContractData(String contractId);
}

class ContractSupabaseDatasource implements IContractSupabaseDatasource {
  final SupabaseClient _supabaseClient;

  ContractSupabaseDatasource(this._supabaseClient);

  @override
  Future<Map<String, dynamic>> createContractData(
    Map<String, dynamic> contractData,
  ) async {
    try {
      final response = await _supabaseClient
          .from('contracts')
          .insert(contractData)
          .select()
          .single();
      return response;
    } on PostgrestException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(
        'Erro inesperado ao criar contrato: ${e.toString()}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getContractDataById(String contractId) async {
    try {
      final response = await _supabaseClient
          .from('contracts')
          .select() // Você pode querer selecionar colunas específicas ou fazer joins aqui
          .eq('id', contractId)
          .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(
        'Erro inesperado ao obter contrato: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getContractsDataForStudent(
    String studentId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('contracts')
          .select()
          .eq('student_id', studentId)
          .order('start_date', ascending: false);
      return response;
    } on PostgrestException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(
        'Erro inesperado ao obter contratos do estudante: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllContractsData({
    String? studentId,
    String? supervisorId,
    String? status,
  }) async {
    try {
      var query = _supabaseClient
          .from('contracts')
          .select()
          // Exemplo de join se você quiser buscar o nome do estudante/supervisor
          // .select('*, student:students(full_name), supervisor:supervisors(full_name)')
          .order('created_at', ascending: false);

      if (studentId != null && studentId.isNotEmpty) {
        query = query.eq('student_id', studentId);
      }
      if (supervisorId != null && supervisorId.isNotEmpty) {
        query = query.eq('supervisor_id', supervisorId);
      }
      if (status != null && status.isNotEmpty) {
        query = query.eq(
          'status',
          status,
        ); // Assume que 'status' é o nome da coluna e o valor é string
      }

      final response = await query;
      return response;
    } on PostgrestException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(
        'Erro inesperado ao obter todos os contratos: ${e.toString()}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateContractData(
    String contractId,
    Map<String, dynamic> dataToUpdate,
  ) async {
    try {
      // O trigger 'trigger_set_timestamp' deve cuidar do 'updated_at'.
      final response = await _supabaseClient
          .from('contracts')
          .update(dataToUpdate)
          .eq('id', contractId)
          .select()
          .single();
      return response;
    } on PostgrestException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(
        'Erro inesperado ao atualizar contrato: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteContractData(String contractId) async {
    try {
      await _supabaseClient.from('contracts').delete().eq('id', contractId);
    } on PostgrestException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(
        'Erro inesperado ao remover contrato: ${e.toString()}',
      );
    }
  }
}
