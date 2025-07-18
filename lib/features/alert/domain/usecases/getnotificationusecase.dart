import 'package:bankapp3/features/alert/domain/entities/notificationentity.dart';
import 'package:bankapp3/features/alert/domain/repositories/notification_repositories.dart';

class GetNotificationsUseCase {
  final NotificationRepository repo;
  GetNotificationsUseCase(this.repo);
  Future<List<NotificationEntity>> execute() => repo.getAllNotifications();
}
