import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Notification Model
class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationLoadAllRequested extends NotificationEvent {}

class NotificationMarkAsReadRequested extends NotificationEvent {
  final String notificationId;

  const NotificationMarkAsReadRequested({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class NotificationMarkAllAsReadRequested extends NotificationEvent {}

class NotificationDeleteRequested extends NotificationEvent {
  final String notificationId;

  const NotificationDeleteRequested({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class NotificationClearAllRequested extends NotificationEvent {}

class NotificationCreateRequested extends NotificationEvent {
  final NotificationEntity notification;

  const NotificationCreateRequested({required this.notification});

  @override
  List<Object> get props => [notification];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

// Loading States
class NotificationLoading extends NotificationState {}

class NotificationSelecting extends NotificationState {}

class NotificationInserting extends NotificationState {}

class NotificationUpdating extends NotificationState {}

class NotificationDeleting extends NotificationState {}

// Success States
class NotificationLoadAllSuccess extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationLoadAllSuccess({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationMarkAsReadSuccess extends NotificationState {
  final String notificationId;

  const NotificationMarkAsReadSuccess({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class NotificationMarkAllAsReadSuccess extends NotificationState {}

class NotificationDeleteSuccess extends NotificationState {
  final String deletedId;

  const NotificationDeleteSuccess({required this.deletedId});

  @override
  List<Object> get props => [deletedId];
}

class NotificationClearAllSuccess extends NotificationState {}

class NotificationCreateSuccess extends NotificationState {
  final NotificationEntity notification;

  const NotificationCreateSuccess({required this.notification});

  @override
  List<Object> get props => [notification];
}

// Error States
class NotificationSelectError extends NotificationState {
  final String message;

  const NotificationSelectError({required this.message});

  @override
  List<Object> get props => [message];
}

class NotificationInsertError extends NotificationState {
  final String message;

  const NotificationInsertError({required this.message});

  @override
  List<Object> get props => [message];
}

class NotificationUpdateError extends NotificationState {
  final String message;

  const NotificationUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class NotificationDeleteError extends NotificationState {
  final String message;

  const NotificationDeleteError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationLoadAllRequested>(_onNotificationLoadAllRequested);
    on<NotificationMarkAsReadRequested>(_onNotificationMarkAsReadRequested);
    on<NotificationMarkAllAsReadRequested>(
        _onNotificationMarkAllAsReadRequested);
    on<NotificationDeleteRequested>(_onNotificationDeleteRequested);
    on<NotificationClearAllRequested>(_onNotificationClearAllRequested);
    on<NotificationCreateRequested>(_onNotificationCreateRequested);
  }

  Future<void> _onNotificationLoadAllRequested(
    NotificationLoadAllRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationSelecting());
    try {
      // TODO: Implement notification loading logic
      // final notifications = await _notificationRepository.getAllNotifications();
      // final unreadCount = notifications.where((n) => !n.isRead).length;
      // emit(NotificationLoadAllSuccess(notifications: notifications, unreadCount: unreadCount));

      // Mock data for now
      final mockNotifications = [
        NotificationEntity(
          id: '1',
          title: 'Novo estudante cadastrado',
          message: 'João Silva foi cadastrado no sistema',
          type: 'info',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        NotificationEntity(
          id: '2',
          title: 'Registro de horas',
          message: 'Maria Oliveira registrou saída',
          type: 'time_log',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

      final unreadCount = mockNotifications.where((n) => !n.isRead).length;
      emit(NotificationLoadAllSuccess(
        notifications: mockNotifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationSelectError(message: e.toString()));
    }
  }

  Future<void> _onNotificationMarkAsReadRequested(
    NotificationMarkAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationUpdating());
    try {
      // TODO: Implement mark as read logic
      // await _notificationRepository.markAsRead(event.notificationId);
      emit(NotificationMarkAsReadSuccess(notificationId: event.notificationId));
    } catch (e) {
      emit(NotificationUpdateError(message: e.toString()));
    }
  }

  Future<void> _onNotificationMarkAllAsReadRequested(
    NotificationMarkAllAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationUpdating());
    try {
      // TODO: Implement mark all as read logic
      // await _notificationRepository.markAllAsRead();
      emit(NotificationMarkAllAsReadSuccess());
    } catch (e) {
      emit(NotificationUpdateError(message: e.toString()));
    }
  }

  Future<void> _onNotificationDeleteRequested(
    NotificationDeleteRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationDeleting());
    try {
      // TODO: Implement notification deletion logic
      // await _notificationRepository.deleteNotification(event.notificationId);
      emit(NotificationDeleteSuccess(deletedId: event.notificationId));
    } catch (e) {
      emit(NotificationDeleteError(message: e.toString()));
    }
  }

  Future<void> _onNotificationClearAllRequested(
    NotificationClearAllRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationDeleting());
    try {
      // TODO: Implement clear all notifications logic
      // await _notificationRepository.clearAllNotifications();
      emit(NotificationClearAllSuccess());
    } catch (e) {
      emit(NotificationDeleteError(message: e.toString()));
    }
  }

  Future<void> _onNotificationCreateRequested(
    NotificationCreateRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationInserting());
    try {
      // TODO: Implement notification creation logic
      // final notification = await _notificationRepository.createNotification(event.notification);
      // emit(NotificationCreateSuccess(notification: notification));
      emit(NotificationCreateSuccess(notification: event.notification));
    } catch (e) {
      emit(NotificationInsertError(message: e.toString()));
    }
  }
}
