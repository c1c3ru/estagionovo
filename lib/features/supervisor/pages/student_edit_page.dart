import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:student_supervisor_app/core/enums/class_shift.dart';
import 'package:student_supervisor_app/core/enums/internship_shift.dart';
import 'package:student_supervisor_app/core/enums/user_role.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../domain/entities/student_entity.dart';
import '../bloc/supervisor_bloc.dart';
import '../bloc/supervisor_event.dart';
import '../bloc/supervisor_state.dart';

class StudentEditPage extends StatefulWidget {
  final String? studentId;

  const StudentEditPage({super.key, this.studentId});

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  late SupervisorBloc _supervisorBloc;
  final _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  bool _isLoadingData = false;
  StudentEntity? _studentToEdit;

  // Controladores de formulário
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
  ClassShift _selectedClassShift = ClassShift.morning;
  InternshipShift _selectedInternshipShift1 = InternshipShift.morning;
  InternshipShift _selectedInternshipShift2 = InternshipShift.morning;
  bool _selectedIsMandatoryInternship = false;

  @override
  void initState() {
    super.initState();
    _supervisorBloc = Modular.get<SupervisorBloc>();
    _isEditMode = widget.studentId != null;

    if (_isEditMode) {
      _supervisorBloc.add(
        LoadStudentDetailsForSupervisorEvent(studentId: widget.studentId!),
      );
      _isLoadingData = true;
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
    _birthDateController.text =
        DateFormat('dd/MM/yyyy').format(student.birthDate);

    _selectedContractStartDate = student.contractStartDate;
    _contractStartDateController.text =
        DateFormat('dd/MM/yyyy').format(student.contractStartDate);

    _selectedContractEndDate = student.contractEndDate;
    _contractEndDateController.text =
        DateFormat('dd/MM/yyyy').format(student.contractEndDate);

    _totalHoursRequiredController.text =
        student.totalHoursRequired.toStringAsFixed(2);
    _weeklyHoursTargetController.text =
        student.weeklyHoursTarget.toStringAsFixed(2);

    _selectedClassShift = student.classShift;
    _selectedInternshipShift1 = student.internshipShift1;
    _selectedInternshipShift2 =
        student.internshipShift2 ?? InternshipShift.morning;
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
      id: _isEditMode ? widget.studentId! : '',
      fullName: _fullNameController.text.trim(),
      registrationNumber: _registrationNumberController.text.trim(),
      course: _courseController.text.trim(),
      advisorName: _advisorNameController.text.trim(),
      isMandatoryInternship: _selectedIsMandatoryInternship,
      classShift: _selectedClassShift,
      internshipShift1: _selectedInternshipShift1,
      internshipShift2: _selectedInternshipShift2,
      birthDate: _selectedBirthDate ?? DateTime.now(),
      contractStartDate: _selectedContractStartDate ?? DateTime.now(),
      contractEndDate: _selectedContractEndDate ??
          DateTime.now().add(const Duration(days: 1)),
      totalHoursRequired:
          double.tryParse(_totalHoursRequiredController.text) ?? 0.0,
      totalHoursCompleted:
          _isEditMode ? _studentToEdit!.totalHoursCompleted : 0.0,
      weeklyHoursTarget:
          double.tryParse(_weeklyHoursTargetController.text) ?? 0.0,
      profilePictureUrl: _profilePictureUrlController.text.trim().isNotEmpty
          ? _profilePictureUrlController.text.trim()
          : null,
      phoneNumber: _phoneNumberController.text.trim().isNotEmpty
          ? _phoneNumberController.text.trim()
          : null,
      role: UserRole.student,
      createdAt: DateTime.now(),
    );

    if (_isEditMode) {
      _supervisorBloc
          .add(UpdateStudentBySupervisorEvent(studentData: studentEntityData));
    } else {
      _supervisorBloc.add(CreateStudentBySupervisorEvent(
        studentData: studentEntityData,
        initialEmail: _emailController.text.trim(),
        initialPassword: _passwordController.text,
      ));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Estudante' : 'Novo Estudante'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: BlocConsumer<SupervisorBloc, SupervisorState>(
        bloc: _supervisorBloc,
        listener: (context, state) {
          if (state is SupervisorOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is SupervisorOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Operação realizada com sucesso!'),
                backgroundColor: AppColors.success,
              ),
            );
            Modular.to.pop();
          } else if (state is SupervisorStudentDetailsLoadSuccess) {
            if (_isEditMode && _isLoadingData) {
              _populateFormFields(state.student);
            }
          }
        },
        builder: (context, state) {
          if (_isLoadingData && _isEditMode) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isEditMode) ...[
            AppTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Digite o email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              labelText: 'Senha',
              hintText: 'Digite a senha',
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
          ],
          AppTextField(
            controller: _fullNameController,
            labelText: 'Nome Completo',
            hintText: 'Digite o nome completo',
            validator: (value) =>
                Validators.required(value, fieldName: 'Nome completo'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _registrationNumberController,
            labelText: 'Matrícula',
            hintText: 'Digite a matrícula',
            validator: (value) =>
                Validators.required(value, fieldName: 'Matrícula'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _courseController,
            labelText: 'Curso',
            hintText: 'Digite o curso',
            validator: (value) =>
                Validators.required(value, fieldName: 'Curso'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _advisorNameController,
            labelText: 'Nome do Orientador',
            hintText: 'Digite o nome do orientador',
            validator: (value) =>
                Validators.required(value, fieldName: 'Nome do orientador'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _birthDateController,
            labelText: 'Data de Nascimento',
            hintText: 'Selecione a data de nascimento',
            readOnly: true,
            onTap: () => _selectDate(
              context,
              _birthDateController,
              _selectedBirthDate,
              (date) => _selectedBirthDate = date,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _phoneNumberController,
            labelText: 'Telefone',
            hintText: 'Digite o telefone',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _profilePictureUrlController,
            labelText: 'URL da Foto de Perfil',
            hintText: 'Digite a URL da foto (opcional)',
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _contractStartDateController,
            labelText: 'Data de Início do Contrato',
            hintText: 'Selecione a data de início',
            readOnly: true,
            onTap: () => _selectDate(
              context,
              _contractStartDateController,
              _selectedContractStartDate,
              (date) => _selectedContractStartDate = date,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _contractEndDateController,
            labelText: 'Data de Fim do Contrato',
            hintText: 'Selecione a data de fim',
            readOnly: true,
            onTap: () => _selectDate(
              context,
              _contractEndDateController,
              _selectedContractEndDate,
              (date) => _selectedContractEndDate = date,
              firstDate: _selectedContractStartDate,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _totalHoursRequiredController,
            labelText: 'Total de Horas Requeridas',
            hintText: 'Digite o total de horas',
            keyboardType: TextInputType.number,
            validator: Validators.required,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _weeklyHoursTargetController,
            labelText: 'Meta de Horas Semanais',
            hintText: 'Digite a meta de horas semanais',
            keyboardType: TextInputType.number,
            validator: Validators.required,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ClassShift>(
            value: _selectedClassShift,
            decoration: const InputDecoration(
              labelText: 'Turno das Aulas',
              border: OutlineInputBorder(),
            ),
            items: ClassShift.values.map((shift) {
              return DropdownMenuItem(
                value: shift,
                child: Text(shift.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedClassShift = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<InternshipShift>(
            value: _selectedInternshipShift1,
            decoration: const InputDecoration(
              labelText: 'Turno do Estágio',
              border: OutlineInputBorder(),
            ),
            items: InternshipShift.values.map((shift) {
              return DropdownMenuItem(
                value: shift,
                child: Text(shift.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedInternshipShift1 = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<InternshipShift>(
            value: _selectedInternshipShift2,
            decoration: const InputDecoration(
              labelText: 'Turno do Estágio (Secundário)',
              border: OutlineInputBorder(),
            ),
            items: InternshipShift.values.map((shift) {
              return DropdownMenuItem(
                value: shift,
                child: Text(shift.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedInternshipShift2 = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Estágio Obrigatório'),
            value: _selectedIsMandatoryInternship,
            onChanged: (value) {
              setState(() {
                _selectedIsMandatoryInternship = value!;
              });
            },
          ),
          const SizedBox(height: 32),
          AppButton(
            text: _isEditMode ? 'Atualizar' : 'Criar',
            onPressed: _handleSave,
          ),
        ],
      ),
    );
  }
}
