// lib/app_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Para localização
import 'package:flutter_modular/flutter_modular.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart'; // Para CheckAuthStatusRequestedEvent

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    // Obtém a instância singleton do AuthBloc registada no AppModule
    _authBloc = Modular.get<AuthBloc>();
    // Dispara o evento para verificar o estado de autenticação ao iniciar a app
    _authBloc.add(const CheckAuthStatusRequestedEvent());
  }


  @override
  Widget build(BuildContext context) {
    // ModularWatch ou Modular.setInitialRoute('/') já deve ter sido configurado
    // Modular.setObservers([RouterObserver()]); // Opcional, para observar navegação

    return BlocProvider<AuthBloc>.value( // Fornece o AuthBloc globalmente
      value: _authBloc,
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false, // Remover o banner de debug

        // Configuração de Tema
        theme: AppTheme.lightTheme, // Tema claro definido em core/theme
        darkTheme: AppTheme.darkTheme, // Tema escuro definido em core/theme
        themeMode: ThemeMode.system, // Ou gerenciado por um ThemeBloc/Preferências
                                     // Ex: context.watch<ThemeBloc>().state.themeMode

        // Configuração de Localização (para pt_BR)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'), // Português (Brasil)
          // Adicione outros locales suportados aqui
          // Locale('en', 'US'), // Inglês
        ],
        locale: const Locale('pt', 'BR'), // Define o locale padrão

        // Configuração de Roteamento com Flutter Modular
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
      ),
    );
  }
}
