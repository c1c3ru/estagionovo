// lib/domain/usecases/auth/update_profile_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/user.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../repositories/i_auth_repository.dart';

class UpdateProfileUsecase {
  final IAuthRepository _repository;

  UpdateProfileUsecase(this._repository);

  Future<Either<AppFailure, UserEntity>> call(
    UpdateProfileParams params,
  ) async {
    // Validações podem ser adicionadas aqui, ex: verificar se o nome não está vazio se fornecido.
    // if (params.fullName != null && params.fullName!.isEmpty) {
    //   return Left(ValidationFailure('O nome completo não pode estar vazio.'));
    // }
    return await _repository.updateUserProfile(params);
  }
}
