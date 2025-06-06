// lib/core/errors/app_exceptions.dart
import 'package:equatable/equatable.dart';

enum ExceptionType { auth, server, cache, network, validation, unknown }

enum StudentStatus { active, inactive, graduated, suspended }

class AppFailure extends Equatable {
  final String message;
  final ExceptionType type;
  final String? code;
  final dynamic data;

  const AppFailure({
    required this.message,
    required this.type,
    this.code,
    this.data,
  });

  @override
  List<Object?> get props => [message, type, code, data];

  @override
  String toString() => 'AppFailure(message: $message, type: $type, code: $code)';
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(String message, {String? code, dynamic data})
      : super(
          message: message,
          type: ExceptionType.validation,
          code: code,
          data: data,
        );
}

class ServerException implements Exception {
  final String message;
  final String? code;

  const ServerException(this.message, {this.code});

  @override
  String toString() => 'ServerException: $message';
}