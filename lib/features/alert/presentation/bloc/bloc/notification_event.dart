part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class AddNotification extends NotificationEvent {
  final NotificationEntity notification;
  AddNotification(this.notification);
}

class MarkNotification extends NotificationEvent {
  final String id;
  final bool accepted;
  MarkNotification(this.id, this.accepted);
}
