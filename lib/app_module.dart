// lib/app_module.dart
import 'package:estagio/core/enum/user_role.dart';
import 'package:estagio/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart'; // ADICIONADO PARA WIDGETS
import 'package:flutter_bloc/flutter_bloc.dart'; // ADICIONADO PARA BLOCBUILDER
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import 'core/guards/auth_guard.dart';
import 'core/guards/role_guard.dart';

// --- CAMADA DE DADOS ---
// Datasources (Supabase)
import 'data/datasources/supabase/auth_datasource.dart';
import 'data/datasources/supabase/student_datasource.dart';
import 'data/datasources/supabase/supervisor_datasource.dart';
import 'data/datasources/supabase/time_log_datasource.dart';
import 'data/datasources/supabase/contract_datasource.dart';
// Datasources (Local)
import 'data/datasources/local/preferences_manager.dart';
import 'data/datasources/local/cache_manager.dart';

// Repositories (Implementações)
import 'data/repositories/auth_repository.dart';
import 'data/repositories/student_repository.dart';
import 'data/repositories/supervisor_repository.dart';
import 'data/repositories/time_log_repository.dart';
import 'data/repositories/contract_repository.dart';

// --- CAMADA DE DOMÍNIO ---
// Repository Interfaces
import 'domain/repositories/i_auth_repository.dart';
import 'domain/repositories/i_student_repository.dart';
import 'domain/repositories/i_supervisor_repository.dart';
import 'domain/repositories/i_time_log_repository.dart';
import 'domain/repositories/i_contract_repository.dart';

// Usecases (Auth)
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';
import 'domain/usecases/auth/reset_password_usecase.dart';
import 'domain/usecases/auth/update_profile_usecase.dart';
import 'domain/usecases/auth/get_auth_state_changes_usecase.dart';

