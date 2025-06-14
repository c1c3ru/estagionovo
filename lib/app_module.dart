import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Sources
import 'data/datasources/supabase/auth_datasource.dart';
import 'data/datasources/supabase/student_datasource.dart';
import 'data/datasources/supabase/supervisor_datasource.dart';
import 'data/datasources/supabase/time_log_datasource.dart';
import 'data/datasources/supabase/contract_datasource.dart';
import 'data/datasources/local/preferences_manager.dart';
import 'data/datasources/local/cache_manager.dart';

// Repositories
import 'data/repositories/auth_repository.dart';
import 'data/repositories/student_repository.dart';
import 'data/repositories/supervisor_repository.dart';
import 'data/repositories/time_log_repository.dart';
import 'data/repositories/contract_repository.dart';

// Domain Repositories
import 'domain/repositories/i_auth_repository.dart';
import 'domain/repositories/i_student_repository.dart';
import 'domain/repositories/i_supervisor_repository.dart';
import 'domain/repositories/i_time_log_repository.dart';
import 'domain/repositories/i_contract_repository.dart';

// Use Cases - Auth
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';

// Use Cases - Student
import 'domain/usecases/student/get_all_students_usecase.dart';
import 'domain/usecases/student/get_student_by_id_usecase.dart';
import 'domain/usecases/student/get_student_by_user_id_usecase.dart';
import 'domain/usecases/student/create_student_usecase.dart';
import 'domain/usecases/student/update_student_usecase.dart';
import 'domain/usecases/student/delete_student_usecase.dart';
import 'domain/usecases/student/get_students_by_supervisor_usecase.dart';

// Use Cases - Supervisor
import 'domain/usecases/supervisor/get_all_supervisors_usecase.dart';
import 'domain/usecases/supervisor/get_supervisor_by_id_usecase.dart';
import 'domain/usecases/supervisor/get_supervisor_by_user_id_usecase.dart';
import 'domain/usecases/supervisor/create_supervisor_usecase.dart';
import 'domain/usecases/supervisor/update_supervisor_usecase.dart';
import 'domain/usecases/supervisor/delete_supervisor_usecase.dart';

// Use Cases - TimeLog
import 'domain/usecases/time_log/clock_in_usecase.dart';
import 'domain/usecases/time_log/clock_out_usecase.dart';
import 'domain/usecases/time_log/get_time_logs_by_student_usecase.dart';
import 'domain/usecases/time_log/get_active_time_log_usecase.dart';
import 'domain/usecases/time_log/get_total_hours_by_student_usecase.dart';

// Use Cases - Contract
import 'domain/usecases/contract/get_contracts_by_student_usecase.dart';
import 'domain/usecases/contract/get_contracts_by_supervisor_usecase.dart';
import 'domain/usecases/contract/get_active_contract_by_student_usecase.dart';
import 'domain/usecases/contract/create_contract_usecase.dart';
import 'domain/usecases/contract/update_contract_usecase.dart';
import 'domain/usecases/contract/delete_contract_usecase.dart';
import 'domain/usecases/contract/get_contract_statistics_usecase.dart';

// BLoCs
import 'features/auth/bloc/auth_bloc.dart';
import 'features/student/bloc/student_bloc.dart';
import 'features/supervisor/bloc/supervisor_bloc.dart';
import 'features/shared/bloc/time_log_bloc.dart';
import 'features/shared/bloc/contract_bloc.dart';
import 'features/shared/bloc/notification_bloc.dart';

// Pages
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/student/pages/student_home_page.dart';
import 'features/supervisor/pages/supervisor_home_page.dart';
import 'features/student/pages/time_log_page.dart';
import 'features/student/pages/contract_page.dart';
import 'features/shared/pages/notification_page.dart';

