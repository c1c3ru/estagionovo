// lib/features/student/student_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Para SupabaseClient

// Datasources
import '../../data/datasources/supabase/student_datasource.dart';
import '../../data/datasources/supabase/time_log_datasource.dart';
import '../../data/datasources/supabase/contract_datasource.dart';

// Repositories (Implementações)
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/time_log_repository.dart';
import '../../data/repositories/contract_repository.dart';

// Repository Interfaces (do Domínio)
import '../../domain/repositories/i_student_repository.dart';
import '../../domain/repositories/i_time_log_repository.dart';
import '../../domain/repositories/i_contract_repository.dart';

// Usecases
// Student Usecases
import '../../domain/usecases/student/get_student_details_usecase.dart';
import '../../domain/usecases/student/update_student_profile_usecase.dart';
import '../../domain/usecases/student/check_in_usecase.dart';
import '../../domain/usecases/student/check_out_usecase.dart';
// TimeLog Usecases (usados pelo StudentBloc, podem ser do Student ou TimeLog)
import '../../domain/usecases/student/get_student_time_logs_usecase.dart';
import '../../domain/usecases/student/create_time_log_usecase.dart';
import '../../domain/usecases/student/update_time_log_usecase.dart';
import '../../domain/usecases/student/delete_time_log_usecase.dart';
// Contract Usecases
import '../../domain/usecases/contract/get_contracts_for_student_usecase.dart';
// Adicione aqui o usecase para GetActiveTimeLogForStudentUsecase se for criá-lo
// import '../../domain/usecases/time_log/get_active_time_log_for_student_usecase.dart';


// BLoC
import 'presentation/bloc/student_bloc.dart';

// Pages
import 'presentation/pages/student_home_page.dart'; // Renomeado para student_home_page
import 'presentation/pages/student_time_log_page.dart'; // Para a lista de logs e criação manual
import 'presentation/pages/student_profile_page.dart';
// A check_in_out_page pode ser parte da student_home_page ou uma página separada.
// Se for separada, importe-a: import 'presentation/pages/check_in_out_page.dart';


