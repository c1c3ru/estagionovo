import '../../repositories/i_auth_repository.dart';
import '../../entities/user_entity.dart';

class LoginUsecase {
  final IAuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  Future<UserEntity> call(String email, String password) async {
    if (email.isEmpty) {
      throw Exception('E-mail é obrigatório');
    }
    
    if (password.isEmpty) {
      throw Exception('Senha é obrigatória');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('E-mail inválido');
    }
    
    return await _authRepository.login(email, password);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

