// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemChrome
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para formatação de data em pt_BR

import 'app_module.dart';
import 'app_widget.dart';
import 'core/utils/logger_utils.dart'; // Nosso logger global

// A instância global do SupabaseClient, se você optar por usá-la diretamente em alguns locais.
// No entanto, com Modular, é preferível injetá-la onde for necessário.
// A inicialização é feita aqui, e o AppModule pode registá-la para injeção.
// late final SupabaseClient supabase; // Comentado pois o AppModule irá registar o Supabase.instance.client

Future<void> main() async {
  // Garante que os bindings do Flutter estão inicializados.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a formatação de data para Português (Brasil)
  // Necessário para DateFormat funcionar corretamente com 'pt_BR'
  await initializeDateFormatting('pt_BR', null);


  // Configura as orientações de ecrã preferidas.
  // Permite apenas retrato.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configura a aparência da barra de status (opcional)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Torna a barra de status transparente
    statusBarIconBrightness: Brightness.dark, // Ícones escuros para fundos claros
    systemNavigationBarColor: Colors.white, // Cor da barra de navegação (Android)
    systemNavigationBarIconBrightness: Brightness.dark, // Ícones da barra de navegação escuros
  ));

  try {
    // Inicializa o Supabase.
    // As chaves devem ser fornecidas como variáveis de ambiente ao compilar.
    // Ex: flutter run --dart-define=SUPABASE_URL=SUA_URL --dart-define=SUPABASE_ANON_KEY=SUA_CHAVE
    await Supabase.initialize(
      url: const String.fromEnvironment(
        'SUPABASE_URL',
        // defaultValue: 'COLOQUE_SUA_URL_SUPABASE_AQUI_PARA_DESENVOLVIMENTO_LOCAL_SE_NAO_USAR_DART_DEFINE',
      ),
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        // defaultValue: 'COLOQUE_SUA_CHAVE_ANON_SUPABASE_AQUI_PARA_DESENVOLVIMENTO_LOCAL_SE_NAO_USAR_DART_DEFINE',
      ),
      debug: true, // Defina como false em produção
    );

    // supabase = Supabase.instance.client; // Comentado, o AppModule irá registar
    logger.i('Supabase inicializado com sucesso!');

    // Executa a aplicação Modular.
    // AppModule define as dependências e rotas principais.
    // AppWidget é o widget raiz da aplicação.
    runApp(ModularApp(module: AppModule(), child: const AppWidget()));
  } catch (e, stackTrace) {
    logger.f('Erro crítico ao inicializar a aplicação: $e', error: e, stackTrace: stackTrace);

    // Mostra uma UI de fallback em caso de erro crítico na inicialização.
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Falha Crítica na Inicialização',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Não foi possível iniciar a aplicação devido a um erro inesperado. Por favor, tente reiniciar a aplicação.\n\nDetalhes: $e',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                    onPressed: () {
                      // Tenta reiniciar a lógica de inicialização.
                      // Numa app real, pode ser melhor fechar e pedir ao utilizador para reabrir.
                      main();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
