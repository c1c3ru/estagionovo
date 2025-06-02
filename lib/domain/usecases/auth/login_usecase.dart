// lib/domain/usecases/auth/login_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/user.dart';
import '../../../core/errors/app_exceptions.dart'; // Supondo que você terá exceções personalizadas
import '../../repositories/i_auth_repository.dart';

class LoginUsecase {
  final IAuthRepository _repository;

  LoginUsecase(this._repository);

  Future<Either<AppFailure, UserEntity>> call(LoginParams params) async {
    // Aqui você poderia adicionar validações de parâmetros ou lógica de negócios
    // antes de chamar o repositório, se necessário.
    // Por exemplo:
    // if (params.email.isEmpty || params.password.isEmpty) {
    //   return Left(ValidationFailure('Email e senha não podem estar vazios.'));
    // }
    return await _repository.login(params);
  }
}
