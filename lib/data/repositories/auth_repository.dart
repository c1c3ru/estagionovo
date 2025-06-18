import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/supabase/auth_datasource.dart';
import '../datasources/local/preferences_manager.dart';
import '../models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/enums/user_role.dart';

class AuthRepository implements IAuthRepository {
  final AuthDatasource _authDatasource;
  final PreferencesManager _preferencesManager;

  AuthRepository({
    required AuthDatasource authDatasource,
    required PreferencesManager preferencesManager,
  })  : _authDatasource = authDatasource,
        _preferencesManager = preferencesManager;

  @override
  Stream<UserEntity?> get authStateChanges => _authDatasource.authStateChanges
      .map((user) => user != null ? UserModel.fromJson(user).toEntity() : null);

  @override
  Future<Either<AppFailure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await _authDatasource.getCurrentUser();
      if (userModel != null) {
        // Cache user data locally
        await _preferencesManager.saveUserData(userModel.toJson());
        return Right(userModel.toEntity());
      }

      // Try to get from local cache if network fails
      final cachedUserData = _preferencesManager.getUserData();
      if (cachedUserData != null) {
        final userModel = UserModel.fromJson(cachedUserData);
        return Right(userModel.toEntity());
      }

      return Left(AuthFailure('Usuário não encontrado'));
    } catch (e) {
      // Fallback to cached data
      final cachedUserData = _preferencesManager.getUserData();
      if (cachedUserData != null) {
        final userModel = UserModel.fromJson(cachedUserData);
        return Right(userModel.toEntity());
      }
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _authDatasource.login(email, password);
      await _preferencesManager.saveUserData(userModel.toJson());
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final userModel =
          await _authDatasource.register(email, password, fullName, role.name);
      await _preferencesManager.saveUserData(userModel.toJson());
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> logout() async {
    try {
      await _authDatasource.logout();
      await _preferencesManager.removeUserData();
      await _preferencesManager.removeUserToken();
      return const Right(null);
    } catch (e) {
      // Even if network logout fails, clear local data
      await _preferencesManager.removeUserData();
      await _preferencesManager.removeUserToken();
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> resetPassword({
    required String email,
  }) async {
    try {
      await _authDatasource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    try {
      final user = await _authDatasource.updateProfile(
        userId: userId,
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        profilePictureUrl: profilePictureUrl,
      );
      return Right(UserModel.fromJson(user).toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
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
}