// Guards
import 'core/guards/auth_guard.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // External Dependencies
    i.addSingleton<SupabaseClient>(() => Supabase.instance.client);

    // Data Sources
    i.addLazySingleton<AuthDatasource>(() => AuthDatasource(i()));
    i.addLazySingleton<StudentDatasource>(() => StudentDatasource(i()));
    i.addLazySingleton<SupervisorDatasource>(() => SupervisorDatasource(i()));
    i.addLazySingleton<TimeLogDatasource>(() => TimeLogDatasource(i()));
    i.addLazySingleton<ContractDatasource>(() => ContractDatasource(i()));
    i.addLazySingleton<PreferencesManager>(() => PreferencesManager());
    i.addLazySingleton<CacheManager>(() => CacheManager());

    // Repositories
    i.addLazySingleton<IAuthRepository>(() => AuthRepository(i(), i()));
    i.addLazySingleton<IStudentRepository>(() => StudentRepository(i()));
    i.addLazySingleton<ISupervisorRepository>(() => SupervisorRepository(i()));
    i.addLazySingleton<ITimeLogRepository>(() => TimeLogRepository(i()));
    i.addLazySingleton<IContractRepository>(() => ContractRepository(i()));

    // Use Cases - Auth
    i.addLazySingleton<LoginUsecase>(() => LoginUsecase(i()));
    i.addLazySingleton<RegisterUsecase>(() => RegisterUsecase(i()));
    i.addLazySingleton<LogoutUsecase>(() => LogoutUsecase(i()));
    i.addLazySingleton<GetCurrentUserUsecase>(() => GetCurrentUserUsecase(i()));

    // Use Cases - Student
    i.addLazySingleton<GetAllStudentsUsecase>(() => GetAllStudentsUsecase(i()));
    i.addLazySingleton<GetStudentByIdUsecase>(() => GetStudentByIdUsecase(i()));
    i.addLazySingleton<GetStudentByUserIdUsecase>(() => GetStudentByUserIdUsecase(i()));
    i.addLazySingleton<CreateStudentUsecase>(() => CreateStudentUsecase(i()));
    i.addLazySingleton<UpdateStudentUsecase>(() => UpdateStudentUsecase(i()));
    i.addLazySingleton<DeleteStudentUsecase>(() => DeleteStudentUsecase(i()));
    i.addLazySingleton<GetStudentsBySupervisorUsecase>(() => GetStudentsBySupervisorUsecase(i()));

    // Use Cases - Supervisor
    i.addLazySingleton<GetAllSupervisorsUsecase>(() => GetAllSupervisorsUsecase(i()));
    i.addLazySingleton<GetSupervisorByIdUsecase>(() => GetSupervisorByIdUsecase(i()));
    i.addLazySingleton<GetSupervisorByUserIdUsecase>(() => GetSupervisorByUserIdUsecase(i()));
    i.addLazySingleton<CreateSupervisorUsecase>(() => CreateSupervisorUsecase(i()));
    i.addLazySingleton<UpdateSupervisorUsecase>(() => UpdateSupervisorUsecase(i()));
    i.addLazySingleton<DeleteSupervisorUsecase>(() => DeleteSupervisorUsecase(i()));

    // Use Cases - TimeLog
    i.addLazySingleton<ClockInUsecase>(() => ClockInUsecase(i()));
    i.addLazySingleton<ClockOutUsecase>(() => ClockOutUsecase(i()));
    i.addLazySingleton<GetTimeLogsByStudentUsecase>(() => GetTimeLogsByStudentUsecase(i()));
    i.addLazySingleton<GetActiveTimeLogUsecase>(() => GetActiveTimeLogUsecase(i()));
    i.addLazySingleton<GetTotalHoursByStudentUsecase>(() => GetTotalHoursByStudentUsecase(i()));

    // Use Cases - Contract
    i.addLazySingleton<GetContractsByStudentUsecase>(() => GetContractsByStudentUsecase(i()));
    i.addLazySingleton<GetContractsBySupervisorUsecase>(() => GetContractsBySupervisorUsecase(i()));
    i.addLazySingleton<GetActiveContractByStudentUsecase>(() => GetActiveContractByStudentUsecase(i()));
    i.addLazySingleton<CreateContractUsecase>(() => CreateContractUsecase(i()));
    i.addLazySingleton<UpdateContractUsecase>(() => UpdateContractUsecase(i()));
    i.addLazySingleton<DeleteContractUsecase>(() => DeleteContractUsecase(i()));
    i.addLazySingleton<GetContractStatisticsUsecase>(() => GetContractStatisticsUsecase(i()));

    // BLoCs
    i.addFactory<AuthBloc>(() => AuthBloc(
          loginUsecase: i(),
          registerUsecase: i(),
          logoutUsecase: i(),
          getCurrentUserUsecase: i(),
        ));

    i.addFactory<StudentBloc>(() => StudentBloc(
          getAllStudentsUsecase: i(),
          getStudentByIdUsecase: i(),
          getStudentByUserIdUsecase: i(),
          createStudentUsecase: i(),
          updateStudentUsecase: i(),
          deleteStudentUsecase: i(),
          getStudentsBySupervisorUsecase: i(),
        ));

    i.addFactory<SupervisorBloc>(() => SupervisorBloc(
          getAllSupervisorsUsecase: i(),
          getSupervisorByIdUsecase: i(),
          getSupervisorByUserIdUsecase: i(),
          createSupervisorUsecase: i(),
          updateSupervisorUsecase: i(),
          deleteSupervisorUsecase: i(),
        ));

    i.addFactory<TimeLogBloc>(() => TimeLogBloc(
          clockInUsecase: i(),
          clockOutUsecase: i(),
          getTimeLogsByStudentUsecase: i(),
          getActiveTimeLogUsecase: i(),
          getTotalHoursByStudentUsecase: i(),
        ));

    i.addFactory<ContractBloc>(() => ContractBloc(
          getContractsByStudentUsecase: i(),
          getContractsBySupervisorUsecase: i(),
          getActiveContractByStudentUsecase: i(),
          createContractUsecase: i(),
          updateContractUsecase: i(),
          deleteContractUsecase: i(),
          getContractStatisticsUsecase: i(),
        ));

    i.addFactory<NotificationBloc>(() => NotificationBloc());

    // Guards
    i.addLazySingleton<AuthGuard>(() => AuthGuard());
  }

  @override
  void routes(RouteManager r) {
    // Auth Routes
    r.child('/', child: (context) => const LoginPage());
    r.child('/login', child: (context) => const LoginPage());
    r.child('/register', child: (context) => const RegisterPage());

    // Student Routes
    r.child('/student',
        child: (context) => const StudentHomePage(),
        guards: [AuthGuard]);
    r.child('/student/time-log',
        child: (context) => TimeLogPage(
              studentId: r.args.data['studentId'] ?? '',
            ),
        guards: [AuthGuard]);
    r.child('/student/contracts',
        child: (context) => ContractPage(
              studentId: r.args.data['studentId'] ?? '',
            ),
        guards: [AuthGuard]);

    // Supervisor Routes
    r.child('/supervisor',
        child: (context) => const SupervisorHomePage(),
        guards: [AuthGuard]);

    // Shared Routes
    r.child('/notifications',
        child: (context) => const NotificationPage(),
        guards: [AuthGuard]);
  }
}

