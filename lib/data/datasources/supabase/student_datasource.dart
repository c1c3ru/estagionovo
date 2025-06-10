// lib/data/datasources/supabase/student_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_exceptions.dart'; // Para ServerException
// O StudentModel será usado no Repositório para mapeamento,
// o datasource geralmente retorna Map<String, dynamic> ou lança exceções.

abstract class IStudentSupabaseDatasource {
  /// Obtém os dados de um estudante da tabela 'students' pelo seu ID (que é o auth.uid).
  Future<Map<String, dynamic>?> getStudentDataById(String userId);

  /// Cria um novo registo de estudante na tabela 'students'.
  /// Geralmente chamado após o registo no Supabase Auth e a criação na tabela 'users'.
  Future<Map<String, dynamic>> createStudentData(
      Map<String, dynamic> studentData);

  /// Atualiza os dados de um estudante na tabela 'students'.
  Future<Map<String, dynamic>> updateStudentData(
      String userId, Map<String, dynamic> dataToUpdate);

  /// Remove os dados de um estudante da tabela 'students'.
  Future<void> deleteStudentData(String userId);

  /// Obtém uma lista de todos os estudantes (para supervisores).
  /// Pode incluir filtros.
  Future<List<Map<String, dynamic>>> getAllStudentsData({
    String? nameFilter,
    String? courseFilter,
    String? statusFilter, // Assumindo que status é uma string no DB
  });
}

class StudentSupabaseDatasource implements IStudentSupabaseDatasource {
  final SupabaseClient _supabaseClient;

  StudentSupabaseDatasource(this._supabaseClient);

  @override
  Future<Map<String, dynamic>?> getStudentDataById(String userId) async {
    try {
      final response = await _supabaseClient
          .from('students')
          .select()
          .eq('id', userId)
          .maybeSingle(); // Retorna null se não encontrar, em vez de erro

      return response; // response já é Map<String, dynamic>?
    } on PostgrestException {
      // O repositório tratará PostgrestException e a converterá em AppFailure
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao obter dados do estudante: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createStudentData(
      Map<String, dynamic> studentData) async {
    try {
      // Garante que o ID está presente nos dados a serem inseridos
      if (studentData['id'] == null) {
        throw ArgumentError(
            'O ID do estudante é obrigatório para criar o registo em students.');
      }
      final response = await _supabaseClient
          .from('students')
          .insert(studentData)
          .select()
          .single(); // Retorna o registo inserido

      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao criar dados do estudante: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateStudentData(
      String userId, Map<String, dynamic> dataToUpdate) async {
    try {
      // Garante que 'updated_at' seja atualizado, se não estiver sendo feito por trigger
      // Map<String, dynamic> dataWithTimestamp = {
      //   ...dataToUpdate,
      //   'updated_at': DateTime.now().toIso8601String(),
      // };

      final response = await _supabaseClient
          .from('students')
          .update(
              dataToUpdate) // Usar dataToUpdate diretamente se o trigger estiver ativo
          .eq('id', userId)
          .select()
          .single(); // Retorna o registo atualizado

      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao atualizar dados do estudante: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteStudentData(String userId) async {
    try {
      await _supabaseClient.from('students').delete().eq('id', userId);
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao remover dados do estudante: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllStudentsData({
    String? nameFilter,
    String? courseFilter,
    String? statusFilter,
  }) async {
    try {
      var query = _supabaseClient.from('students').select();

      if (nameFilter != null && nameFilter.isNotEmpty) {
        query = query.ilike('full_name', '%$nameFilter%');
      }
      if (courseFilter != null && courseFilter.isNotEmpty) {
        query = query.eq('course', courseFilter);
      }
      // Para o status, você precisará saber como ele está armazenado no StudentModel/DB
      // Se StudentModel tiver um campo 'status' que é um enum, e no DB é uma string:
      // if (statusFilter != null && statusFilter.isNotEmpty) {
      //    query = query.eq('status_column_name_in_db', statusFilter);
      // }
      // Se o status estiver na tabela 'users', precisaria de um JOIN ou uma query mais complexa,
      // o que geralmente é feito no repositório ou via Views/RPC no Supabase.
      // Por agora, vamos assumir que 'status' não é um filtro direto na tabela 'students'
      // ou que será tratado de forma diferente.

      final response = await query;
      return response;
    } on PostgrestException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Erro inesperado ao obter todos os estudantes: ${e.toString()}');
    }
  }
}
