abstract class AppFailure implements Exception {
  final String message;
  final dynamic originalException;

  AppFailure({required this.message, this.originalException});
}

class AuthenticationFailure extends AppFailure {
  AuthenticationFailure({required super.message, super.originalException});
}

class SupabaseServerFailure extends AppFailure {
  SupabaseServerFailure({required super.message, super.originalException});
}

class ServerFailure extends AppFailure {
  ServerFailure({required super.message, super.originalException});
}

class NotFoundFailure extends AppFailure {
  NotFoundFailure({required super.message, super.originalException});
}

class ValidationFailure extends AppFailure {
  ValidationFailure({required super.message, super.originalException});
}

class NetworkFailure extends AppFailure {
  NetworkFailure({required super.message, super.originalException});
}
