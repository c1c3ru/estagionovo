// lib/data/datasources/supabase/auth_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_exceptions.dart'; // Para ServerException, se necessário
// Importe seus enums se precisar deles aqui, mas geralmente a conversão de/para string é feita no repositório
// import '../../models/enums.dart';

abstract class IAuthSupabaseDatasource {
  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> registerWithEmailPassword({
    required String email,
    required String password,
    required Map<String, dynamic> data, // Para fullName, role, etc.
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail({required String email});

  User? getCurrentSupabaseUser();

  Stream<AuthState> get supabaseAuthStateChanges;

  Future<User> updateSupabaseUser({required UserAttributes attributes});
}

class AuthSupabaseDatasource implements IAuthSupabaseDatasource {
  final SupabaseClient _supabaseClient;

  AuthSupabaseDatasource(this._supabaseClient);

  @override
  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      // O repositório tratará AuthException e a converterá em AppFailure
      throw e;
    } catch (e) {
      // Para erros inesperados não AuthException
      throw ServerException('Erro inesperado durante o login: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponse> registerWithEmailPassword({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } on AuthException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException('Erro inesperado durante o registo: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException('Erro inesperado durante o logout: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      // Adicionar redirectTo se necessário:
      // redirectTo: 'io.supabase.yourproject://password-reset-callback/',
    } on AuthException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException('Erro inesperado ao enviar email de redefinição de senha: ${e.toString()}');
    }
  }

  @override
  User? getCurrentSupabaseUser() {
    try {
      return _supabaseClient.auth.currentUser;
    } catch (e) {
      // Geralmente, acessar currentUser não lança exceção, mas é bom ter um catch.
      throw ServerException('Erro ao obter utilizador atual do Supabase: ${e.toString()}');
    }
  }

  @override
  Stream<AuthState> get supabaseAuthStateChanges {
    try {
      return _supabaseClient.auth.onAuthStateChange;
    } catch (e) {
      // Lançar um erro ou retornar um stream de erro
      throw ServerException('Erro ao obter stream de mudanças de estado de autenticação: ${e.toString()}');
    }
  }

  @override
  Future<User> updateSupabaseUser({required UserAttributes attributes}) async {
    try {
      final response = await _supabaseClient.auth.updateUser(attributes);
      if (response.user == null) {
        throw const AuthException('Falha ao atualizar utilizador no Supabase: resposta sem utilizador.');
      }
      return response.user!;
    } on AuthException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException('Erro inesperado ao atualizar utilizador Supabase: ${e.toString()}');
    }
  }
}
