import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?>? get authStateChanges => null;

  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(
      String email, String password, String name, String role);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<bool> isLoggedIn();
}
