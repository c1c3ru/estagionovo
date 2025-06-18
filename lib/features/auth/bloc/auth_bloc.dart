import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String role;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, name, role];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  String? get message => null;

  get user => null;

  // Remova o getter 'user' e 'message' se não forem necessários aqui
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggingIn extends AuthState {}

class AuthRegistering extends AuthState {}

class AuthLoggingOut extends AuthState {}

class AuthResettingPassword extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthResetPasswordSuccess extends AuthState {
  final String message;

  const AuthResetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

// Error States
class AuthLoginError extends AuthState {
  final String message;

  const AuthLoginError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthRegisterError extends AuthState {
  final String message;

  const AuthRegisterError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthLogoutError extends AuthState {
  final String message;

  const AuthLogoutError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthResetPasswordError extends AuthState {
  final String message;

  const AuthResetPasswordError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthCheckError extends AuthState {
  final String message;

  const AuthCheckError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _logoutUsecase = logoutUsecase,
        _getCurrentUserUsecase = getCurrentUserUsecase,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _getCurrentUserUsecase();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthCheckError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoggingIn());
    try {
      final user = await _loginUsecase(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthLoginError(message: e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthRegistering());
    try {
      final user = await _registerUsecase(
        event.email,
        event.password,
        event.name,
        event.role,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthRegisterError(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoggingOut());
    try {
      await _logoutUsecase();
      emit(AuthLogoutSuccess());
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthLogoutError(message: e.toString()));
      // Even if logout fails, consider user as unauthenticated
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthResettingPassword());
    try {
      await _authRepository.resetPassword(event.email);
      emit(AuthResetPasswordSuccess(
        message: 'E-mail de redefinição de senha enviado para ${event.email}',
      ));
    } catch (e) {
      emit(AuthResetPasswordError(message: e.toString()));
    }
  }
}

class _authRepository {
  static Future<void> resetPassword(String email) async {}
}
