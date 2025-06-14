import 'package:supabase_flutter/supabase_flutter.dart';

class SupervisorDatasource {
  final SupabaseClient _supabaseClient;

  SupervisorDatasource(this._supabaseClient);

  Future<List<Map<String, dynamic>>> getAllSupervisors() async {
    try {
      final response = await _supabaseClient
          .from('supervisors')
          .select('*, users(*)')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erro ao buscar supervisores: $e');
    }
  }

  Future<Map<String, dynamic>?> getSupervisorById(String id) async {
    try {
      final response = await _supabaseClient
          .from('supervisors')
          .select('*, users(*)')
          .eq('id', id)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Erro ao buscar supervisor: $e');
    }
  }

  Future<Map<String, dynamic>?> getSupervisorByUserId(String userId) async {
    try {
      final response = await _supabaseClient
          .from('supervisors')
          .select('*, users(*)')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Erro ao buscar supervisor por usuário: $e');
    }
  }

  Future<Map<String, dynamic>> createSupervisor(Map<String, dynamic> supervisorData) async {
    try {
      final response = await _supabaseClient
          .from('supervisors')
          .insert(supervisorData)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Erro ao criar supervisor: $e');
    }
  }

  Future<Map<String, dynamic>> updateSupervisor(String id, Map<String, dynamic> supervisorData) async {
    try {
      final response = await _supabaseClient
          .from('supervisors')
          .update(supervisorData)
          .eq('id', id)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Erro ao atualizar supervisor: $e');
    }
  }

  Future<void> deleteSupervisor(String id) async {
    try {
      await _supabaseClient
          .from('supervisors')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir supervisor: $e');
    }
  }
}

