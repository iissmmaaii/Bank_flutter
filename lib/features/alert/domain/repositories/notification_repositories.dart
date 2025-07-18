import 'package:bankapp3/features/alert/domain/entities/notificationentity.dart';

abstract class NotificationRepository {
  Future<void> saveNotification(NotificationEntity notification);
  Future<List<NotificationEntity>> getAllNotifications();
  Future<void> updateNotificationStatus(String id, bool isAccepted);
  Future<void> deleteNotification(String id);
}
