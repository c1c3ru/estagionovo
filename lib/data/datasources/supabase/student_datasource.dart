import 'package:supabase_flutter/supabase_flutter.dart';

class StudentDatasource {
  final SupabaseClient _supabaseClient;

  StudentDatasource(this._supabaseClient);

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    try {
      final response = await _supabaseClient
          .from('students')
          .select('*, users(*)')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erro ao buscar estudantes: $e');
    }
  }

  Future<Map<String, dynamic>?> getStudentById(String id) async {
    try {
      final response = await _supabaseClient
          .from('students')
          .select('*, users(*)')
          .eq('id', id)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Erro ao buscar estudante: $e');
    }
  }

  Future<Map<String, dynamic>?> getStudentByUserId(String userId) async {
    try {
      final response = await _supabaseClient
          .from('students')
          .select('*, users(*)')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Erro ao buscar estudante por usuário: $e');
    }
  }

  Future<Map<String, dynamic>> createStudent(Map<String, dynamic> studentData) async {
    try {
      final response = await _supabaseClient
          .from('students')
          .insert(studentData)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Erro ao criar estudante: $e');
    }
  }

  Future<Map<String, dynamic>> updateStudent(String id, Map<String, dynamic> studentData) async {
    try {
      final response = await _supabaseClient
          .from('students')
          .update(studentData)
          .eq('id', id)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Erro ao atualizar estudante: $e');
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _supabaseClient
          .from('students')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir estudante: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsBySupervisor(String supervisorId) async {
    try {
      final response = await _supabaseClient
          .from('students')
          .select('*, users(*)')
          .eq('supervisor_id', supervisorId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erro ao buscar estudantes do supervisor: $e');
    }
  }
}

