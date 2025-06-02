// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para o logo SVG, adicione flutter_svg ao pubspec

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart'; // Para o botão de registo
import '../widgets/login_form.dart'; // Importa o LoginForm

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Limita a largura em telas maiores
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Logo (Exemplo com SVG)
                  // Certifique-se de ter um logo em assets/images/logo.svg ou similar
                  // SvgPicture.asset(
                  //   'assets/images/app_logo.svg', // Substitua pelo caminho do seu logo
                  //   height: mediaQuery.size.height * 0.15,
                  //   colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                  // ),
                  // const SizedBox(height: 32),

                  Text(
                    'Bem-vindo(a) de volta!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Faça login para continuar.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const LoginForm(), // Usa o widget LoginForm
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Modular.to.pushNamed('/auth/register');
                        },
                        child: Text(
                          AppStrings.register,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
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
