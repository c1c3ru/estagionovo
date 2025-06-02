// lib/features/supervisor/supervisor_module.dart
import 'package:estagio/features/supervisor/bloc/supervisor_bloc.dart';
import 'package:estagio/features/supervisor/pages/student_details_page.dart';
import 'package:estagio/features/supervisor/pages/student_edit_page.dart';
import 'package:estagio/features/supervisor/pages/supervisor_dashboard_page.dart';
import 'package:estagio/features/supervisor/pages/supervisor_time_approval_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Para SupabaseClient

// Datasources
import '../../data/datasources/supabase/supervisor_datasource.dart';
import '../../data/datasources/supabase/student_datasource.dart';
import '../../data/datasources/supabase/time_log_datasource.dart';
import '../../data/datasources/supabase/contract_datasource.dart';
import '../../data/datasources/supabase/auth_datasource.dart'; // Para o RegisterUsecase

// Repositories (Implementações)
import '../../data/repositories/supervisor_repository.dart';
import '../../data/repositories/student_repository.dart'; // Se SupervisorRepository não cobrir tudo
import '../../data/repositories/time_log_repository.dart'; // Se SupervisorRepository não cobrir tudo
import '../../data/repositories/contract_repository.dart'; // Se SupervisorRepository não cobrir tudo
import '../../data/repositories/auth_repository.dart'; // Para o RegisterUsecase

// Repository Interfaces (do Domínio)
import '../../domain/repositories/i_supervisor_repository.dart';
import '../../domain/repositories/i_student_repository.dart';
import '../../domain/repositories/i_time_log_repository.dart';
import '../../domain/repositories/i_contract_repository.dart';
import '../../domain/repositories/i_auth_repository.dart'; // Para o RegisterUsecase

// Usecases
// Supervisor Usecases
import '../../domain/usecases/supervisor/get_supervisor_details_usecase.dart';
import '../../domain/usecases/supervisor/get_all_students_for_supervisor_usecase.dart';
import '../../domain/usecases/supervisor/get_student_details_for_supervisor_usecase.dart';
import '../../domain/usecases/supervisor/create_student_by_supervisor_usecase.dart';
import '../../domain/usecases/supervisor/update_student_by_supervisor_usecase.dart';
import '../../domain/usecases/supervisor/delete_student_by_supervisor_usecase.dart';
import '../../domain/usecases/supervisor/get_all_time_logs_for_supervisor_usecase.dart';
import '../../domain/usecases/supervisor/approve_or_reject_time_log_usecase.dart';
// Contract Usecases
import '../../domain/usecases/contract/get_all_contracts_usecase.dart';
import '../../domain/usecases/contract/create_contract_usecase.dart';
import '../../domain/usecases/contract/update_contract_usecase.dart';
import '../../domain/usecases/contract/delete_contract_usecase.dart';
// Auth Usecases (especificamente RegisterUsecase para criar o utilizador auth do estudante)
import '../../domain/usecases/auth/register_usecase.dart';

// BLoC

// Pages

// import 'presentation/pages/supervisor_time_approval_page.dart'; // Se houver uma página dedicada

