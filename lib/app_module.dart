// lib/app_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core (Guards, Enums não são injetados, mas podem ser importados por outros módulos)
import 'core/guards/auth_guard.dart';
import 'core/guards/role_guard.dart';
import 'core/enums/user_role.dart'; // Para o RoleGuard

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
// Usecases (Student) - Registados no StudentModule
// Usecases (Supervisor) - Registados no SupervisorModule
// Usecases (Contract) - Registados nos módulos que os usam ou aqui se forem muito globais

// --- FEATURES ---
// BLoCs (AuthBloc é global)
import 'features/auth/presentation/bloc/auth_bloc.dart';
// Modules
import 'features/auth/auth_module.dart';
import 'features/student/student_module.dart';
import 'features/supervisor/supervisor_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
      // Se você criar um CoreModule com binds comuns (ex: HttpClient), importe-o.
      // CoreModule(),
    ];

  @override
  void binds(Injector i) {
    // --- CORE ---
    // Guards (são instanciados diretamente nas rotas, mas podem ser registados se tiverem dependências)
    // i.add<AuthGuard>(() => AuthGuard());
    // i.addFactoryParam<RoleGuard, List<UserRole>, void>((roles, _) => RoleGuard(roles));

    // --- CAMADA DE DADOS ---
    // Supabase Client (SINGLETON)
    i.addSingleton<SupabaseClient>(() => Supabase.instance.client);

    // Datasources (Supabase) - Singletons
    i.addSingleton<IAuthSupabaseDatasource>(() => AuthSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<IStudentSupabaseDatasource>(() => StudentSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<ISupervisorSupabaseDatasource>(() => SupervisorSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<ITimeLogSupabaseDatasource>(() => TimeLogSupabaseDatasource(i.get<SupabaseClient>()));
    i.addSingleton<IContractSupabaseDatasource>(() => ContractSupabaseDatasource(i.get<SupabaseClient>()));

    // Datasources (Local) - Singletons
    i.addSingleton<IPreferencesManager>(() => PreferencesManager());
    i.addSingleton<ICacheManager>(() => InMemoryCacheManager()); // Ou outra implementação

    // Repositories (Implementações) - Singletons
    i.addSingleton<IAuthRepository>(() => AuthRepository(i.get<IAuthSupabaseDatasource>()));
    i.addSingleton<IStudentRepository>(() => StudentRepository(
        i.get<IStudentSupabaseDatasource>(), i.get<ITimeLogSupabaseDatasource>()));
    i.addSingleton<ISupervisorRepository>(() => SupervisorRepository(
        i.get<ISupervisorSupabaseDatasource>(),
        i.get<IStudentSupabaseDatasource>(),
        i.get<ITimeLogSupabaseDatasource>(),
        i.get<IContractSupabaseDatasource>()));
    i.addSingleton<ITimeLogRepository>(() => TimeLogRepository(i.get<ITimeLogSupabaseDatasource>()));
    i.addSingleton<IContractRepository>(() => ContractRepository(i.get<IContractSupabaseDatasource>()));

    // --- CAMADA DE DOMÍNIO ---
    // Usecases (Auth) - Factories (geralmente sem estado)
    i.add<LoginUsecase>(() => LoginUsecase(i.get<IAuthRepository>()));
    i.add<RegisterUsecase>(() => RegisterUsecase(i.get<IAuthRepository>()));
    i.add<LogoutUsecase>(() => LogoutUsecase(i.get<IAuthRepository>()));
    i.add<GetCurrentUserUsecase>(() => GetCurrentUserUsecase(i.get<IAuthRepository>()));
    i.add<ResetPasswordUsecase>(() => ResetPasswordUsecase(i.get<IAuthRepository>()));
    i.add<UpdateProfileUsecase>(() => UpdateProfileUsecase(i.get<IAuthRepository>()));
    i.add<GetAuthStateChangesUsecase>(() => GetAuthStateChangesUsecase(i.get<IAuthRepository>()));

    // Usecases de Student, Supervisor, Contract serão registados nos seus respectivos módulos
    // de feature, pois são mais específicos para essas features.
    // Se algum usecase for verdadeiramente global, pode ser registado aqui.

    // --- FEATURES ---
    // BLoCs (AuthBloc é global) - Singleton
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
        RoleGuard([UserRole.student]),
      ],
    );

    r.module(
      '/supervisor',
      module: SupervisorModule(),
      guards: [
        AuthGuard(),
        RoleGuard([UserRole.supervisor, UserRole.admin]), // Admin também pode aceder
      ],
    );

    // Rota de Admin (Exemplo, se houver um AdminModule)
    // r.module(
    //   '/admin',
    //   module: AdminModule(),
    //   guards: [
    //     AuthGuard(),
    //     RoleGuard([UserRole.admin]),
    //   ],
    // );

    // Rota inicial da aplicação
    // O AuthGuard na rota '/' ou uma SplashPage que ouve o AuthBloc
    // geralmente lida com o redirecionamento inicial.
    // Se não houver guarda na rota raiz, um redirecionamento explícito é necessário.
    r.child(
      '/',
      child: (context) => const InitialRedirectWidget(), // Um widget que decide para onde ir
      guards: [AuthGuard()], // AuthGuard na raiz para proteger
    );
    // Se o AuthGuard redirecionar para /auth/login por defeito quando não autenticado,
    // e para uma rota interna quando autenticado, isso pode funcionar.
    // Ou, InitialRedirectWidget pode ouvir o AuthBloc.
  }
}

// Widget simples para redirecionamento inicial baseado no estado de autenticação
// Este widget seria usado se a rota '/' não tivesse um guard que já fizesse o redirecionamento.
// Com o AuthGuard na rota '/', este widget pode não ser estritamente necessário,
// mas pode adicionar lógica extra se preciso.
class InitialRedirectWidget extends StatelessWidget {
  const InitialRedirectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: Modular.get<AuthBloc>(), // Obtém o AuthBloc global
      builder: (context, state) {
        if (state is Authenticated) {
          // Utilizador autenticado, redireciona com base no papel
          switch (state.userRole) {
            case UserRole.student:
              // Usar replaceAllNamed para limpar a pilha de navegação
              Modular.to.replaceAllNamed('/student/');
              break;
            case UserRole.supervisor:
              Modular.to.replaceAllNamed('/supervisor/');
              break;
            case UserRole.admin:
              // Modular.to.replaceAllNamed('/admin/'); // Se houver rota de admin
              Modular.to.replaceAllNamed('/supervisor/'); // Admin pode ir para supervisor por agora
              break;
            default:
              // Papel desconhecido ou não tratado, vai para o login
              Modular.to.replaceAllNamed('/auth/login');
          }
        } else if (state is Unauthenticated || state is AuthFailure) {
          // Não autenticado ou falha, vai para o login
          Modular.to.replaceAllNamed('/auth/login');
        }
        // Enquanto AuthInitial ou AuthLoading, mostra um indicador
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
