// lib/features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_strings.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        elevation: 0,
        backgroundColor: Colors.transparent, // AppBar transparente para se misturar com o corpo
        foregroundColor: theme.colorScheme.onSurface, // Cor dos ícones e texto da AppBar
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // SvgPicture.asset(
                  //   'assets/images/app_logo.svg', // Substitua pelo caminho do seu logo
                  //   height: mediaQuery.size.height * 0.1,
                  //   colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                  // ),
                  // const SizedBox(height: 24),
                  Text(
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha os campos abaixo para começar.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const RegisterForm(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem uma conta?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Modular.to.pop(); // Volta para a tela anterior (Login)
                        },
                        child: Text(
                          AppStrings.login,
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
