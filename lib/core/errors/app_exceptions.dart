// lib/core/errors/app_exceptions.dart
import 'package:equatable/equatable.dart';

abstract class AppFailure extends Equatable {
  final String message;
  final dynamic originalException; // Opcional, para rastrear a exceção original

  const AppFailure({required this.message, this.originalException});

  @override
  List<Object?> get props => [message, originalException];
}

// Falha geral do servidor ou da fonte de dados
class ServerFailure extends AppFailure {
  const ServerFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}

// Falha específica de autenticação
class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}

// Falha de validação (ex: entrada do utilizador inválida)
class ValidationFailure extends AppFailure {
  const ValidationFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}

// Falha de cache (se você usar cache local)
class CacheFailure extends AppFailure {
  const CacheFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}

// Falha quando um recurso não é encontrado
class NotFoundFailure extends AppFailure {
  const NotFoundFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}

// Falha de permissão
class PermissionFailure extends AppFailure {
  const PermissionFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}

// Para exceções específicas do Supabase que não são AuthException
class SupabaseServerFailure extends ServerFailure {
  const SupabaseServerFailure({required String message, dynamic originalException})
      : super(message: message, originalException: originalException);
}
