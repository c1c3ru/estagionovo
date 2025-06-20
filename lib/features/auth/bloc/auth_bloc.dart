import 'dart:async';

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
import 'auth_event.dart';
import 'auth_state.dart';

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final RegisterUsecase _registerUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetAuthStateChangesUsecase _getAuthStateChangesUsecase;

  StreamSubscription? _authStateSubscription;

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
    // Configurar listener do stream de autenticação
    _authStateSubscription = _getAuthStateChangesUsecase().listen((userEntity) {
      if (userEntity != null) {
        add(AuthUserChanged(user: userEntity));
      } else {
        add(AuthLogoutRequested());
      }
    });

    // Registrar handlers de eventos
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> _onCheckRequested(
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

  Future<void> _onLoginRequested(
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

  Future<void> _onLogoutRequested(
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

  Future<void> _onRegisterRequested(
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

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _resetPasswordUsecase(email: event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthPasswordResetSent(
          message: 'E-mail de redefinição de senha enviado com sucesso.')),
    );
  }

  Future<void> _onUpdateProfileRequested(
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

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    }
  }
}

class _authRepository {
  static Future<void> resetPassword(String email) async {}
}
