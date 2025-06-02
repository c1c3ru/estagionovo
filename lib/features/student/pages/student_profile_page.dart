// lib/features/student/presentation/pages/student_profile_page.dart
import 'package:estagio/core/enum/class_shift.dart';
import 'package:estagio/domain/entities/student.dart';
import 'package:estagio/features/auth/bloc/auth_bloc.dart';
import 'package:estagio/features/auth/bloc/auth_state.dart' as auth_state;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart'; // Para formatação de datas

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';

import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
// Importe o enum ClassShift e InternshipShift

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late StudentBloc _studentBloc;
  late AuthBloc _authBloc;
  String? _currentUserId;
  StudentEntity? _currentStudent;

  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de edição
  final _fullNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _courseController = TextEditingController();
  final _advisorNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _profilePictureUrlController = TextEditingController();
  final _birthDateController =
      TextEditingController(); // Para exibir a data selecionada

  DateTime? _selectedBirthDate;
  ClassShift? _selectedClassShift;
  // InternshipShift? _selectedInternshipShift1; // Descomente se for editar
  // InternshipShift? _selectedInternshipShift2; // Descomente se for editar
  bool? _selectedIsMandatoryInternship;

  @override
  void initState() {
    super.initState();
    _studentBloc = Modular.get<StudentBloc>();
    _authBloc = Modular.get<AuthBloc>();

    final currentAuthState = _authBloc.state;
    if (currentAuthState is auth_state.AuthSuccess) {
      _currentUserId = currentAuthState.user.id;
      if (_currentUserId != null) {
        final currentStudentState = _studentBloc.state;
        if (currentStudentState is StudentDashboardLoadSuccess &&
            currentStudentState.student.id == _currentUserId) {
          _currentStudent = currentStudentState.student;
          _populateFormFields(currentStudentState.student);
        } else {
          _studentBloc.add(
            LoadStudentDashboardDataEvent(userId: _currentUserId!),
          );
        }
      }
    }

    _authBloc.stream.listen((authState) {
      if (mounted && authState is auth_state.AuthSuccess) {
        if (_currentUserId != authState.user.id) {
          setState(() {
            _currentUserId = authState.user.id;
          });
          if (_currentUserId != null) {
            _studentBloc.add(
              LoadStudentDashboardDataEvent(userId: _currentUserId!),
            );
          }
        }
      } else if (mounted && authState is auth_state.AuthUnauthenticated) {
        setState(() {
          _currentUserId = null;
          _currentStudent = null;
        });
      }
    });
  }

  void _populateFormFields(StudentEntity student) {
    _fullNameController.text = student.fullName;
    _registrationNumberController.text = student.registrationNumber;
    _courseController.text = student.course;
    _advisorNameController.text = student.advisorName;
    _phoneNumberController.text = student.phoneNumber ?? '';
    _profilePictureUrlController.text = student.profilePictureUrl ?? '';

    _selectedBirthDate = student.birthDate;
    _birthDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(student.birthDate);

    _selectedClassShift = student.classShift;
    // _selectedInternshipShift1 = student.internshipShift1;
    // _selectedInternshipShift2 = student.internshipShift2;
    _selectedIsMandatoryInternship = student.isMandatoryInternship;
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (_isEditMode && _currentStudent != null) {
        _populateFormFields(_currentStudent!);
      }
    });
  }

  void _saveProfileChanges() {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: ID do utilizador não encontrado.')),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      _studentBloc.add(
        UpdateStudentProfileInfoEvent(
          userId: _currentUserId!,
          params: UpdateStudentProfileEventParams(
            fullName: _fullNameController.text.trim(),
            registrationNumber: _registrationNumberController.text.trim(),
            course: _courseController.text.trim(),
            advisorName: _advisorNameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim().isNotEmpty
                ? _phoneNumberController.text.trim()
                : null,
            profilePictureUrl:
                _profilePictureUrlController.text.trim().isNotEmpty
                ? _profilePictureUrlController.text.trim()
                : null,
            birthDate: _selectedBirthDate,
            classShift: _selectedClassShift,
            isMandatoryInternship: _selectedIsMandatoryInternship,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _registrationNumberController.dispose();
    _courseController.dispose();
    _advisorNameController.dispose();
    _phoneNumberController.dispose();
    _profilePictureUrlController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          if (!_isEditMode && _currentStudent != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar Perfil',
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: BlocConsumer<StudentBloc, StudentState>(
        bloc: _studentBloc,
        listener: (context, state) {
          if (state is StudentOperationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
          } else if (state is StudentProfileUpdateSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            setState(() {
              _currentStudent = state.updatedStudent;
              _isEditMode = false;
            });
          } else if (state is StudentDashboardLoadSuccess) {
            setState(() {
              _currentStudent = state.student;
            });
            if (!_isEditMode) {
              _populateFormFields(state.student);
            }
          }
        },
        builder: (context, state) {
          if (state is StudentLoading && _currentStudent == null) {
            return const LoadingIndicator();
          }

          if (state is StudentOperationFailure && _currentStudent == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    AppButton(
                      text: AppStrings.tryAgain,
                      onPressed: () {
                        if (_currentUserId != null) {
                          _studentBloc.add(
                            LoadStudentDashboardDataEvent(
                              userId: _currentUserId!,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (_currentStudent == null &&
              _currentUserId != null &&
              state is! StudentLoading) {
            _studentBloc.add(
              LoadStudentDashboardDataEvent(userId: _currentUserId!),
            );
            return const LoadingIndicator();
          }

          if (_currentStudent != null) {
            return _buildProfileForm(context, _currentStudent!);
          }

          return const Center(child: Text('A carregar dados do perfil...'));
        },
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, StudentEntity student) {
    if (!_isEditMode) {
      _populateFormFields(student);
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          // Foto de Perfil (Visualização)
          if (!_isEditMode)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage:
                    student.profilePictureUrl != null &&
                        student.profilePictureUrl!.isNotEmpty
                    ? NetworkImage(student.profilePictureUrl!)
                    : null,
                child:
                    student.profilePictureUrl == null ||
                        student.profilePictureUrl!.isEmpty
                    ? Text(
                        student.fullName.isNotEmpty
                            ? student.fullName[0].toUpperCase()
                            : '?',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                      )
                    : null,
              ),
            ),
          if (!_isEditMode) const SizedBox(height: 24),

          if (_isEditMode) ...[
            _buildEditableFields(context),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: AppStrings.cancel,
                    onPressed: _toggleEditMode,
                    type: AppButtonType.outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BlocBuilder<StudentBloc, StudentState>(
                    bloc: _studentBloc,
                    builder: (context, state) {
                      return AppButton(
                        text: AppStrings.save,
                        isLoading: state is StudentLoading,
                        onPressed: _saveProfileChanges,
                      );
                    },
                  ),
                ),
              ],
            ),
          ] else ...[
            _buildReadOnlyInfo(
              context,
              'Nome Completo',
              student.fullName,
              icon: Icons.person_outline,
            ),
            _buildReadOnlyInfo(
              context,
              'Nº de Matrícula',
              student.registrationNumber,
              icon: Icons.badge_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Curso',
              student.course,
              icon: Icons.school_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Orientador(a)',
              student.advisorName,
              icon: Icons.supervisor_account_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Telefone',
              student.phoneNumber ?? 'Não informado',
              icon: Icons.phone_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Email',
              _authBloc.state is auth_state.AuthSuccess
                  ? (_authBloc.state as auth_state.AuthSuccess).user.email
                  : 'Não informado',
              icon: Icons.email_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Data de Nascimento',
              DateFormat('dd/MM/yyyy').format(student.birthDate),
              icon: Icons.cake_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Estágio Obrigatório',
              student.isMandatoryInternship ? 'Sim' : 'Não',
              icon: Icons.star_border_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Turno das Aulas',
              student.classShift.displayName,
              icon: Icons.schedule_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Turno do Estágio 1',
              student.internshipShift1.displayName,
              icon: Icons.work_outline,
            ),
            if (student.internshipShift2 != null)
              _buildReadOnlyInfo(
                context,
                'Turno do Estágio 2',
                student.internshipShift2!.displayName,
                icon: Icons.work_history_outlined,
              ),
            _buildReadOnlyInfo(
              context,
              'Início do Contrato',
              DateFormat('dd/MM/yyyy').format(student.contractStartDate),
              icon: Icons.play_circle_outline,
            ),
            _buildReadOnlyInfo(
              context,
              'Fim do Contrato',
              DateFormat('dd/MM/yyyy').format(student.contractEndDate),
              icon: Icons.stop_circle_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Horas Necessárias',
              '${student.totalHoursRequired.toStringAsFixed(1)}h',
              icon: Icons.hourglass_bottom_outlined,
            ),
            _buildReadOnlyInfo(
              context,
              'Horas Completas',
              '${student.totalHoursCompleted.toStringAsFixed(1)}h',
              icon: Icons.hourglass_full_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditableFields(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Center(
          // Para a foto e URL no modo de edição
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: _profilePictureUrlController.text.isNotEmpty
                    ? NetworkImage(_profilePictureUrlController.text)
                    : null,
                child: _profilePictureUrlController.text.isEmpty
                    ? Icon(
                        Icons.person_add_alt_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _profilePictureUrlController,
                labelText: 'URL da Foto de Perfil (Opcional)',
                hintText: 'https://exemplo.com/sua-foto.jpg',
                prefixIcon: Icons.link_outlined,
                keyboardType: TextInputType.url,
                onChanged: (value) =>
                    setState(() {}), // Para atualizar a prévia da imagem
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: _fullNameController,
          labelText: 'Nome Completo',
          prefixIcon: Icons.person_outline,
          validator: (value) =>
              Validators.required(value, fieldName: 'Nome Completo'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _registrationNumberController,
          labelText: 'Nº de Matrícula',
          prefixIcon: Icons.badge_outlined,
          validator: (value) =>
              Validators.required(value, fieldName: 'Nº de Matrícula'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _courseController,
          labelText: 'Curso',
          prefixIcon: Icons.school_outlined,
          validator: (value) => Validators.required(value, fieldName: 'Curso'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _advisorNameController,
          labelText: 'Nome do Orientador(a)',
          prefixIcon: Icons.supervisor_account_outlined,
          validator: (value) =>
              Validators.required(value, fieldName: 'Orientador(a)'),
          textCapitalization: TextCapitalization.words,
          readOnly: null,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _phoneNumberController,
          labelText: 'Telefone (Opcional)',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        // Data de Nascimento
        AppTextField(
          controller: _birthDateController,
          labelText: 'Data de Nascimento',
          prefixIcon: Icons.cake_outlined,
          readOnly: true,
          validator: (v) => _selectedBirthDate == null
              ? 'Campo obrigatório'
              : Validators.dateNotFuture(
                  _selectedBirthDate,
                  fieldName: 'Data de Nascimento',
                ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate:
                  _selectedBirthDate ??
                  DateTime.now().subtract(
                    const Duration(days: 365 * 18),
                  ), // Ex: 18 anos atrás
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              locale: const Locale('pt', 'BR'),
            );
            if (picked != null && picked != _selectedBirthDate) {
              setState(() {
                _selectedBirthDate = picked;
                _birthDateController.text = DateFormat(
                  'dd/MM/yyyy',
                ).format(picked);
              });
            }
          },
        ),
        const SizedBox(height: 16),
        // Turno das Aulas
        DropdownButtonFormField<ClassShift>(
          value: _selectedClassShift,
          decoration: InputDecoration(
            labelText: 'Turno das Aulas',
            prefixIcon: Icon(
              Icons.schedule_outlined,
              color: theme.inputDecorationTheme.prefixIconColor,
            ),
            border: theme.inputDecorationTheme.border,
          ),
          items: ClassShift.values
              .where((shift) => shift != ClassShift.unknown)
              .map((ClassShift shift) {
                return DropdownMenuItem<ClassShift>(
                  value: shift,
                  child: Text(shift.displayName),
                );
              })
              .toList(),
          onChanged: (ClassShift? newValue) {
            setState(() {
              _selectedClassShift = newValue;
            });
          },
          validator: (value) => value == null || value == ClassShift.unknown
              ? 'Selecione um turno válido'
              : null,
        ),
        const SizedBox(height: 16),
        // Estágio Obrigatório
        SwitchListTile(
          title: const Text('Estágio Obrigatório?'),
          value: _selectedIsMandatoryInternship ?? false,
          onChanged: (bool value) {
            setState(() {
              _selectedIsMandatoryInternship = value;
            });
          },
          secondary: Icon(
            Icons.star_border_outlined,
            color: theme.colorScheme.primary,
          ),
          activeColor: theme.colorScheme.primary,
        ),

        // TODO: Adicionar Dropdowns para InternshipShift1 e InternshipShift2 se forem editáveis
      ],
    );
  }

  Widget _buildReadOnlyInfo(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ), // Aumentado o padding vertical
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 22,
              color: theme.colorScheme.primary,
            ), // Ícone um pouco maior
            const SizedBox(width: 16), // Espaçamento aumentado
          ] else ...[
            const SizedBox(width: 38),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 12,
                  ), // Fonte menor para o label
                ),
                const SizedBox(height: 3), // Espaçamento ajustado
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                  ), // Fonte um pouco menor para o valor
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
