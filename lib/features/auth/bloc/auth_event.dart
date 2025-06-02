// lib/features/auth/presentation/bloc/auth_event.dart
import 'package:equatable/equatable.dart';
import '../../../../core/enums/user_role.dart'; // Ajuste o caminho se o UserRole estiver em core/enums

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento disparado ao tentar fazer login.
class LoginSubmittedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmittedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento disparado ao tentar registar um novo utilizador.
class RegisterSubmittedEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final UserRole role;

  const RegisterSubmittedEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, fullName, role];
}

/// Evento disparado para enviar um email de redefinição de senha.
class PasswordResetRequestedEvent extends AuthEvent {
  final String email;

  const PasswordResetRequestedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Evento disparado para fazer logout.
class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}

/// Evento disparado para verificar o estado atual da autenticação (ex: no início da app).
class CheckAuthStatusRequestedEvent extends AuthEvent {
  const CheckAuthStatusRequestedEvent();
}

/// Evento disparado para atualizar o perfil do utilizador.
/// Pode ser melhor movido para um ProfileBloc se a lógica for complexa.
class UpdateUserProfileRequestedEvent extends AuthEvent {
  final String userId; // Necessário para saber qual utilizador atualizar
  final String? fullName;
  final String? phoneNumber;
  final String? profilePictureUrl;
  // Adicione outros campos conforme necessário

  const UpdateUserProfileRequestedEvent({
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [userId, fullName, phoneNumber, profilePictureUrl];
}

/// Evento para ouvir mudanças no estado de autenticação (ex: do stream do Supabase)
class AuthStateChangedEvent extends AuthEvent {
  final bool isAuthenticated;
  final UserEntity? user; // Usando UserEntity do domínio

  const AuthStateChangedEvent({required this.isAuthenticated, this.user});

  @override
  List<Object?> get props => [isAuthenticated, user];
}
