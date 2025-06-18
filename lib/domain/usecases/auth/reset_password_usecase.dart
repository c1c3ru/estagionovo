// lib/domain/usecases/auth/reset_password_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/i_auth_repository.dart';

class ResetPasswordUsecase {
  final IAuthRepository _repository;

  ResetPasswordUsecase(this._repository);

  Future<void> call(String email) async {
    // Validação do formato do email pode ser feita aqui.
    // if (!isValidEmail(email)) {
    //   return Left(ValidationFailure('Formato de email inválido.'));
    // }
    return await _repository.resetPassword(email);
  }
}
