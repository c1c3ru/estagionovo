import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../core/enums/user_role.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../models/user_model.dart';

class AuthDatasource {
  final SupabaseClient _supabaseClient;

  AuthDatasource(this._supabaseClient);

  Stream<Map<String, dynamic>?> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange.map((event) {
        final session = event.session;
        if (session == null) return null;
        return {
          'id': session.user.id,
          'email': session.user.email,
          'role': session.user.userMetadata?['role'] ?? 'student',
          'fullName': session.user.userMetadata?['full_name'],
          'phoneNumber': session.user.phone,
          'profilePictureUrl': session.user.userMetadata?['avatar_url'],
          'createdAt': DateTime.parse(session.user.createdAt).toIso8601String(),
          'updatedAt': session.user.updatedAt != null
              ? DateTime.parse(session.user.updatedAt!).toIso8601String()
              : null,
        };
      });

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role.toString(),
        },
      );

      if (response.user == null) {
        throw AuthException('Erro ao registrar usuário');
      }

      return {
        'id': response.user!.id,
        'email': response.user!.email,
        'role': role.toString(),
        'fullName': fullName,
        'createdAt': DateTime.parse(response.user!.createdAt).toIso8601String(),
        'updatedAt': response.user!.updatedAt != null
            ? DateTime.parse(response.user!.updatedAt!).toIso8601String()
            : null,
      };
    } catch (e) {
      throw AuthException('Erro ao registrar usuário: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Erro ao fazer login');
      }

      return {
        'id': response.user!.id,
        'email': response.user!.email,
        'role': response.user!.userMetadata?['role'] ?? 'student',
        'fullName': response.user!.userMetadata?['full_name'],
        'phoneNumber': response.user!.phone,
        'profilePictureUrl': response.user!.userMetadata?['avatar_url'],
        'createdAt': DateTime.parse(response.user!.createdAt).toIso8601String(),
        'updatedAt': response.user!.updatedAt != null
            ? DateTime.parse(response.user!.updatedAt!).toIso8601String()
            : null,
      };
    } catch (e) {
      throw AuthException('Erro ao fazer login: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw AuthException('Erro ao fazer logout: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      return {
        'id': user.id,
        'email': user.email,
        'role': user.userMetadata?['role'] ?? 'student',
        'fullName': user.userMetadata?['full_name'],
        'phoneNumber': user.phone,
        'profilePictureUrl': user.userMetadata?['avatar_url'],
        'createdAt': DateTime.parse(user.createdAt).toIso8601String(),
        'updatedAt': user.updatedAt != null
            ? DateTime.parse(user.updatedAt!).toIso8601String()
            : null,
      };
    } catch (e) {
      throw AuthException('Erro ao buscar usuário atual: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback/',
      );
    } catch (e) {
      throw AuthException('Erro ao resetar senha: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthException('Usuário não autenticado');
      }

      if (user.id != userId) {
        throw AuthException('Não é possível atualizar outro usuário');
      }

      final updates = <String, dynamic>{};

      if (email != null && email.isNotEmpty) {
        await _supabaseClient.auth.updateUser(
          UserAttributes(
            email: email,
          ),
        );
      }

      if (password != null && password.isNotEmpty) {
        await _supabaseClient.auth.updateUser(
          UserAttributes(
            password: password,
          ),
        );
      }

      if (fullName != null && fullName.isNotEmpty) {
        updates['full_name'] = fullName;
      }

      if (phoneNumber != null) {
        updates['phone'] = phoneNumber;
      }

      if (profilePictureUrl != null) {
        updates['avatar_url'] = profilePictureUrl;
      }

      if (updates.isNotEmpty) {
        await _supabaseClient.auth.updateUser(
          UserAttributes(
            data: updates,
          ),
        );
      }

      final updatedUser = await getCurrentUser();
      if (updatedUser == null) {
        throw AuthException('Erro ao atualizar perfil');
      }

      return updatedUser;
    } catch (e) {
      throw AuthException('Erro ao atualizar perfil: $e');
    }
  }
}
