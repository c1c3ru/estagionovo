import '../../repositories/i_auth_repository.dart';
import '../../entities/user_entity.dart';

class RegisterUsecase {
  final IAuthRepository _authRepository;

  RegisterUsecase(this._authRepository);

  Future<UserEntity> call(String email, String password, String name, String role) async {
    if (email.isEmpty) {
      throw Exception('E-mail é obrigatório');
    }
    
    if (password.isEmpty) {
      throw Exception('Senha é obrigatória');
    }
    
    if (name.isEmpty) {
      throw Exception('Nome é obrigatório');
    }
    
    if (role.isEmpty) {
      throw Exception('Tipo de usuário é obrigatório');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('E-mail inválido');
    }
    
    if (password.length < 6) {
      throw Exception('Senha deve ter pelo menos 6 caracteres');
    }
    
    if (name.length < 2) {
      throw Exception('Nome deve ter pelo menos 2 caracteres');
    }
    
    return await _authRepository.register(email, password, name, role);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

