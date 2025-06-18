import 'package:dartz/dartz.dart';
import 'package:student_supervisor_app/core/errors/app_exceptions.dart';
import 'package:student_supervisor_app/domain/usecases/auth/update_profile_params.dart';

import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?>? get authStateChanges => null;
  Future<Either<AppFailure, UserEntity>> updateUserProfile(
      UpdateProfileParams params);

  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(
      String email, String password, String name, String role);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<bool> isLoggedIn();
}
