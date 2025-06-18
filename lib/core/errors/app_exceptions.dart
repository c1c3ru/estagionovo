import 'package:equatable/equatable.dart';

enum ExceptionType { auth, server, cache, network, validation, unknown }

enum StudentStatus {
  active,
  inactive,
  graduated,
  suspended,
  pending,
  completed,
  terminated,
  unknown;

  String get displayName {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}

// Use apenas UMA definição de AppFailure:
abstract class AppFailure implements Exception {
  final String message;
  final dynamic originalException;

  const AppFailure({required this.message, this.originalException});
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(String message, {super.originalException})
      : super(message: message);
}

class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure(
      {required super.message, super.originalException});
}

class SupabaseServerFailure extends AppFailure {
  const SupabaseServerFailure(
      {required super.message, super.originalException});
}

class ServerFailure extends AppFailure {
  const ServerFailure({required super.message, super.originalException});
}

class ServerException implements Exception {
  final String message;
  final String? code;

  const ServerException(this.message, {this.code});

  get originalException => null;

  @override
  String toString() => 'ServerException: $message';
}
