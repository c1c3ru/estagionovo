// lib/features/auth/auth_module.dart
import 'package:estagio/features/auth/pages/forgot_password_page.dart';
import 'package:estagio/features/auth/pages/login_page.dart';
import 'package:estagio/features/auth/pages/register_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Para SupabaseClient

// Datasources
import '../../data/datasources/supabase/auth_datasource.dart';

// Repositories
import '../../data/repositories/auth_repository.dart';
import '../../domain/repositories/i_auth_repository.dart';

// Usecases
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/reset_password_usecase.dart';
import '../../domain/usecases/auth/update_profile_usecase.dart';
import '../../domain/usecases/auth/get_auth_state_changes_usecase.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    // Datasources
    // O SupabaseClient é geralmente injetado a partir do AppModule ou obtido globalmente.
    // Se estiver no AppModule: i.get<SupabaseClient>()
    // Se for global (como em main.dart): Supabase.instance.client
    // Vamos assumir que está disponível para ser obtido pelo Modular se registrado no AppModule,
    // ou podemos instanciar diretamente se a instância global 'supabase' de main.dart for usada.
    // Por agora, vamos obter do injetor do Modular, assumindo que foi registrado no AppModule.
    // Se não, você pode precisar ajustar isso ou passar a instância global.
    i.add<IAuthSupabaseDatasource>(
      () => AuthSupabaseDatasource(i.get<SupabaseClient>()),
    );
    // Alternativa se SupabaseClient não estiver no injetor e for global:
    // i.add<IAuthSupabaseDatasource>(() => AuthSupabaseDatasource(Supabase.instance.client));

    // Repositories
    i.add<IAuthRepository>(
      () => AuthRepository(i.get<IAuthSupabaseDatasource>()),
    );

    // Usecases
    i.add<LoginUsecase>(() => LoginUsecase(i.get<IAuthRepository>()));
    i.add<RegisterUsecase>(() => RegisterUsecase(i.get<IAuthRepository>()));
    i.add<LogoutUsecase>(() => LogoutUsecase(i.get<IAuthRepository>()));
    i.add<GetCurrentUserUsecase>(
      () => GetCurrentUserUsecase(i.get<IAuthRepository>()),
    );
    i.add<ResetPasswordUsecase>(
      () => ResetPasswordUsecase(i.get<IAuthRepository>()),
    );
    i.add<UpdateProfileUsecase>(
      () => UpdateProfileUsecase(i.get<IAuthRepository>()),
    );
    i.add<GetAuthStateChangesUsecase>(
      () => GetAuthStateChangesUsecase(i.get<IAuthRepository>()),
    );

    // BLoC
    // O AuthBloc é frequentemente um Singleton ou LazySingleton no AppModule para ser acessível globalmente.
    // Se ele for usado apenas dentro do AuthModule, um Factory pode ser suficiente.
    // Se você o registou como Singleton no AppModule, não precisa registá-lo aqui novamente,
    // a menos que queira um escopo diferente.
    // Assumindo que ele é gerenciado pelo AppModule para estado global de autenticação:
    // Se não, descomente e ajuste:
    /*
    i.addSingleton<AuthBloc>(() => AuthBloc(
          loginUsecase: i.get<LoginUsecase>(),
          registerUsecase: i.get<RegisterUsecase>(),
          logoutUsecase: i.get<LogoutUsecase>(),
          getCurrentUserUsecase: i.get<GetCurrentUserUsecase>(),
          resetPasswordUsecase: i.get<ResetPasswordUsecase>(),
          updateProfileUsecase: i.get<UpdateProfileUsecase>(),
          getAuthStateChangesUsecase: i.get<GetAuthStateChangesUsecase>(),
        ));
    */
    // Se o AuthBloc for fornecido pelo AppModule, você pode simplesmente usar i.get<AuthBloc>() nas páginas se necessário,
    // ou as páginas podem usar BlocProvider.of<AuthBloc>(context) se o BLoC for fornecido mais acima na árvore de widgets.
    // Para este exemplo, vamos assumir que o AuthBloc é instanciado e gerenciado pelo AppModule.
    // Se você precisar de uma instância específica para este módulo ou quiser garantir que ele seja
    // fornecido aqui, você pode registrá-lo. Por agora, vou deixar comentado,
    // pois a prática comum é ter um AuthBloc global.
  }

  @override
  void routes(RouteManager r) {
    // A rota base para este módulo é '/auth' (definido no AppModule)
    // As rotas aqui são relativas a '/auth'

    // Rota para a página de login (ex: /auth/login)
    r.child(
      '/login',
      child: (_) => LoginPage(
        // Se AuthBloc não for global, você pode obtê-lo aqui: authBloc: Modular.get<AuthBloc>()
        // ou se for registrado neste módulo: authBloc: Modular.get<AuthBloc>()
        // Mas geralmente as páginas usam BlocProvider ou context.read/watch
      ),
      transition: TransitionType.fadeIn,
    );

    // Rota para a página de registo (ex: /auth/register)
    r.child(
      '/register',
      child: (_) => RegisterPage(),
      transition: TransitionType.fadeIn,
    );

    // Rota para a página de esquecimento de senha (ex: /auth/forgot-password)
    r.child(
      '/forgot-password',
      child: (_) => ForgotPasswordPage(),
      transition: TransitionType.fadeIn,
    );

    // Você pode definir uma rota padrão para o módulo de autenticação,
    // por exemplo, se /auth for acessado diretamente, redirecionar para /auth/login.
    // r.redirect('/', to: '/login'); // Se a rota base do módulo for '/' dentro de '/auth'
  }
}
