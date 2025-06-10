// lib/features/auth/widgets/supervisor_register_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SupervisorRegisterForm extends StatefulWidget {
  const SupervisorRegisterForm({super.key});

  @override
  State<SupervisorRegisterForm> createState() => _SupervisorRegisterFormState();
}

class _SupervisorRegisterFormState extends State<SupervisorRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _siapeRegistrationController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _departmentController = TextEditingController();
  final _positionController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSiapeValid = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _siapeRegistrationController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _onSiapeChanged(String value) {
    setState(() {
      _isSiapeValid = Validators.siapeRegistration(value) == null;
    });
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final authBloc = context.read<AuthBloc>();
      authBloc.add(
        RegisterSupervisorEvent(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          siapeRegistration: _siapeRegistrationController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim().isEmpty
              ? null
              : _phoneNumberController.text.trim(),
          department: _departmentController.text.trim().isEmpty
              ? null
              : _departmentController.text.trim(),
          position: _positionController.text.trim().isEmpty
              ? null
              : _positionController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.registerSupervisorPage,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Apenas funcionários com matrícula SIAPE podem se cadastrar como supervisores.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Nome completo
          AppTextField(
            controller: _fullNameController,
            labelText: AppStrings.fullName,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) =>
                Validators.required(value, fieldName: 'Nome completo'),
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // Matrícula SIAPE (campo obrigatório)
          AppTextField(
            controller: _siapeRegistrationController,
            labelText: AppStrings.siapeRegistration,
            hintText: AppStrings.siapeHint,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(7),
            ],
            validator: Validators.siapeRegistration,
            onChanged: _onSiapeChanged,
            prefixIcon: Icons.badge_outlined,
            suffixIcon: _isSiapeValid
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
          const SizedBox(height: 16),

          // Email
          AppTextField(
            controller: _emailController,
            labelText: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 16),

          // Telefone (opcional)
          AppTextField(
            controller: _phoneNumberController,
            labelText: '${AppStrings.phoneNumber} (opcional)',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                return Validators.phoneNumber(value);
              }
              return null;
            },
            prefixIcon: const Icon(Icons.phone_outlined),
          ),
          const SizedBox(height: 16),

          // Departamento (opcional)
          AppTextField(
            controller: _departmentController,
            labelText: 'Departamento (opcional)',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.business_outlined),
          ),
          const SizedBox(height: 16),

          // Cargo (opcional)
          AppTextField(
            controller: _positionController,
            labelText: 'Cargo (opcional)',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.work_outline),
          ),
          const SizedBox(height: 16),

          // Senha
          AppTextField(
            controller: _passwordController,
            labelText: AppStrings.password,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.next,
            validator: Validators.password,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // Confirmar senha
          AppTextField(
            controller: _confirmPasswordController,
            labelText: AppStrings.confirmPassword,
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            validator: (value) =>
                Validators.confirmPassword(_passwordController.text, value),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            onFieldSubmitted: (_) => _onRegister(),
          ),
          const SizedBox(height: 24),

          // Botão de cadastro
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoadingState;

              return AppButton(
                text: AppStrings.register,
                onPressed: isLoading ? null : _onRegister,
                isLoading: isLoading,
                icon: const Icon(Icons.person_add),
              );
            },
          ),
        ],
      ),
    );
  }
}
