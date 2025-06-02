// lib/features/supervisor/presentation/pages/student_edit_page.dart
import 'package:estagio/core/constants/app_colors.dart';
import 'package:estagio/core/enum/class_shift.dart';
import 'package:estagio/core/enum/internship_shift.dart';
import 'package:estagio/core/enum/user_role.dart';
import 'package:estagio/domain/entities/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';

import '../bloc/supervisor_bloc.dart';
import '../bloc/supervisor_event.dart';
import '../bloc/supervisor_state.dart';

class StudentEditPage extends StatefulWidget {
  final String? studentId; // Nulo para modo de criação

  const StudentEditPage({Key? key, this.studentId}) : super(key: key);

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  late SupervisorBloc _supervisorBloc;
  final _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  bool _isLoadingData = false; // Para o loading inicial no modo de edição
  StudentEntity? _studentToEdit;

  // Controladores de formulário
  final _emailController = TextEditingController(); // Apenas para criação
  final _passwordController = TextEditingController(); // Apenas para criação
  final _fullNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _courseController = TextEditingController();
  final _advisorNameController = TextEditingController();
  final _profilePictureUrlController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _contractStartDateController = TextEditingController();
  final _contractEndDateController = TextEditingController();
  final _totalHoursRequiredController = TextEditingController();
  final _weeklyHoursTargetController = TextEditingController();

  // Valores selecionados para Dropdowns e DatePickers
  DateTime? _selectedBirthDate;
  DateTime? _selectedContractStartDate;
  DateTime? _selectedContractEndDate;
  ClassShift? _selectedClassShift;
  InternshipShift? _selectedInternshipShift1;
  InternshipShift? _selectedInternshipShift2;
  bool _selectedIsMandatoryInternship = false;

  @override
  void initState() {
    super.initState();
    _supervisorBloc = Modular.get<SupervisorBloc>();
    _isEditMode = widget.studentId != null;

    if (_isEditMode) {
      _isLoadingData = true;
      // Busca os dados do estudante para edição
      _supervisorBloc.add(
        LoadStudentDetailsForSupervisorEvent(studentId: widget.studentId!),
      );
    } else {
      // Modo de criação, pode definir valores padrão se desejar
      _selectedIsMandatoryInternship = false; // Exemplo de valor padrão
    }
  }

