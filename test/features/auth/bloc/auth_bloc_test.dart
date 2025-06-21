import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_supervisor_app/core/enums/user_role.dart';
import 'package:student_supervisor_app/domain/entities/user_entity.dart';
import 'package:student_supervisor_app/domain/usecases/auth/get_auth_state_changes_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/auth/login_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/auth/logout_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/auth/register_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/auth/reset_password_usecase.dart';
import 'package:student_supervisor_app/domain/usecases/auth/update_profile_usecase.dart';
import 'package:student_supervisor_app/features/auth/bloc/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  LoginUsecase,
  RegisterUsecase,
  LogoutUsecase,
  GetCurrentUserUsecase,
  ResetPasswordUsecase,
  UpdateProfileUsecase,
  GetAuthStateChangesUsecase,
])
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockLoginUsecase mockLoginUsecase;
    late MockRegisterUsecase mockRegisterUsecase;
    late MockLogoutUsecase mockLogoutUsecase;
    late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
    late MockResetPasswordUsecase mockResetPasswordUsecase;
    late MockUpdateProfileUsecase mockUpdateProfileUsecase;
    late MockGetAuthStateChangesUsecase mockGetAuthStateChangesUsecase;

    const mockUserEntity = UserEntity(
      id: '1',
      email: 'test@test.com',
      fullName: 'Test User',
      role: UserRole.student,
    );

    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      mockRegisterUsecase = MockRegisterUsecase();
      mockLogoutUsecase = MockLogoutUsecase();
      mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
      mockResetPasswordUsecase = MockResetPasswordUsecase();
      mockUpdateProfileUsecase = MockUpdateProfileUsecase();
      mockGetAuthStateChangesUsecase = MockGetAuthStateChangesUsecase();

      // Mock o stream de autenticação
      when(mockGetAuthStateChangesUsecase())
          .thenAnswer((_) => Stream.fromIterable([]));

      authBloc = AuthBloc(
        loginUsecase: mockLoginUsecase,
        registerUsecase: mockRegisterUsecase,
        logoutUsecase: mockLogoutUsecase,
        getCurrentUserUsecase: mockGetCurrentUserUsecase,
        resetPasswordUsecase: mockResetPasswordUsecase,
        updateProfileUsecase: mockUpdateProfileUsecase,
        getAuthStateChangesUsecase: mockGetAuthStateChangesUsecase,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(mockLoginUsecase(any))
            .thenAnswer((_) async => Right(mockUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@test.com',
        password: 'password',
      )),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(user: mockUserEntity),
      ],
    );
  });
}
