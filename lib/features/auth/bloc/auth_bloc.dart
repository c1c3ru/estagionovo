import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/enums/user_role.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../domain/usecases/auth/reset_password_usecase.dart';
import '../../../domain/usecases/auth/update_profile_usecase.dart';
import '../../../domain/usecases/auth/get_auth_state_changes_usecase.dart';

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
  final String fullName;
  final String role;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, fullName, role];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String userId;
  final String? fullName;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? profilePictureUrl;

  const AuthUpdateProfileRequested({
    required this.userId,
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props =>
      [userId, fullName, email, password, phoneNumber, profilePictureUrl];
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

class AuthProfileUpdated extends AuthState {
  final UserEntity user;

  const AuthProfileUpdated({required this.user});

  @override
  List<Object> get props => [user];
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

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();

  @override
  List<Object?> get props => [];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final RegisterUsecase _registerUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetAuthStateChangesUsecase _getAuthStateChangesUsecase;

  AuthBloc({
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required LoginUsecase loginUsecase,
    required LogoutUsecase logoutUsecase,
    required RegisterUsecase registerUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
    required GetAuthStateChangesUsecase getAuthStateChangesUsecase,
  })  : _getCurrentUserUsecase = getCurrentUserUsecase,
        _loginUsecase = loginUsecase,
        _logoutUsecase = logoutUsecase,
        _registerUsecase = registerUsecase,
        _resetPasswordUsecase = resetPasswordUsecase,
        _updateProfileUsecase = updateProfileUsecase,
        _getAuthStateChangesUsecase = getAuthStateChangesUsecase,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthUpdateProfileRequested>(_onAuthUpdateProfileRequested);

    // Iniciar monitoramento de mudanças de estado de autenticação
    _getAuthStateChangesUsecase().listen((user) {
      if (user != null) {
        add(AuthCheckRequested());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _getCurrentUserUsecase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginUsecase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logoutUsecase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _registerUsecase(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      role: UserRole.fromString(event.role),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _resetPasswordUsecase(email: event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthPasswordResetSent()),
    );
  }

  Future<void> _onAuthUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _updateProfileUsecase(
      userId: event.userId,
      fullName: event.fullName,
      email: event.email,
      password: event.password,
      phoneNumber: event.phoneNumber,
      profilePictureUrl: event.profilePictureUrl,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
}

class _authRepository {
  static Future<void> resetPassword(String email) async {}
}
