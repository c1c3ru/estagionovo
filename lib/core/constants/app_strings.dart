// lib/core/constants/app_strings.dart

class AppStrings {
  // Geral
  static const String appName = 'Gestão de Estágios'; // Ou o nome que você definiu "estagio"
  static const String tryAgain = 'Tentar Novamente';
  static const String errorOccurred = 'Ocorreu um erro';
  static const String anErrorOccurred = 'Ocorreu um erro inesperado. Por favor, tente novamente.';
  static const String success = 'Sucesso';
  static const String loading = 'A carregar...';
  static const String cancel = 'Cancelar';
  static const String save = 'Guardar';
  static const String ok = 'OK';
  static const String close = 'Fechar';
  static const String next = 'Próximo';
  static const String previous = 'Anterior';
  static const String submit = 'Submeter';
  static const String requiredField = 'Este campo é obrigatório.';
  static const String invalidEmail = 'Email inválido.';
  static const String passwordTooShort = 'A senha deve ter pelo menos 6 caracteres';

  // Autenticação
  static const String login = 'Login';
  static const String register = 'Registar';
  static const String logout = 'Sair';
  static const String forgotPassword = 'Esqueceu a senha?';
  static const String email = 'Email';
  static const String password = 'Senha';
  static const String confirmPassword = 'Confirmar Senha';
  static const String fullName = 'Nome Completo';
  static const String selectRole = 'Selecionar Perfil';
  static const String student = 'Estudante';
  static const String supervisor = 'Supervisor';
  static const String admin = 'Administrador';
  static const String loginSuccess = 'Login realizado com sucesso!';
  static const String registrationSuccessTitle = 'Registo Concluído';
  static const String registrationSuccessMessage = 'Conta criada com sucesso. Verifique o seu email para confirmação.';
  static const String passwordResetEmailSent = 'Instruções para redefinir a senha enviadas para o seu email.';
  static const String logoutConfirmation = 'Tem a certeza que deseja sair?';

  // Mensagens relacionadas à matrícula SIAPE
  static const String siapeRequired = 'Matrícula SIAPE é obrigatória.';
  static const String siapeInvalid = 'Matrícula SIAPE deve ter exatamente 7 dígitos.';
  static const String siapeAlreadyExists = 'Esta matrícula SIAPE já está em uso.';
  static const String siapeOnlyNumbers = 'Matrícula SIAPE deve conter apenas números.';
  static const String siapeRegistration = 'Matrícula SIAPE';
  static const String siapeHint = 'Digite sua matrícula SIAPE (7 dígitos)';
  static const String unauthorizedSupervisor = 'Apenas funcionários com matrícula SIAPE podem se cadastrar como supervisores.';


  // Dashboard (Geral)
  static const String dashboard = 'Dashboard';

  // Estudante
  static const String studentDashboardTitle = 'Painel do Estudante';
  static const String timeLog = 'Registo de Horas';
  static const String profile = 'Perfil';
  static const String checkIn = 'Check-in';
  static const String checkOut = 'Check-out';
  static const String recentTimeLogs = 'Registos de Tempo Recentes';
  static const String noRecentTimeLogs = 'Nenhum registo de tempo recente';
  static const String logTime = 'Registar Tempo';
  static const String weeklySummary = 'Resumo Semanal';
  static const String hoursThisWeek = 'Horas esta semana';
  static const String weeklyTarget = 'Meta semanal';
  static const String weeklyTargetAchieved = 'Meta semanal atingida! 🎉';
  static const String hoursRemainingThisWeek = 'horas restantes esta semana';

  // Supervisor
  static const String supervisorDashboardTitle = 'Painel do Supervisor';
  static const String students = 'Estudantes';
  static const String timeApprovals = 'Aprovações de Horas';
  static const String contracts = 'Contratos';
  static const String totalStudents = 'Total';
  static const String activeStudents = 'Ativos';
  static const String inactiveStudents = 'Inativos';
  static const String expiringContracts = 'Vencendo'; // Para contratos ou estágios
  static const String studentDistribution = 'Distribuição de Estagiários';
  static const String studentList = 'Lista de Estudantes';
  static const String ganttView = 'Visualização Gantt';
  static const String noStudentsFound = 'Nenhum estagiário encontrado.';
  static const String filterStudents = 'Filtrar Estagiários';
  static const String studentName = 'Nome do Estagiário';
  static const String course = 'Curso';
  static const String status = 'Status';
  static const String applyFilters = 'Aplicar';
  static const String clearFilters = 'Limpar';

  // User roles (removed duplicates - keeping original definitions)


  // Comum
  static const String settings = 'Configurações';
  static const String helpAndFeedback = 'Ajuda e Feedback';
  static const String registerSupervisorPage = 'Cadastro de Supervisor';


  // Status
  static const String active = 'Ativo';
  static const String inactive = 'Inativo';
  static const String pending = 'Pendente';
  static const String approved = 'Aprovado';
  static const String rejected = 'Rejeitado';

  // Loading states (removed duplicate - keeping original definition)

  static const String saving = 'Salvando...';
  static const String processing = 'Processando...';

  // Mensagens de erro de rede/conectividade
  static const String networkError = 'Erro de conexão. Verifique sua internet.';
  static const String serverError = 'Erro no servidor. Tente novamente mais tarde.';
  static const String unknownError = 'Erro desconhecido. Tente novamente.';

  // Mensagens de confirmação
  static const String confirmDelete = 'Tem certeza que deseja excluir?';
  static const String confirmLogout = 'Tem certeza que deseja sair?';

  // Previne instanciação
  AppStrings._();
}