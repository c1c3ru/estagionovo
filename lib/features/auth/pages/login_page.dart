import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/enums/user_role.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Modular.get<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onRegisterPressed() {
    Modular.to.pushNamed('/auth/register');
  }

  void _onForgotPasswordPressed() {
    Modular.to.pushNamed('/auth/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            final route = state.user.role == UserRole.student
                ? '/student/'
                : '/supervisor/';
            Modular.to.pushReplacementNamed(route);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthLogoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logout realizado com sucesso'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.school,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppStrings.appName,
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Faça login para continuar',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    AuthTextField(
                      controller: _emailController,
                      label: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.fieldRequired;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return AppStrings.invalidEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: AppStrings.password,
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AuthButton(
                          text: AppStrings.login,
                          onPressed:
                              state is AuthLoading ? null : _onLoginPressed,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _onRegisterPressed,
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodyMedium,
                          children: const [
                            TextSpan(
                              text: 'Não tem uma conta? ',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            TextSpan(
                              text: AppStrings.register,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _onForgotPasswordPressed,
                      child: Text(
                        AppStrings.forgotPassword,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
