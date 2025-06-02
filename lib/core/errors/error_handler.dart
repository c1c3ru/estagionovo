// lib/core/errors/error_handler.dart
import 'package:flutter/material.dart'; // Para mostrar SnackBars ou Diálogos
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase_auth; // Para AuthException
import 'app_exceptions.dart';
import '../utils/logger_utils.dart'; // Para logar o erro

class ErrorHandler {
  /// Lida com uma   exceção, loga e opcionalmente mostra uma mensagem ao utilizador.
  static voidhandle(
    dynamic error, {
    StackTrace? stackTrace,
    String? userFriendlyMessage, // Mensagem para mostrar ao utilizador
    BuildContext?
        context, // Contexto para mostrar UI de erro (SnackBar, Dialog)
  }) {
    logger.e(
      userFriendlyMessage ?? 'Erro não tratado',
      error: error,
      stackTrace: stackTrace,
    );

    if (context != null && userFriendlyMessage != null) {
      _showErrorFeedback(context, userFriendlyMessage);
    }
  }

  /// Converte uma exceção genérica ou específica da fonte de dados para um AppFailure.
  static AppFailure convertToAppFailure(dynamic error,
      {String? defaultMessage}) {
    if (error is AppFailure) {
      return error;
    } else if (error is supabase_auth.AuthException) {
      return AuthenticationFailure(
          message: error.message, originalException: error);
    } else if (error is PostgrestException) {
      // Exceção do banco de dados Supabase
      return SupabaseServerFailure(
          message: error.message ?? 'Erro no servidor Supabase',
          originalException: error);
    }
    // Adicione outros tipos de exceção específicos aqui (ex: DioError, SocketException)
    else {
      return ServerFailure(
        message: defaultMessage ?? AppStrings.anErrorOccurred,
        originalException: error,
      );
    }
  }

  /// Mostra um feedback de erro ao utilizador (ex: SnackBar).
  static void _showErrorFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Retorna uma mensagem de erro amigável baseada no AppFailure.
  static String getUserFriendlyMessage(AppFailure failure) {
    // Você pode ter lógicas mais específicas aqui baseadas no tipo de AppFailure
    // ou no originalException, se necessário.
    return failure.message;
  }

  // Previne instanciação
  ErrorHandler._();
}
