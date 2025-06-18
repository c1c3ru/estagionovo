// lib/features/student/presentation/widgets/online_colleagues_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:student_supervisor_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_supervisor_app/features/auth/bloc/auth_state.dart'
    as auth_state;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_indicator.dart';

import '../../../../domain/entities/student_entity.dart';

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
    final studentData = payload['new']?['students'] ??
        payload['old']?['students'] ??
        {}; // Se fizer join
    return OnlineColleague(
      id: payload['new']?['student_id'] ??
          payload['old']?['student_id'] ??
          'unknown_id',
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
  const OnlineColleaguesWidget({super.key});

  @override
  State<OnlineColleaguesWidget> createState() => _OnlineColleaguesWidgetState();
}

class _OnlineColleaguesWidgetState extends State<OnlineColleaguesWidget> {
  final SupabaseClient _supabaseClient = Modular.get<SupabaseClient>();
  final AuthBloc _authBloc = Modular.get<AuthBloc>();
  String? _currentUserId;

  StreamSubscription<dynamic>? _timeLogsSubscription;
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
      final today = DateTime.now();
      final todayDateString = DateFormat('yyyy-MM-dd').format(today);

      final response = await _supabaseClient
          .from('students')
          .select(
              'id, full_name, profile_picture_url, time_logs!inner(student_id, log_date, check_out_time)')
          .eq('time_logs.log_date', todayDateString)
          .isFilter('time_logs.check_out_time', null)
          .neq('id', _currentUserId ?? 'dummy_id_to_avoid_error_if_null');

      if (!mounted) return;

      final List<OnlineColleague> initialOnline = [];
      for (var studentData in response as List<dynamic>) {
        initialOnline.add(OnlineColleague.fromInitialQuery(
            studentData as Map<String, dynamic>));
      }
      setState(() {
        _onlineColleagues.clear();
        _onlineColleagues.addAll(initialOnline);
        _isLoading = false;
      });

      // Subscrever a mudanças na tabela time_logs
      _onlineStatusChannel = _supabaseClient.channel('public:time_logs');
      _onlineStatusChannel!.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'time_logs',
        callback: (payload) {
          if (!mounted) return;
          _fetchCurrentOnlineStatus();
        },
      );
      _onlineStatusChannel!.subscribe();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Não foi possível carregar colegas online.';
      });
    }
  }

  Future<void> _fetchCurrentOnlineStatus() async {
    if (!mounted || _currentUserId == null) return;
    try {
      final today = DateTime.now();
      final todayDateString = DateFormat('yyyy-MM-dd').format(today);

      final response = await _supabaseClient
          .from('students')
          .select(
              'id, full_name, profile_picture_url, time_logs!inner(student_id, log_date, check_out_time)')
          .eq('time_logs.log_date', todayDateString)
          .isFilter('time_logs.check_out_time', null)
          .neq('id', _currentUserId!);

      if (!mounted) return;
      final List<OnlineColleague> updatedOnline = [];
      for (var studentData in response as List<dynamic>) {
        updatedOnline.add(OnlineColleague.fromInitialQuery(
            studentData as Map<String, dynamic>));
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
        child: Text(_errorMessage!,
            style: TextStyle(color: theme.colorScheme.error)),
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
          mainAxisSize:
              MainAxisSize.min, // Para que o Card não ocupe todo o espaço
          children: [
            Text(
              'Colegas Online (${_onlineColleagues.length})',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
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
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              backgroundImage: colleague.profilePictureUrl !=
                                          null &&
                                      colleague.profilePictureUrl!.isNotEmpty
                                  ? NetworkImage(colleague.profilePictureUrl!)
                                  : null,
                              child: colleague.profilePictureUrl == null ||
                                      colleague.profilePictureUrl!.isEmpty
                                  ? Text(
                                      colleague.fullName.isNotEmpty
                                          ? colleague.fullName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                          color: theme.colorScheme
                                              .onSecondaryContainer),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              colleague.fullName
                                  .split(" ")
                                  .first, // Primeiro nome
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 0), // Sem separador visível
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