  void _populateFormFields(StudentEntity student) {
    _studentToEdit = student;
    _fullNameController.text = student.fullName;
    _registrationNumberController.text = student.registrationNumber;
    _courseController.text = student.course;
    _advisorNameController.text = student.advisorName;
    _profilePictureUrlController.text = student.profilePictureUrl ?? '';
    _phoneNumberController.text = student.phoneNumber ?? '';

    _selectedBirthDate = student.birthDate;
    _birthDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(student.birthDate);

    _selectedContractStartDate = student.contractStartDate;
    _contractStartDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(student.contractStartDate);

    _selectedContractEndDate = student.contractEndDate;
    _contractEndDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(student.contractEndDate);

    _totalHoursRequiredController.text = student.totalHoursRequired
        .toStringAsFixed(2);
    _weeklyHoursTargetController.text = student.weeklyHoursTarget
        .toStringAsFixed(2);

    _selectedClassShift = student.classShift;
    _selectedInternshipShift1 = student.internshipShift1;
    _selectedInternshipShift2 = student.internshipShift2;
    _selectedIsMandatoryInternship = student.isMandatoryInternship;

    setState(() {
      _isLoadingData = false;
    });
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    DateTime? initialDate,
    Function(DateTime) onDateSelected, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime(2101),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        onDateSelected(picked);
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final studentEntityData = StudentEntity(
      id: _isEditMode
          ? widget.studentId!
          : '', // ID será gerado no backend para criação, ou usado para update
      fullName: _fullNameController.text.trim(),
      registrationNumber: _registrationNumberController.text.trim(),
      course: _courseController.text.trim(),
      advisorName: _advisorNameController.text.trim(),
      isMandatoryInternship: _selectedIsMandatoryInternship,
      classShift:
          _selectedClassShift ?? ClassShift.unknown, // Deve ter um valor
      internshipShift1:
          _selectedInternshipShift1 ??
          InternshipShift.unknown, // Deve ter um valor
      internshipShift2: _selectedInternshipShift2,
      birthDate: _selectedBirthDate ?? DateTime.now(), // Deve ter um valor
      contractStartDate:
          _selectedContractStartDate ?? DateTime.now(), // Deve ter um valor
      contractEndDate:
          _selectedContractEndDate ??
          DateTime.now().add(const Duration(days: 1)), // Deve ter um valor
      totalHoursRequired:
          double.tryParse(_totalHoursRequiredController.text) ?? 0.0,
      totalHoursCompleted: _isEditMode
          ? _studentToEdit!.totalHoursCompleted
          : 0.0, // Não editável aqui
      weeklyHoursTarget:
          double.tryParse(_weeklyHoursTargetController.text) ?? 0.0,
      profilePictureUrl: _profilePictureUrlController.text.trim().isNotEmpty
          ? _profilePictureUrlController.text.trim()
          : null,
      phoneNumber: _phoneNumberController.text.trim().isNotEmpty
          ? _phoneNumberController.text.trim()
          : null,
      createdAt: _isEditMode
          ? _studentToEdit!.createdAt
          : DateTime.now(), // Definido na criação
      updatedAt: DateTime.now(),
      role: UserRole.student,
    );

    if (_isEditMode) {
      _supervisorBloc.add(
        UpdateStudentBySupervisorEvent(studentData: studentEntityData),
      );
    } else {
      // Modo de criação
      _supervisorBloc.add(
        CreateStudentBySupervisorEvent(
          studentData:
              studentEntityData, // O ID aqui será ignorado e gerado pelo auth/backend
          initialEmail: _emailController.text.trim(),
          initialPassword: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _registrationNumberController.dispose();
    _courseController.dispose();
    _advisorNameController.dispose();
    _profilePictureUrlController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();
    _contractStartDateController.dispose();
    _contractEndDateController.dispose();
    _totalHoursRequiredController.dispose();
    _weeklyHoursTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Editar Estudante' : 'Adicionar Novo Estudante',
        ),
      ),
      body: BlocConsumer<SupervisorBloc, SupervisorState>(
        bloc: _supervisorBloc,
        listener: (context, state) {
          if (state is SupervisorOperationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
          } else if (state is SupervisorOperationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            Modular.to.pop(); // Volta para a tela anterior após sucesso
          } else if (state is SupervisorStudentDetailsLoadSuccess &&
              _isEditMode &&
              widget.studentId == state.student.id) {
            _populateFormFields(state.student);
          }
        },
        builder: (context, state) {
          if (_isLoadingData && _isEditMode) {
            return const LoadingIndicator();
          }

          if (state is SupervisorLoading &&
              state.loadingMessage == null &&
              _isEditMode &&
              _studentToEdit == null) {
            // Se está carregando os detalhes do estudante para edição e ainda não os temos
            return const LoadingIndicator();
          }

          return _buildForm(context, state);
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, SupervisorState supervisorState) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          if (!_isEditMode) ...[
            Text(
              'Credenciais de Acesso do Estudante',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _emailController,
              labelText: 'Email do Estudante',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              labelText: 'Senha Inicial',
              prefixIcon: Icons.lock_outline,
              obscureText:
                  true, // Pode adicionar um toggle de visibilidade se desejar
              validator: (value) => Validators.password(value, minLength: 6),
              textInputAction: TextInputAction.next,
            ),
            const Divider(height: 32, thickness: 1),
          ],
          Text(
            'Informações Pessoais e Acadêmicas',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _fullNameController,
            labelText: 'Nome Completo',
            prefixIcon: Icons.person_outline,
            validator: (value) =>
                Validators.required(value, fieldName: 'Nome Completo'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _registrationNumberController,
            labelText: 'Nº de Matrícula',
            prefixIcon: Icons.badge_outlined,
            validator: (value) =>
                Validators.required(value, fieldName: 'Nº de Matrícula'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _courseController,
            labelText: 'Curso',
            prefixIcon: Icons.school_outlined,
            validator: (value) =>
                Validators.required(value, fieldName: 'Curso'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _advisorNameController,
            labelText: 'Nome do Orientador(a)',
            prefixIcon: Icons.supervisor_account_outlined,
            validator: (value) =>
                Validators.required(value, fieldName: 'Orientador(a)'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
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
            onTap: () => _selectDate(
              context,
              _birthDateController,
              _selectedBirthDate,
              (date) => _selectedBirthDate = date,
              lastDate: DateTime.now(),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _phoneNumberController,
            labelText: 'Telefone (Opcional)',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _profilePictureUrlController,
            labelText: 'URL da Foto de Perfil (Opcional)',
            prefixIcon: Icons.link_outlined,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
          ),

          const Divider(height: 32, thickness: 1),
          Text(
            'Detalhes do Contrato/Estágio',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _contractStartDateController,
            labelText: 'Data de Início do Contrato',
            prefixIcon: Icons.play_circle_outline,
            readOnly: true,
            validator: (v) =>
                _selectedContractStartDate == null ? 'Campo obrigatório' : null,
            onTap: () => _selectDate(
              context,
              _contractStartDateController,
              _selectedContractStartDate,
              (date) => _selectedContractStartDate = date,
              lastDate: DateTime(2101),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _contractEndDateController,
            labelText: 'Data de Fim do Contrato',
            prefixIcon: Icons.stop_circle_outline,
            readOnly: true,
            validator: (v) {
              if (_selectedContractEndDate == null) return 'Campo obrigatório';
              if (_selectedContractStartDate != null &&
                  _selectedContractEndDate!.isBefore(
                    _selectedContractStartDate!,
                  )) {
                return 'Data final deve ser após a inicial';
              }
              return null;
            },
            onTap: () => _selectDate(
              context,
              _contractEndDateController,
              _selectedContractEndDate,
              (date) => _selectedContractEndDate = date,
              firstDate: _selectedContractStartDate ?? DateTime(1950),
              lastDate: DateTime(2101),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _totalHoursRequiredController,
            labelText: 'Total de Horas Contratadas',
            prefixIcon: Icons.hourglass_bottom_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) =>
                Validators.required(v, fieldName: 'Total de Horas'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _weeklyHoursTargetController,
            labelText: 'Meta de Horas Semanais',
            prefixIcon: Icons.track_changes_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => Validators.required(v, fieldName: 'Meta Semanal'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
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
            hint: const Text('Selecionar Turno'),
            items: ClassShift.values
                .where((s) => s != ClassShift.unknown)
                .map(
                  (s) => DropdownMenuItem(value: s, child: Text(s.displayName)),
                )
                .toList(),
            onChanged: (ClassShift? newValue) =>
                setState(() => _selectedClassShift = newValue),
            validator: (value) => value == null ? 'Selecione um turno' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<InternshipShift>(
            value: _selectedInternshipShift1,
            decoration: InputDecoration(
              labelText: 'Turno do Estágio 1',
              prefixIcon: Icon(
                Icons.work_outline,
                color: theme.inputDecorationTheme.prefixIconColor,
              ),
              border: theme.inputDecorationTheme.border,
            ),
            hint: const Text('Selecionar Turno'),
            items: InternshipShift.values
                .where((s) => s != InternshipShift.unknown)
                .map(
                  (s) => DropdownMenuItem(value: s, child: Text(s.displayName)),
                )
                .toList(),
            onChanged: (InternshipShift? newValue) =>
                setState(() => _selectedInternshipShift1 = newValue),
            validator: (value) =>
                value == null ? 'Selecione o turno do estágio' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<InternshipShift?>(
            // Permite nulo
            value: _selectedInternshipShift2,
            decoration: InputDecoration(
              labelText: 'Turno do Estágio 2 (Opcional)',
              prefixIcon: Icon(
                Icons.work_history_outlined,
                color: theme.inputDecorationTheme.prefixIconColor,
              ),
              border: theme.inputDecorationTheme.border,
            ),
            hint: const Text('Selecionar Turno (se houver)'),
            items: [
              const DropdownMenuItem<InternshipShift?>(
                value: null,
                child: Text('Nenhum'),
              ),
              ...InternshipShift.values
                  .where((s) => s != InternshipShift.unknown)
                  .map(
                    (s) => DropdownMenuItem<InternshipShift?>(
                      value: s,
                      child: Text(s.displayName),
                    ),
                  ),
            ],
            onChanged: (InternshipShift? newValue) =>
                setState(() => _selectedInternshipShift2 = newValue),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Estágio Obrigatório?'),
            value: _selectedIsMandatoryInternship,
            onChanged: (bool value) =>
                setState(() => _selectedIsMandatoryInternship = value),
            secondary: Icon(
              Icons.star_border_outlined,
              color: theme.colorScheme.primary,
            ),
            activeColor: theme.colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          AppButton(
            text: _isEditMode ? 'Salvar Alterações' : 'Criar Estudante',
            isLoading:
                supervisorState is SupervisorLoading &&
                supervisorState.loadingMessage != null,
            onPressed: _handleSave,
            minWidth: double.infinity,
          ),
        ],
      ),
    );
  }
}
