// lib/domain/repositories/i_auth_repository.dart
import 'package:dartz/dartz.dart'; // Para Either (tratamento de erro funcional)
import '../entities/user_entity.dart';
import '../../core/errors/app_exceptions.dart'; // Supondo que você terá exceções personalizadas
import '../../data/models/enums.dart'; // Para UserRole

// Parâmetros para login
class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

// Parâmetros para registo
class RegisterParams {
  final String email;
  final String password;
  final String fullName;
  final UserRole role;

  RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });
}

// Parâmetros para atualizar perfil
class UpdateProfileParams {
  final String userId; // ID do usuário a ser atualizado
  final String? fullName;
  final String? phoneNumber;
  final String? profilePictureUrl;
  // Adicione outros campos que podem ser atualizados

  UpdateProfileParams({
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
  });
}

abstract class IAuthRepository {
  /// Faz login do utilizador com email e password.
  /// Retorna UserEntity em caso de sucesso, ou uma AppFailure em caso de erro.
  Future<Either<AppFailure, UserEntity>> login(LoginParams params);

  /// Regista um novo utilizador.
  /// Retorna UserEntity (ou um UserAuthEntity se precisar de dados específicos do auth.users)
  /// em caso de sucesso, ou uma AppFailure.
  Future<Either<AppFailure, UserEntity>> register(RegisterParams params);

  /// Envia email para redefinição de senha.
  Future<Either<AppFailure, void>> resetPassword(String email);

  /// Faz logout do utilizador atual.
  Future<Either<AppFailure, void>> logout();

  /// Obtém o utilizador atualmente autenticado.
  /// Retorna UserEntity se autenticado, ou null/AppFailure se não.
  Future<Either<AppFailure, UserEntity?>> getCurrentUser();

  /// Atualiza o perfil do utilizador.
  Future<Either<AppFailure, UserEntity>> updateUserProfile(UpdateProfileParams params);

  /// Ouve as mudanças no estado de autenticação.
  /// Emite UserEntity quando autenticado, null quando desautenticado.
  Stream<UserEntity?> get authStateChanges;
}
