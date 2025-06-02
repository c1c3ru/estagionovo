// lib/features/student/presentation/widgets/online_colleagues_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_indicator.dart';
// Para obter o ID do utilizador atual e não se mostrar a si mesmo na lista
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart' as auth_state;
// Importe o StudentModel ou UserEntity se quiser mostrar mais detalhes dos colegas
// import '../../../../domain/entities/student_entity.dart';

// Modelo simples para representar um colega online
class OnlineColleague {
  final String id;
  final String fullName; // Assumindo que podemos obter o nome
  final String? profilePictureUrl;

  OnlineColleague({
    required this.id,
    required this.fullName,
    this.profilePictureUrl,
  });

  // Factory para criar a partir de um payload do Supabase (exemplo)
  // A estrutura do payload dependerá de como você consulta/subscreve
  factory OnlineColleague.fromSupabasePayload(Map<String, dynamic> payload) {
    // Este é um exemplo. Você precisará ajustar com base nos seus dados.
    // Se você estiver a subscrever à tabela 'time_logs' e precisar do nome da tabela 'students':
    final studentData = payload['new']?['students'] ?? payload['old']?['students'] ?? {}; // Se fizer join
    return OnlineColleague(
      id: payload['new']?['student_id'] ?? payload['old']?['student_id'] ?? 'unknown_id',
      fullName: studentData['full_name'] ?? 'Colega Online',
      profilePictureUrl: studentData['profile_picture_url'] as String?,
    );
  }
   // Factory para criar a partir de uma consulta inicial
  factory OnlineColleague.fromInitialQuery(Map<String, dynamic> studentData) {
    return OnlineColleague(
      id: studentData['id'] as String, // ID do estudante
      fullName: studentData['full_name'] as String? ?? 'Colega Online',
      profilePictureUrl: studentData['profile_picture_url'] as String?,
    );
  }
}

class OnlineColleaguesWidget extends StatefulWidget {
  const OnlineColleaguesWidget({Key? key}) : super(key: key);

  @override
  State<OnlineColleaguesWidget> createState() => _OnlineColleaguesWidgetState();
}

class _OnlineColleaguesWidgetState extends State<OnlineColleaguesWidget> {
  final SupabaseClient _supabaseClient = Modular.get<SupabaseClient>();
  final AuthBloc _authBloc = Modular.get<AuthBloc>();
  String? _currentUserId;

  StreamSubscription<List<RealtimeLog>>? _timeLogsSubscription;
  final List<OnlineColleague> _onlineColleagues = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Canal para subscrição
  RealtimeChannel? _onlineStatusChannel;


  @override
  void initState() {
    super.initState();
    final currentAuthState = _authBloc.state;
    if (currentAuthState is auth_state.AuthSuccess) {
      _currentUserId = currentAuthState.user.id;
    }
    _initializeAndFetchOnlineColleagues();
  }

  Future<void> _initializeAndFetchOnlineColleagues() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Buscar colegas inicialmente online
      // Esta query busca estudantes que têm um time_log hoje sem check_out_time.
      // É uma query complexa e pode ser otimizada com uma view ou função no Supabase.
      final today = DateTime.now();
      final todayDateString = DateFormat('yyyy-MM-dd').format(today);

      final response = await _supabaseClient
          .from('students')
          .select('id, full_name, profile_picture_url, time_logs!inner(student_id, log_date, check_out_time)')
          .eq('time_logs.log_date', todayDateString)
          .is_('time_logs.check_out_time', null) // Onde check_out_time é NULO
          .neq('id', _currentUserId ?? 'dummy_id_to_avoid_error_if_null'); // Não mostrar o próprio utilizador

      if (!mounted) return;

      final List<OnlineColleague> initialOnline = [];
      for (var studentData in response as List<dynamic>) {
          initialOnline.add(OnlineColleague.fromInitialQuery(studentData as Map<String, dynamic>));
      }
      setState(() {
        _onlineColleagues.clear();
        _onlineColleagues.addAll(initialOnline);
        _isLoading = false;
      });


