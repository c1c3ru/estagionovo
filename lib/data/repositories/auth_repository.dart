import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/supabase/auth_datasource.dart';
import '../datasources/local/preferences_manager.dart';
import '../models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/usecases/auth/update_profile_params.dart';

class AuthRepository implements IAuthRepository {
  final AuthDatasource _authDatasource;
  final PreferencesManager _preferencesManager;

  AuthRepository({
    required AuthDatasource authDatasource,
    required PreferencesManager preferencesManager,
  })  : _authDatasource = authDatasource,
        _preferencesManager = preferencesManager;

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userModel = await _authDatasource.getCurrentUser();
      if (userModel != null) {
        // Cache user data locally
        await _preferencesManager.saveUserData(userModel.toJson());
        return userModel.toEntity();
      }

      // Try to get from local cache if network fails
      final cachedUserData = _preferencesManager.getUserData();
      if (cachedUserData != null) {
        final userModel = UserModel.fromJson(cachedUserData);
        return userModel.toEntity();
      }

      return null;
    } catch (e) {
      // Fallback to cached data
      final cachedUserData = _preferencesManager.getUserData();
      if (cachedUserData != null) {
        final userModel = UserModel.fromJson(cachedUserData);
        return userModel.toEntity();
      }
      rethrow;
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final userModel = await _authDatasource.login(email, password);

      // Cache user data locally
      await _preferencesManager.saveUserData(userModel.toJson());

      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> register(
      String email, String password, String name, String role) async {
    try {
      final userModel =
          await _authDatasource.register(email, password, name, role);

      // Cache user data locally
      await _preferencesManager.saveUserData(userModel.toJson());

      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authDatasource.logout();

      // Clear local data
      await _preferencesManager.removeUserData();
      await _preferencesManager.removeUserToken();
    } catch (e) {
      // Even if network logout fails, clear local data
      await _preferencesManager.removeUserData();
      await _preferencesManager.removeUserToken();
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _authDatasource.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _authDatasource.isLoggedIn();
    } catch (e) {
      // Fallback to local check
      final cachedUserData = _preferencesManager.getUserData();
      return cachedUserData != null;
    }
  }

  @override
  Stream<UserEntity?>? get authStateChanges => null;

  @override
  Future<Either<AppFailure, UserEntity>> updateUserProfile(
      UpdateProfileParams params) async {
    try {
      // Implementação temporária - retorna erro
      return Left(const ServerFailure(message: 'Método não implementado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