class SupervisorModule extends Module {
  @override
  void binds(Injector i) {
    // --- Datasources ---
    // SupabaseClient é obtido do AppModule
    i.add<ISupervisorSupabaseDatasource>(
      () => SupervisorSupabaseDatasource(i.get<SupabaseClient>()),
    );
    // Student, TimeLog, Contract e Auth datasources já devem estar registados no AppModule se forem globais,
    // ou podem ser registados aqui se forem escopados para este módulo (menos comum para datasources).
    // Para este exemplo, vamos assumir que podem ser obtidos do injetor pai (AppModule)
    // ou que os repositórios que os usam já os recebem.
    // Se não estiverem no AppModule, registe-os aqui:
    if (!i.isRegistered<IStudentSupabaseDatasource>()) {
      i.add<IStudentSupabaseDatasource>(
        () => StudentSupabaseDatasource(i.get<SupabaseClient>()),
      );
    }
    if (!i.isRegistered<ITimeLogSupabaseDatasource>()) {
      i.add<ITimeLogSupabaseDatasource>(
        () => TimeLogSupabaseDatasource(i.get<SupabaseClient>()),
      );
    }
    if (!i.isRegistered<IContractSupabaseDatasource>()) {
      i.add<IContractSupabaseDatasource>(
        () => ContractSupabaseDatasource(i.get<SupabaseClient>()),
      );
    }
    // AuthDatasource para o RegisterUsecase
    if (!i.isRegistered<IAuthSupabaseDatasource>()) {
      i.add<IAuthSupabaseDatasource>(
        () => AuthSupabaseDatasource(i.get<SupabaseClient>()),
      );
    }

    // --- Repositories ---
    // IAuthRepository para o RegisterUsecase
    if (!i.isRegistered<IAuthRepository>()) {
      i.add<IAuthRepository>(
        () => AuthRepository(i.get<IAuthSupabaseDatasource>()),
      );
    }
    // IStudentRepository, ITimeLogRepository, IContractRepository
    // Se o SupervisorRepository não encapsular todas estas operações, registe-os.
    // Com base nas dependências do SupervisorBloc, parece que precisamos de todos eles.
    if (!i.isRegistered<IStudentRepository>()) {
      i.add<IStudentRepository>(
        () => StudentRepository(
          i.get<IStudentSupabaseDatasource>(),
          i.get<ITimeLogSupabaseDatasource>(),
        ),
      );
    }
    if (!i.isRegistered<ITimeLogRepository>()) {
      i.add<ITimeLogRepository>(
        () => TimeLogRepository(i.get<ITimeLogSupabaseDatasource>()),
      );
    }
    if (!i.isRegistered<IContractRepository>()) {
      i.add<IContractRepository>(
        () => ContractRepository(i.get<IContractSupabaseDatasource>()),
      );
    }

    i.add<ISupervisorRepository>(
      () => SupervisorRepository(
        i.get<ISupervisorSupabaseDatasource>(),
        i
            .get<
              IStudentSupabaseDatasource
            >(), // SupervisorRepository usa StudentDatasource
        i
            .get<
              ITimeLogSupabaseDatasource
            >(), // SupervisorRepository usa TimeLogDatasource
        i
            .get<
              IContractSupabaseDatasource
            >(), // SupervisorRepository usa ContractDatasource
      ),
    );

    // --- Usecases ---
    // Auth Usecase
    i.add<RegisterUsecase>(() => RegisterUsecase(i.get<IAuthRepository>()));

    // Supervisor Usecases
    i.add<GetSupervisorDetailsUsecase>(
      () => GetSupervisorDetailsUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<GetAllStudentsForSupervisorUsecase>(
      () => GetAllStudentsForSupervisorUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<GetStudentDetailsForSupervisorUsecase>(
      () =>
          GetStudentDetailsForSupervisorUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<CreateStudentBySupervisorUsecase>(
      () => CreateStudentBySupervisorUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<UpdateStudentBySupervisorUsecase>(
      () => UpdateStudentBySupervisorUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<DeleteStudentBySupervisorUsecase>(
      () => DeleteStudentBySupervisorUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<GetAllTimeLogsForSupervisorUsecase>(
      () => GetAllTimeLogsForSupervisorUsecase(i.get<ISupervisorRepository>()),
    );
    i.add<ApproveOrRejectTimeLogUsecase>(
      () => ApproveOrRejectTimeLogUsecase(i.get<ISupervisorRepository>()),
    );

    // Contract Usecases
    i.add<GetAllContractsUsecase>(
      () => GetAllContractsUsecase(i.get<IContractRepository>()),
    ); // Usa IContractRepository
    i.add<CreateContractUsecase>(
      () => CreateContractUsecase(i.get<IContractRepository>()),
    );
    i.add<UpdateContractUsecase>(
      () => UpdateContractUsecase(i.get<IContractRepository>()),
    );
    i.add<DeleteContractUsecase>(
      () => DeleteContractUsecase(i.get<IContractRepository>()),
    );

    // --- BLoC ---
    i.add<SupervisorBloc>(
      () => SupervisorBloc(
        getSupervisorDetailsUsecase: i.get<GetSupervisorDetailsUsecase>(),
        getAllStudentsForSupervisorUsecase: i
            .get<GetAllStudentsForSupervisorUsecase>(),
        getStudentDetailsForSupervisorUsecase: i
            .get<GetStudentDetailsForSupervisorUsecase>(),
        createStudentBySupervisorUsecase: i
            .get<CreateStudentBySupervisorUsecase>(),
        updateStudentBySupervisorUsecase: i
            .get<UpdateStudentBySupervisorUsecase>(),
        deleteStudentBySupervisorUsecase: i
            .get<DeleteStudentBySupervisorUsecase>(),
        getAllTimeLogsForSupervisorUsecase: i
            .get<GetAllTimeLogsForSupervisorUsecase>(),
        approveOrRejectTimeLogUsecase: i.get<ApproveOrRejectTimeLogUsecase>(),
        getAllContractsUsecase: i.get<GetAllContractsUsecase>(),
        createContractUsecase: i.get<CreateContractUsecase>(),
        updateContractUsecase: i.get<UpdateContractUsecase>(),
        deleteContractUsecase: i.get<DeleteContractUsecase>(),
        registerAuthUserUsecase: i.get<RegisterUsecase>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    // A rota base para este módulo é '/supervisor' (definido no AppModule)

    // Rota para o dashboard do supervisor (ex: /supervisor/dashboard ou /supervisor/)
    r.child(
      Modular.initialRoute, // Ou '/dashboard' se preferir /supervisor/dashboard
      child: (_) => const SupervisorDashboardPage(),
      transition: TransitionType.fadeIn,
    );

    // Rota para ver detalhes de um estudante específico (ex: /supervisor/student-details/:studentId)
    r.child(
      '/student-details/:studentId',
      child: (_) =>
          StudentDetailsPage(studentId: r.args.params['studentId'] as String),
      transition: TransitionType.rightToLeft,
    );

    // Rota para editar um estudante (ex: /supervisor/student-edit/:studentId)
    // Ou para criar um novo estudante (ex: /supervisor/student-create)
    r.child(
      '/student-edit/:studentId', // Para edição
      child: (_) =>
          StudentEditPage(studentId: r.args.params['studentId'] as String),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/student-create', // Para criação
      child: (_) =>
          const StudentEditPage(), // StudentEditPage pode lidar com criação se studentId for nulo
      transition: TransitionType.rightToLeft,
    );

    // Rota para a página de aprovação de horas (se for uma página separada)
    r.child(
      '/time-approvals',
      child: (_) => const SupervisorTimeApprovalPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
