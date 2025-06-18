import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

class AuthDatasource {
  final SupabaseClient _supabaseClient;

  AuthDatasource(this._supabaseClient);

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao obter usuário atual: $e');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Credenciais inválidas');
      }

      final userResponse = await _supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userResponse);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<UserModel> register(
      String email, String password, String name, String role) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Erro ao criar conta');
      }

      final userModel = UserModel(
        id: response.user!.id,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _supabaseClient.from('users').insert(userModel.toJson());

      return userModel;
    } catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Erro ao redefinir senha: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
