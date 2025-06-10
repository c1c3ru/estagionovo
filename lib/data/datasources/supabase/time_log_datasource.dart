// lib/data/datasources/supabase/time_log_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_exceptions.dart';

abstract class ITimeLogSupabaseDatasource {
  /// Cria um novo registo de tempo na tabela 'time_logs'.
  Future<Map<String, dynamic>> createTimeLogData(
      Map<String, dynamic> timeLogData);

  /// Obtém um registo de tempo específico pelo seu ID.
  Future<Map<String, dynamic>?> getTimeLogDataById(String timeLogId);

  /// Obtém todos os registos de tempo para um estudante específico, opcionalmente num intervalo de datas.
  Future<List<Map<String, dynamic>>> getTimeLogsDataForStudent({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Atualiza um registo de tempo existente.
  Future<Map<String, dynamic>> updateTimeLogData(
      String timeLogId, Map<String, dynamic> dataToUpdate);

  /// Remove um registo de tempo.
  Future<void> deleteTimeLogData(String timeLogId);

  /// Obtém todos os registos de tempo (para supervisores/admins), opcionalmente filtrados.
  Future<List<Map<String, dynamic>>> getAllTimeLogsData({
    String? studentId,
    bool? approved, // Filtrar por status de aprovação
    DateTime? startDate,
    DateTime? endDate,
  });
}

class TimeLogSupabaseDatasource implements ITimeLogSupabaseDatasource {
  final SupabaseClient _supabaseClient;

  TimeLogSupabaseDatasource(this._supabaseClient);

  @override
  Future<Map<String, dynamic>> createTimeLogData(
      Map<String, dynamic> timeLogData) async {
    try {
      final response = await _supabaseClient
          .from('time_logs')
          .insert(timeLogData)
          .select()
          .single();
      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao criar registo de tempo: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getTimeLogDataById(String timeLogId) async {
    try {
      final response = await _supabaseClient
          .from('time_logs')
          .select()
          .eq('id', timeLogId)
          .maybeSingle();
      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao obter registo de tempo: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTimeLogsDataForStudent({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabaseClient
          .from('time_logs')
          .select()
          .eq('student_id', studentId)
          .order('log_date', ascending: false) // Mais recentes primeiro
          .order('check_in_time', ascending: false);

      if (startDate != null) {
        query =
            query.gte('log_date', startDate.toIso8601String().substring(0, 10));
      }
      if (endDate != null) {
        query =
            query.lte('log_date', endDate.toIso8601String().substring(0, 10));
      }

      final response = await query;
      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao obter registos de tempo do estudante: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateTimeLogData(
      String timeLogId, Map<String, dynamic> dataToUpdate) async {
    try {
      // O trigger 'trigger_set_timestamp' deve cuidar do 'updated_at'.
      final response = await _supabaseClient
          .from('time_logs')
          .update(dataToUpdate)
          .eq('id', timeLogId)
          .select()
          .single();
      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao atualizar registo de tempo: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTimeLogData(String timeLogId) async {
    try {
      await _supabaseClient.from('time_logs').delete().eq('id', timeLogId);
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao remover registo de tempo: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllTimeLogsData({
    String? studentId,
    bool? approved,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabaseClient
          .from('time_logs')
          .select()
          .order('log_date', ascending: false)
          .order('created_at', ascending: false); // Ou check_in_time

      if (studentId != null && studentId.isNotEmpty) {
        query = query.eq('student_id', studentId);
      }
      if (approved != null) {
        query = query.eq('approved', approved);
      }
      if (startDate != null) {
        query =
            query.gte('log_date', startDate.toIso8601String().substring(0, 10));
      }
      if (endDate != null) {
        query =
            query.lte('log_date', endDate.toIso8601String().substring(0, 10));
      }

      final response = await query;
      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao obter todos os registos de tempo: ${e.toString()}');
    }
  }
}