// Modules
import 'features/auth/auth_module.dart';
import 'features/student/student_module.dart';
import 'features/supervisor/supervisor_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [];

  @override
  void binds(Injector i) {
    // --- CORE ---
    // i.add<AuthGuard>(() => AuthGuard()); // Instanciado diretamente nas rotas
    // i.addFactoryParam<RoleGuard, List<UserRole>, void>((roles, _) => RoleGuard(roles));

    // --- CAMADA DE DADOS ---
    i.addSingleton<SupabaseClient>(() => Supabase.instance.client);
    i.addSingleton<IAuthSupabaseDatasource>(
        () => AuthSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<IStudentSupabaseDatasource>(
        () => StudentSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<ISupervisorSupabaseDatasource>(
        () => SupervisorSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<ITimeLogSupabaseDatasource>(
        () => TimeLogSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<IContractSupabaseDatasource>(
        () => ContractSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<IPreferencesManager>(() => PreferencesManager());
    i.addSingleton<ICacheManager>(() => InMemoryCacheManager());

    // Repositories
    i.addSingleton<IAuthRepository>(
        () => AuthRepository(i.get<IAuthSupabaseDatasource>()));
    i.addSingleton<IStudentRepository>(() => StudentRepository(
        i.get<IStudentSupabaseDatasource>(),
        i.get<ITimeLogSupabaseDatasource>()));
    i.addSingleton<ISupervisorRepository>(() => SupervisorRepository(
        i.get<ISupervisorSupabaseDatasource>(),
        i.get<IStudentSupabaseDatasource>(),
        i.get<ITimeLogSupabaseDatasource>(),
        i.get<IContractSupabaseDatasource>()));
    i.addSingleton<ITimeLogRepository>(
        () => TimeLogRepository(i.get<ITimeLogSupabaseDatasource>()));
    i.addSingleton<IContractRepository>(
        () => ContractRepository(i.get<IContractSupabaseDatasource>()));

    // --- CAMADA DE DOMÍNIO ---
    // Usecases (Auth)
    i.add<LoginUsecase>(() => LoginUsecase(i.get<IAuthRepository>()));
    i.add<RegisterUsecase>(() => RegisterUsecase(i.get<IAuthRepository>()));
    i.add<LogoutUsecase>(() => LogoutUsecase(i.get<IAuthRepository>()));
    i.add<GetCurrentUserUsecase>(
        () => GetCurrentUserUsecase(i.get<IAuthRepository>()));
    i.add<ResetPasswordUsecase>(
        () => ResetPasswordUsecase(i.get<IAuthRepository>()));
    i.add<UpdateProfileUsecase>(
        () => UpdateProfileUsecase(i.get<IAuthRepository>()));
    i.add<GetAuthStateChangesUsecase>(
        () => GetAuthStateChangesUsecase(i.get<IAuthRepository>()));

    // --- FEATURES ---
    // BLoCs (AuthBloc é global)
    i.addSingleton<AuthBloc>(() => AuthBloc(
          loginUsecase: i.get<LoginUsecase>(),
          registerUsecase: i.get<RegisterUsecase>(),
          logoutUsecase: i.get<LogoutUsecase>(),
          getCurrentUserUsecase: i.get<GetCurrentUserUsecase>(),
          resetPasswordUsecase: i.get<ResetPasswordUsecase>(),
          updateProfileUsecase: i.get<UpdateProfileUsecase>(),
          getAuthStateChangesUsecase: i.get<GetAuthStateChangesUsecase>(),
        ));
  }

  @override
  void routes(RouteManager r) {
    r.module('/auth', module: AuthModule());

    r.module(
      '/student',
      module: StudentModule(),
      guards: [
        AuthGuard(),
        RoleGuard([UserRole.student]), // UserRole importado de core/enums
      ],
    );

    r.module(
      '/supervisor',
      module: SupervisorModule(),
      guards: [
        AuthGuard(),
        RoleGuard([
          UserRole.supervisor,
          UserRole.admin
        ]), // UserRole importado de core/enums
      ],
    );

    r.child(
      '/',
      child: (context) => const InitialRedirectWidget(),
      guards: [AuthGuard()],
    );
  }
}

// Widget simples para redirecionamento inicial baseado no estado de autenticação
class InitialRedirectWidget extends StatelessWidget {
  const InitialRedirectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // O AuthBloc deve ser obtido do contexto se o AppWidget o provê via BlocProvider.
    // Se o AppWidget ainda não foi construído, Modular.get pode ser usado, mas
    // é melhor prática usar context.watch ou context.read se estiver dentro de um widget
    // que já tem o BlocProvider acima dele na árvore.
    // Como este widget é parte do AppModule e pode ser a primeira coisa renderizada,
    // Modular.get é uma opção aqui, assumindo que o AuthBloc já foi 'bindado'.
    final authBloc = Modular.get<AuthBloc>();

    return BlocBuilder<AuthBloc, auth_feature_state.AuthState>(
      // Usando o alias para o AuthState da feature
      bloc: authBloc,
      builder: (context, state) {
        if (state is auth_feature_state.Authenticated) {
          // Usando o alias
          // Utilizador autenticado, redireciona com base no papel
          switch (state.userRole) {
            // userRole do estado AuthSuccess
            case UserRole.student:
              Modular.to.replaceAllNamed('/student/');
              break;
            case UserRole.supervisor:
              Modular.to.replaceAllNamed('/supervisor/');
              break;
            case UserRole.admin:
              Modular.to.replaceAllNamed(
                  '/supervisor/'); // Admin pode ir para supervisor por agora
              break;
            default:
              Modular.to.replaceAllNamed('/auth/login');
          }
        } else if (state is auth_feature_state.Unauthenticated ||
            state is auth_feature_state.AuthFailure) {
          // Usando o alias
          Modular.to.replaceAllNamed('/auth/login');
        }
        // Enquanto AuthInitial ou AuthLoading, mostra um indicador
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
