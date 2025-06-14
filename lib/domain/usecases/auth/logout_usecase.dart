import '../../repositories/i_auth_repository.dart';

class LogoutUsecase {
  final IAuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  Future<void> call() async {
    await _authRepository.logout();
  }
}

