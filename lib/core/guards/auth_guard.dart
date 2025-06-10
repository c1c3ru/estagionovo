// lib/core/guards/auth_guard.dart
import 'dart:async';
import 'package:estagio/features/auth/bloc/auth_bloc.dart';
import 'package:estagio/features/auth/bloc/auth_state.dart' as auth_state;
import 'package:flutter_modular/flutter_modular.dart';

/// Um RouteGuard que verifica se o utilizador está autenticado.
/// Se não estiver, redireciona para a rota de login.
class AuthGuard extends RouteGuard {
  AuthGuard()
      : super(
            redirectTo:
                '/auth/login'); // Rota para redirecionar se não autenticado

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    // Obtém o AuthBloc global (registado no AppModule)
    // É importante que o AuthBloc já tenha tido a oportunidade de verificar o estado inicial.
    final authBloc = Modular.get<AuthBloc>();
    final currentState = authBloc.state;

    if (currentState is auth_state.AuthSuccess) {
      // Se o estado for AuthSuccess, o utilizador está autenticado.
      return true;
    } else {
      // Se não for AuthSuccess (pode ser AuthInitial, AuthLoading, AuthUnauthenticated, AuthFailure),
      // considera como não autenticado para fins de guarda de rota e redireciona.
      // Opcionalmente, pode-se querer esperar se o estado for AuthLoading,
      // mas para RouteGuard, uma decisão síncrona ou um Future<bool> rápido é melhor.
      // Se o AuthBloc emitir AuthUnauthenticated após o logout, esta guarda funcionará corretamente.
      // Se o estado inicial for AuthInitial, e CheckAuthStatusEvent ainda não correu ou terminou,
      // esta guarda pode redirecionar prematuramente. Uma SplashPage que espera pelo AuthBloc
      // resolver o estado inicial é uma boa prática para a primeira rota da app.
      return false; // Redireciona para a rota definida em `redirectTo`
    }
  }
}