      // 2. Subscrever a mudanças na tabela time_logs
      // O ideal seria ter uma tabela de "presença" ou usar funções do Supabase para gerir isso.
      // Subscrever a 'time_logs' diretamente pode ser barulhento.
      // Este é um exemplo simplificado.
      _onlineStatusChannel = _supabaseClient.channel('public:time_logs');
      _onlineStatusChannel!.on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: '*', schema: 'public', table: 'time_logs'),
        (payload, [ref]) {
          if (!mounted) return;
          // logger.d('Realtime TimeLog Payload: $payload');
          // Esta lógica de atualização precisaria ser mais robusta:
          // - Se um novo log de check-in sem check-out aparecer para hoje -> adicionar colega.
          // - Se um log existente for atualizado com um check-out -> remover colega.
          // - Se um log for apagado e era um check-in ativo -> remover colega.
          // Para simplificar, vamos recarregar a lista. Na prática, você manipularia o payload.
          _fetchCurrentOnlineStatus();
        },
      ).subscribe((status, [error]) {
         if (!mounted) return;
        if (error != null) {
          // logger.e('Erro na subscrição Realtime TimeLogs: $error');
          setState(() {
            _errorMessage = 'Erro na ligação em tempo real.';
          });
        }
      });

    } catch (e) {
      if (!mounted) return;
      // logger.e('Erro ao buscar/subscrever colegas online: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Não foi possível carregar colegas online.';
      });
    }
  }

  // Função para buscar o estado atual (usada após eventos realtime)
  Future<void> _fetchCurrentOnlineStatus() async {
    if (!mounted || _currentUserId == null) return;
     try {
      final today = DateTime.now();
      final todayDateString = DateFormat('yyyy-MM-dd').format(today);

      final response = await _supabaseClient
          .from('students')
          .select('id, full_name, profile_picture_url, time_logs!inner(student_id, log_date, check_out_time)')
          .eq('time_logs.log_date', todayDateString)
          .is_('time_logs.check_out_time', null)
          .neq('id', _currentUserId!);

      if (!mounted) return;
      final List<OnlineColleague> updatedOnline = [];
       for (var studentData in response as List<dynamic>) {
          updatedOnline.add(OnlineColleague.fromInitialQuery(studentData as Map<String, dynamic>));
      }
      setState(() {
        _onlineColleagues.clear();
        _onlineColleagues.addAll(updatedOnline);
      });
    } catch (e) {
      // logger.w('Erro ao re-buscar colegas online após evento realtime: $e');
    }
  }


  @override
  void dispose() {
    if (_onlineStatusChannel != null) {
       _supabaseClient.removeChannel(_onlineStatusChannel!);
    }
    _timeLogsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: LoadingIndicator(size: 24),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
      );
    }

    if (_onlineColleagues.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('Nenhum colega online no momento.'),
          ),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Para que o Card não ocupe todo o espaço
          children: [
            Text(
              'Colegas Online (${_onlineColleagues.length})',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Usar ListView.builder se a lista puder ser grande
            // Por agora, um Wrap para poucos itens
            if (_onlineColleagues.isNotEmpty)
             SizedBox(
                height: 60, // Altura fixa para a lista horizontal
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _onlineColleagues.length,
                  itemBuilder: (context, index) {
                    final colleague = _onlineColleagues[index];
                    return Tooltip(
                      message: colleague.fullName,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.secondaryContainer,
                              backgroundImage: colleague.profilePictureUrl != null && colleague.profilePictureUrl!.isNotEmpty
                                  ? NetworkImage(colleague.profilePictureUrl!)
                                  : null,
                              child: colleague.profilePictureUrl == null || colleague.profilePictureUrl!.isEmpty
                                  ? Text(
                                      colleague.fullName.isNotEmpty ? colleague.fullName[0].toUpperCase() : '?',
                                      style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              colleague.fullName.split(" ").first, // Primeiro nome
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                   separatorBuilder: (context, index) => const SizedBox(width: 0), // Sem separador visível
                ),
              )
            else
              const Text('Ninguém online no momento.'),

          ],
        ),
      ),
    );
  }
}
