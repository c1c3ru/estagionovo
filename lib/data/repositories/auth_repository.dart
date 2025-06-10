// lib/data/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:estagio/core/constants/app_failure.dart' hide AppFailure;
import 'package:estagio/core/enum/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase_auth; // Para User, AuthResponse, AuthException
import '../../core/errors/app_exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart'; // Contém LoginParams, RegisterParams, etc.
import '../datasources/supabase/auth_datasource.dart'; // A interface do datasource
// Importe o seu UserModel se precisar mapear para ele a partir do UserEntity ou vice-versa em algum ponto,
// mas aqui o foco é mapear do Supabase User para UserEntity.
// import '../models/user_model.dart' as data_user_model;

class AuthRepository implements IAuthRepository {
  final IAuthSupabaseDatasource _authDatasource;
  // Você poderia injetar um NetworkInfo aqui para verificar a conexão de rede antes de chamadas

  AuthRepository(this._authDatasource);

  // Função auxiliar para mapear Supabase User para UserEntity
  UserEntity _mapSupabaseUserToUserEntity(supabase_auth.User supabaseUser) {
    return UserEntity(
      id: supabaseUser.id,
      email: supabaseUser.email ??
          '', // Email deve ser sempre presente para um user autenticado
      // A role vem dos metadados do utilizador
      role: UserRole.fromString(
          supabaseUser.userMetadata!['role'] as String? ?? ''),
      isActive: supabaseUser.userMetadata?['is_active'] as bool? ??
          true, // Assumindo que 'is_active' está nos metadados
      // ignore: unnecessary_null_comparison
      createdAt: supabaseUser.createdAt != null
          ? DateTime.parse(supabaseUser.createdAt)
          : DateTime.now(), // Fallback, mas createdAt deve existir
      updatedAt: supabaseUser.updatedAt != null
          ? DateTime.parse(supabaseUser.updatedAt!)
          : null,
      fullName:
          '${supabaseUser.userMetadata?['full_name'] ?? ''}', // Exemplo de metadado adicional
      profilePictureUrl:
          supabaseUser.userMetadata?['profile_picture_url'] as String?,
      phoneNumber: supabaseUser.userMetadata?['phone']
          as String?, // Se você armazenar o telefone nos metadados
      // Outros metadados podem ser adicionados aqui conforme necessário
      // Se você tiver outros campos no user_metadata, adicione-os aqui
    );
  }

