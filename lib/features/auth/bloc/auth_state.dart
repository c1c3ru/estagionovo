// lib/features/auth/presentation/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:student_supervisor_app/core/enums/user_role.dart';
import '../../../../domain/entities/user_entity.dart'; // Importa UserEntity do domínio

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial, antes de qualquer ação de autenticação.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado enquanto uma operação de autenticação está em progresso.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado de sucesso na autenticação (login ou verificação de status).
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

/// Estado quando o utilizador não está autenticado.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de sucesso no registo (geralmente leva a um passo de confirmação de email).
class AuthRegistrationSuccess extends AuthState {
  final String message;
  // Pode incluir o UserEntity se o registo retornar os dados do utilizador criado.
  // final UserEntity? user;

  const AuthRegistrationSuccess({required this.message /*, this.user */});

  @override
  List<Object?> get props => [message];
}

/// Estado de sucesso no envio de email de redefinição de senha.
class AuthPasswordResetEmailSent extends AuthState {
  final String message;

  const AuthPasswordResetEmailSent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de falha em qualquer operação de autenticação.
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Estado de sucesso na atualização do perfil (opcional, pode ser tratado por um ProfileBloc)
class AuthProfileUpdateSuccess extends AuthState {
  final UserEntity updatedUser;
  const AuthProfileUpdateSuccess({required this.updatedUser});

  @override
  List<Object?> get props => [updatedUser];
}
