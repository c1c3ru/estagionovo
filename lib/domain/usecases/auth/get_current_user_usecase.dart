// lib/domain/usecases/auth/get_current_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/domain/entities/user.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../repositories/i_auth_repository.dart';

class GetCurrentUserUsecase {
  final IAuthRepository _repository;

  GetCurrentUserUsecase(this._repository);

  Future<Either<AppFailure, UserEntity?>> call() async {
    return await _repository.getCurrentUser();
  }
}
