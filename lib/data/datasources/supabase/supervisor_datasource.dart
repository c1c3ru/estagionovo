// lib/data/datasources/supabase/supervisor_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_exceptions.dart'; // Para ServerException

abstract class ISupervisorSupabaseDatasource {
  /// Obtém os dados de um supervisor da tabela 'supervisors' pelo seu ID (que é o auth.uid).
  Future<Map<String, dynamic>?> getSupervisorDataById(String userId);

  /// Cria um novo registo de supervisor na tabela 'supervisors'.
  /// Geralmente chamado após o registo no Supabase Auth e a criação na tabela 'users'.
  Future<Map<String, dynamic>> createSupervisorData(
      Map<String, dynamic> supervisorData);

  /// Atualiza os dados de um supervisor na tabela 'supervisors'.
  Future<Map<String, dynamic>> updateSupervisorData(
      String userId, Map<String, dynamic> dataToUpdate);

  // Outras operações específicas para supervisores que interagem diretamente com a tabela 'supervisors'
  // podem ser adicionadas aqui. Por exemplo, listar todos os supervisores para um admin.
}

class SupervisorSupabaseDatasource implements ISupervisorSupabaseDatasource {
  final SupabaseClient _supabaseClient;

  SupervisorSupabaseDatasource(this._supabaseClient);

  @override
  Future<Map<String, dynamic>?> getSupervisorDataById(String userId) async {
    try {
      final response = await _supabaseClient
          .from('supervisors')
          .select()
          .eq('id', userId)
          .maybeSingle(); // Retorna null se não encontrar, em vez de erro

      return response;
    } on PostgrestException {
      // O repositório tratará PostgrestException
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao obter dados do supervisor: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createSupervisorData(
      Map<String, dynamic> supervisorData) async {
    try {
      // Garante que o ID está presente nos dados a serem inseridos
      if (supervisorData['id'] == null) {
        throw ArgumentError(
            'O ID do supervisor é obrigatório para criar o registo em supervisors.');
      }
      final response = await _supabaseClient
          .from('supervisors')
          .insert(supervisorData)
          .select()
          .single(); // Retorna o registo inserido

      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao criar dados do supervisor: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateSupervisorData(
      String userId, Map<String, dynamic> dataToUpdate) async {
    try {
      // O trigger 'trigger_set_timestamp' deve cuidar do 'updated_at'.
      final response = await _supabaseClient
          .from('supervisors')
          .update(dataToUpdate)
          .eq('id', userId)
          .select()
          .single(); // Retorna o registo atualizado

      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao atualizar dados do supervisor: ${e.toString()}');
    }
  }
}