class StudentModule extends Module {
  @override
  void binds(Injector i) {
    // Datasources
    // SupabaseClient é obtido do AppModule (ou de onde estiver registrado globalmente)
    i.add<IStudentSupabaseDatasource>(() => StudentSupabaseDatasource(i.get<SupabaseClient>()));
    i.add<ITimeLogSupabaseDatasource>(() => TimeLogSupabaseDatasource(i.get<SupabaseClient>()));
    i.add<IContractSupabaseDatasource>(() => ContractSupabaseDatasource(i.get<SupabaseClient>()));

    // Repositories
    // O StudentRepository pode precisar de múltiplos datasources se as operações estiverem muito interligadas
    // ou podemos ter repositórios mais granulares.
    // A interface IStudentRepository que definimos já inclui métodos para TimeLog.
    // Se você decidir usar ITimeLogRepository e IContractRepository separadamente,
    // o StudentBloc precisaria injetá-los também.
    // Por agora, vamos assumir que StudentRepository lida com as operações de TimeLog e Contrato
    // que são contextuais ao estudante, e os usecases refletem isso.
    // Se os usecases do StudentBloc usam ITimeLogRepository e IContractRepository diretamente,
    // então estes também precisam ser registrados.

    i.add<IStudentRepository>(() => StudentRepository(
          i.get<IStudentSupabaseDatasource>(),
          i.get<ITimeLogSupabaseDatasource>(), // StudentRepository usa TimeLogDatasource
        ));

    // Registar ITimeLogRepository e IContractRepository se os usecases do StudentBloc
    // dependerem diretamente deles, e não apenas através do IStudentRepository.
    // Com base nos usecases que injetamos no StudentBloc, parece que precisamos deles.
    i.add<ITimeLogRepository>(() => TimeLogRepository(i.get<ITimeLogSupabaseDatasource>()));
    i.add<IContractRepository>(() => ContractRepository(i.get<IContractSupabaseDatasource>()));


    // Usecases
    i.add<GetStudentDetailsUsecase>(() => GetStudentDetailsUsecase(i.get<IStudentRepository>()));
    i.add<UpdateStudentProfileUsecase>(() => UpdateStudentProfileUsecase(i.get<IStudentRepository>()));
    i.add<CheckInUsecase>(() => CheckInUsecase(i.get<IStudentRepository>()));
    i.add<CheckOutUsecase>(() => CheckOutUsecase(i.get<IStudentRepository>()));

    // Usecases de TimeLog (usando IStudentRepository ou ITimeLogRepository)
    // Se GetStudentTimeLogsUsecase usa IStudentRepository:
    i.add<GetStudentTimeLogsUsecase>(() => GetStudentTimeLogsUsecase(i.get<IStudentRepository>()));
    // Se CreateTimeLogUsecase usa IStudentRepository:
    i.add<CreateTimeLogUsecase>(() => CreateTimeLogUsecase(i.get<IStudentRepository>()));
    // Se UpdateTimeLogUsecase usa IStudentRepository:
    i.add<UpdateTimeLogUsecase>(() => UpdateTimeLogUsecase(i.get<IStudentRepository>()));
     // Se DeleteTimeLogUsecase usa IStudentRepository:
    i.add<DeleteTimeLogUsecase>(() => DeleteTimeLogUsecase(i.get<IStudentRepository>()));
    // i.add<GetActiveTimeLogForStudentUsecase>(() => GetActiveTimeLogForStudentUsecase(i.get<ITimeLogRepository>()));


    // Usecases de Contrato
    i.add<GetContractsForStudentUsecase>(() => GetContractsForStudentUsecase(i.get<IContractRepository>()));


    // BLoC
    i.add<StudentBloc>(() => StudentBloc(
          getStudentDetailsUsecase: i.get<GetStudentDetailsUsecase>(),
          updateStudentProfileUsecase: i.get<UpdateStudentProfileUsecase>(),
          checkInUsecase: i.get<CheckInUsecase>(),
          checkOutUsecase: i.get<CheckOutUsecase>(),
          getStudentTimeLogsUsecase: i.get<GetStudentTimeLogsUsecase>(),
          createTimeLogUsecase: i.get<CreateTimeLogUsecase>(),
          updateTimeLogUsecase: i.get<UpdateTimeLogUsecase>(),
          deleteTimeLogUsecase: i.get<DeleteTimeLogUsecase>(),
          // getActiveTimeLogForStudentUsecase: i.get<GetActiveTimeLogForStudentUsecase>(),
          getContractsForStudentUsecase: i.get<GetContractsForStudentUsecase>(),
        ));
  }

  @override
  void routes(RouteManager r) {
    // A rota base para este módulo é '/student' (definido no AppModule)

    // Rota para o dashboard/home do estudante (ex: /student/home ou /student/)
    // Se '/student/' for a rota principal, pode ser ChildRoute('/', ...)
    r.child(
      // Modular.initialRoute é '/', então '/student/' já é a rota base.
      // Se quiser /student/dashboard, use '/dashboard'
      Modular.initialRoute, // Equivalente a '/' dentro deste módulo, resultando em '/student/'
      child: (_) => const StudentHomePage(), // Renomeado de StudentDashboardPage para StudentHomePage
      transition: TransitionType.fadeIn,
    );

    // Rota para a página de registo de horas (Time Log)
    r.child(
      '/time-log',
      child: (_) => const StudentTimeLogPage(),
      transition: TransitionType.fadeIn,
    );

    // Rota para a página de perfil do estudante
    r.child(
      '/profile',
      child: (_) => const StudentProfilePage(),
      transition: TransitionType.fadeIn,
    );

    // Se a check_in_out_page for separada:
    // r.child(
    //   '/check-in-out',
    //   child: (_) => const CheckInOutPage(),
    // );
  }
}
