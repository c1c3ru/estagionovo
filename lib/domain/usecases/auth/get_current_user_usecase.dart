import '../../repositories/i_auth_repository.dart';
import '../../entities/user_entity.dart';

class GetCurrentUserUsecase {
  final IAuthRepository _authRepository;

  GetCurrentUserUsecase(this._authRepository);

  Future<UserEntity?> call() async {
    return await _authRepository.getCurrentUser();
  }
}