  @override
  Future<Either<AppFailure, UserEntity>> login(LoginParams params) async {
    try {
      final authResponse = await _authDatasource.loginWithEmailPassword(
        email: params.email,
        password: params.password,
      );
      if (authResponse.user != null) {
        return Right(_mapSupabaseUserToUserEntity(authResponse.user!));
      } else {
        // Isso não deveria acontecer se o login foi bem-sucedido sem exceção, mas é uma salvaguarda.
        return Left(AuthenticationFailure(
            message: 'Utilizador não retornado após o login.') as AppFailure);
      }
    } on supabase_auth.AuthException catch (e) {
      return Left(
          AuthenticationFailure(message: e.message, originalException: e)
              as AppFailure);
    } on ServerException catch (e) {
      // Captura ServerException do datasource
      return Left(ServerFailure(
          message: e.message,
          originalException: e.originalException) as AppFailure);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido durante o login: ${e.toString()}',
          originalException: e) as AppFailure);
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> register(RegisterParams params) async {
    try {
      final authResponse = await _authDatasource.registerWithEmailPassword(
        email: params.email,
        password: params.password,
        data: {
          'full_name': params.fullName, // Será armazenado em user_metadata
          'role': params.role.value, // Armazena o valor string do enum
          'is_active': true, // Exemplo de metadado adicional
        },
      );
      if (authResponse.user != null) {
        // Após o registo no Supabase Auth, a tabela 'users' (e 'students'/'supervisors')
        // deve ser populada. Isso geralmente é feito por triggers no DB ou
        // chamadas explícitas aqui ou no datasource.
        // O AuthRepository do PRD original fazia uma inserção na tabela 'users'.
        // Se o seu datasource de registo já lida com a criação na tabela 'users',
        // então aqui apenas mapeamos.
        // Se não, você precisaria chamar um datasource.createUserData(...) aqui.

        // Por agora, assumimos que o user_metadata está preenchido e mapeamos.
        return Right(_mapSupabaseUserToUserEntity(authResponse.user!));
      } else {
        return Left(AuthenticationFailure(
            message: 'Utilizador não retornado após o registo.') as AppFailure);
      }
    } on supabase_auth.AuthException catch (e) {
      return Left(
          AuthenticationFailure(message: e.message, originalException: e)
              as AppFailure);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message,
          originalException: e.originalException) as AppFailure);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido durante o registo: ${e.toString()}',
          originalException: e) as AppFailure);
    }
  }

  @override
  Future<Either<AppFailure, void>> logout() async {
    try {
      await _authDatasource.logout();
      return const Right(
          null); // Sucesso é representado por Right(null) para void
    } on supabase_auth.AuthException catch (e) {
      return Left(
          AuthenticationFailure(message: e.message, originalException: e)
              as AppFailure);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message,
          originalException: e.originalException) as AppFailure);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido durante o logout: ${e.toString()}',
          originalException: e) as AppFailure);
    }
  }

  @override
  Future<Either<AppFailure, void>> resetPassword(String email) async {
    try {
      await _authDatasource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on supabase_auth.AuthException catch (e) {
      return Left(
          AuthenticationFailure(message: e.message, originalException: e)
              as AppFailure);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message,
          originalException: e.originalException) as AppFailure);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido ao redefinir senha: ${e.toString()}',
          originalException: e) as AppFailure);
    }
  }

  @override
  Future<Either<AppFailure, UserEntity?>> getCurrentUser() async {
    try {
      final supabaseUser = _authDatasource.getCurrentSupabaseUser();
      if (supabaseUser != null) {
        // Aqui, você pode querer buscar dados adicionais da sua tabela 'users' ou 'profiles'
        // para enriquecer o UserEntity, se nem todos os dados estiverem no user_metadata.
        // Por exemplo, se 'is_active' vem da tabela 'users':
        // final userProfileData = await _userDatasource.getUserProfile(supabaseUser.id);
        // E então combinar os dados.

        // Por agora, mapeamos diretamente do Supabase User.
        return Right(_mapSupabaseUserToUserEntity(supabaseUser));
      } else {
        return const Right(null); // Nenhum utilizador autenticado
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message,
          originalException: e.originalException) as AppFailure);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro ao obter utilizador atual: ${e.toString()}',
          originalException: e) as AppFailure);
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> updateUserProfile(
      UpdateProfileParams params) async {
    try {
      // Prepara os atributos para o Supabase Auth.
      // Apenas 'data' (user_metadata) e 'email'/'password' podem ser atualizados via updateUser.
      // Outros campos como 'phone' podem ser parte do 'data' se você os configurou assim.
      Map<String, dynamic> metadataUpdate = {};
      if (params.fullName != null) {
        metadataUpdate['full_name'] = params.fullName;
      }
      if (params.profilePictureUrl != null) {
        // Se profile_picture_url for parte do user_metadata
        metadataUpdate['profile_picture_url'] = params.profilePictureUrl;
      }
      // Se phoneNumber for parte do user_metadata
      // if (params.phoneNumber != null) {
      //   metadataUpdate['phone'] = params.phoneNumber; // ou o nome da chave que você usa
      // }

      final attributes = supabase_auth.UserAttributes(data: metadataUpdate);
      final updatedSupabaseUser =
          await _authDatasource.updateSupabaseUser(attributes: attributes);

      // Se você também tem uma tabela 'users' ou 'profiles' para atualizar com phoneNumber ou avatarUrl
      // que não estão no user_metadata, você chamaria o datasource correspondente aqui.
      // Ex: await _userDatasource.updateUserProfileTable(params.userId, { 'phone_number': params.phoneNumber });

      return Right(_mapSupabaseUserToUserEntity(updatedSupabaseUser));
    } on supabase_auth.AuthException catch (e) {
      return Left(
          AuthenticationFailure(message: e.message, originalException: e)
              as AppFailure);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message,
          originalException: e.originalException) as AppFailure);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Erro desconhecido ao atualizar perfil: ${e.toString()}',
          originalException: e) as AppFailure);
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _authDatasource.supabaseAuthStateChanges.map((supabaseAuthState) {
      final supabaseUser = supabaseAuthState.session?.user;
      if (supabaseUser != null) {
        return _mapSupabaseUserToUserEntity(supabaseUser);
      }
      return null;
    }).handleError((error) {
      // Logar o erro e talvez emitir um estado de erro no stream se necessário,
      // mas geralmente o stream de auth simplesmente para de emitir ou emite null.
      // print('Erro no stream authStateChanges: $error');
      // Não é comum retornar um AppFailure diretamente num Stream assim,
      // o BLoC que consome o stream trataria o erro do stream.
      // Para simplificar, apenas deixamos o erro propagar ou retornamos null.
      return null;
    });
  }
}
