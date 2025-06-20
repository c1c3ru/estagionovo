// Mocks generated by Mockito 5.4.5 from annotations
// in student_supervisor_app/test/features/auth/bloc/auth_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:gestao_de_estagio/core/enums/user_role.dart' as _i10;
import 'package:gestao_de_estagio/core/errors/app_exceptions.dart' as _i5;
import 'package:gestao_de_estagio/domain/entities/user_entity.dart' as _i6;
import 'package:gestao_de_estagio/domain/usecases/auth/get_auth_state_changes_usecase.dart'
    as _i13;
import 'package:gestao_de_estagio/domain/usecases/auth/get_current_user_usecase.dart'
    as _i3;
import 'package:gestao_de_estagio/domain/usecases/auth/login_usecase.dart'
    as _i7;
import 'package:gestao_de_estagio/domain/usecases/auth/logout_usecase.dart'
    as _i8;
import 'package:gestao_de_estagio/domain/usecases/auth/register_usecase.dart'
    as _i9;
import 'package:gestao_de_estagio/domain/usecases/auth/reset_password_usecase.dart'
    as _i11;
import 'package:gestao_de_estagio/domain/usecases/auth/update_profile_usecase.dart'
    as _i12;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetCurrentUserUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCurrentUserUsecase extends _i1.Mock
    implements _i3.GetCurrentUserUsecase {
  MockGetCurrentUserUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity?>> call() =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity?>>.value(
                _FakeEither_0<_i5.AppFailure, _i6.UserEntity?>(
          this,
          Invocation.method(
            #call,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity?>>);
}

/// A class which mocks [LoginUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUsecase extends _i1.Mock implements _i7.LoginUsecase {
  MockLoginUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>> call({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>>.value(
                _FakeEither_0<_i5.AppFailure, _i6.UserEntity>(
          this,
          Invocation.method(
            #call,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>>);
}

/// A class which mocks [LogoutUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogoutUsecase extends _i1.Mock implements _i8.LogoutUsecase {
  MockLogoutUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, void>> call() => (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.AppFailure, void>>.value(
            _FakeEither_0<_i5.AppFailure, void>(
          this,
          Invocation.method(
            #call,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, void>>);
}

/// A class which mocks [RegisterUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegisterUsecase extends _i1.Mock implements _i9.RegisterUsecase {
  MockRegisterUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>> call({
    required String? email,
    required String? password,
    required String? fullName,
    required _i10.UserRole? role,
    String? registration,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {
            #email: email,
            #password: password,
            #fullName: fullName,
            #role: role,
            #registration: registration,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>>.value(
                _FakeEither_0<_i5.AppFailure, _i6.UserEntity>(
          this,
          Invocation.method(
            #call,
            [],
            {
              #email: email,
              #password: password,
              #fullName: fullName,
              #role: role,
              #registration: registration,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>>);
}

/// A class which mocks [ResetPasswordUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockResetPasswordUsecase extends _i1.Mock
    implements _i11.ResetPasswordUsecase {
  MockResetPasswordUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, void>> call({required String? email}) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {#email: email},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.AppFailure, void>>.value(
            _FakeEither_0<_i5.AppFailure, void>(
          this,
          Invocation.method(
            #call,
            [],
            {#email: email},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, void>>);
}

/// A class which mocks [UpdateProfileUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockUpdateProfileUsecase extends _i1.Mock
    implements _i12.UpdateProfileUsecase {
  MockUpdateProfileUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>> call({
    required String? userId,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePictureUrl,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
          {
            #userId: userId,
            #fullName: fullName,
            #email: email,
            #password: password,
            #phoneNumber: phoneNumber,
            #profilePictureUrl: profilePictureUrl,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>>.value(
                _FakeEither_0<_i5.AppFailure, _i6.UserEntity>(
          this,
          Invocation.method(
            #call,
            [],
            {
              #userId: userId,
              #fullName: fullName,
              #email: email,
              #password: password,
              #phoneNumber: phoneNumber,
              #profilePictureUrl: profilePictureUrl,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i6.UserEntity>>);
}

/// A class which mocks [GetAuthStateChangesUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAuthStateChangesUsecase extends _i1.Mock
    implements _i13.GetAuthStateChangesUsecase {
  MockGetAuthStateChangesUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i6.UserEntity?> call() => (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
        ),
        returnValue: _i4.Stream<_i6.UserEntity?>.empty(),
      ) as _i4.Stream<_i6.UserEntity?>);
}
