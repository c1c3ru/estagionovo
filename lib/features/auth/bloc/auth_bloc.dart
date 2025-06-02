// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart'; // Para o Either

import '../../../../core/errors/app_exceptions.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../domain/usecases/auth/register_usecase.dart';
import '../../../../domain/usecases/auth/reset_password_usecase.dart';
import '../../../../domain/usecases/auth/update_profile_usecase.dart';
import '../../../../domain/usecases/auth/get_auth_state_changes_usecase.dart';
import '../../../../domain/repositories/i_auth_repository.dart'; // Para LoginParams, RegisterParams, UpdateProfileParams
import '../../../../core/enums/user_role.dart'; // Ajuste o caminho se UserRole estiver em core/enums ou data/models/enums

import 'auth_event.dart';
import 'auth_state.dart';

// Importe o logger se for usar
// import '../../../../core/utils/logger_utils.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetAuthStateChangesUsecase _getAuthStateChangesUsecase;
  StreamSubscription<UserEntity?>? _authStateSubscription;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
    required GetAuthStateChangesUsecase getAuthStateChangesUsecase,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _logoutUsecase = logoutUsecase,
        _getCurrentUserUsecase = getCurrentUserUsecase,
        _resetPasswordUsecase = resetPasswordUsecase,
        _updateProfileUsecase = updateProfileUsecase,
        _getAuthStateChangesUsecase = getAuthStateChangesUsecase,
        super(const AuthInitial()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<RegisterSubmittedEvent>(_onRegisterSubmitted);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<PasswordResetRequestedEvent>(_onPasswordResetRequested);
    on<CheckAuthStatusRequestedEvent>(_onCheckAuthStatusRequested);
    on<UpdateUserProfileRequestedEvent>(_onUpdateUserProfileRequested);
    on<AuthStateChangedEvent>(_onAuthStateChanged);

    // Ouve as mudanças no estado de autenticação do repositório (via usecase)
    _authStateSubscription = _getAuthStateChangesUsecase.call().listen((user) {
      add(AuthStateChangedEvent(isAuthenticated: user != null, user: user));
    });
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUsecase.call(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (userEntity) => emit(AuthSuccess(user: userEntity, userRole: userEntity.role)),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registerUsecase.call(
      RegisterParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        role: event.role,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      // Após o registo, o utilizador normalmente precisa confirmar o email.
      // O UserEntity retornado aqui pode ser o utilizador antes da confirmação.
      (userEntity) => emit(const AuthRegistrationSuccess(
          message: 'Conta criada com sucesso! Verifique o seu email para confirmação.')),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logoutUsecase.call();
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()), // Após logout, o estado é não autenticado
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _resetPasswordUsecase.call(event.email);
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => emit(const AuthPasswordResetEmailSent(
          message: 'Instruções para redefinição de senha enviadas para o seu email.')),
    );
  }

  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Este evento pode não precisar emitir AuthLoading para evitar flashes na UI
    // A subscrição a authStateChanges já deve lidar com o estado inicial.
    // Mas se for chamado explicitamente (ex: pull-to-refresh de status), um loading pode ser útil.
    // emit(const AuthLoading());
    final result = await _getCurrentUserUsecase.call();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()), // Se falhar ao buscar, assume não autenticado
      (userEntity) {
        if (userEntity != null) {
          emit(AuthSuccess(user: userEntity, userRole: userEntity.role));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onUpdateUserProfileRequested(
    UpdateUserProfileRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading()); // Ou um ProfileUpdateLoading state
    final result = await _updateProfileUsecase.call(
      UpdateProfileParams(
        userId: event.userId, // O ID do utilizador é crucial
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        profilePictureUrl: event.profilePictureUrl,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)), // Ou um ProfileUpdateFailure state
      (updatedUserEntity) {
         emit(AuthProfileUpdateSuccess(updatedUser: updatedUserEntity));
         // Re-emitir AuthSuccess para atualizar qualquer UI que dependa do UserEntity principal
         emit(AuthSuccess(user: updatedUserEntity, userRole: updatedUserEntity.role));
      }
    );
  }

  void _onAuthStateChanged(
    AuthStateChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.isAuthenticated && event.user != null) {
      emit(AuthSuccess(user: event.user!, userRole: event.user!.role));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
