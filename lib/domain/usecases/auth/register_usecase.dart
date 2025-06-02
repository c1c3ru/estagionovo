// lib/domain/usecases/auth/register_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/user.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../repositories/i_auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository _repository;

  RegisterUsecase(this._repository);

  Future<Either<AppFailure, UserEntity>> call(RegisterParams params) async {
    // Validações ou lógica de negócios podem ser adicionadas aqui.
    // Exemplo: verificar se a senha atende a critérios de complexidade.
    // if (params.password.length < 6) {
    //   return Left(ValidationFailure('A senha deve ter pelo menos 6 caracteres.'));
    // }
    return await _repository.register(params);
  }
}
