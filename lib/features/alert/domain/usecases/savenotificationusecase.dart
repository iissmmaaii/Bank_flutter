import 'package:bankapp3/features/alert/domain/entities/notificationentity.dart';
import 'package:bankapp3/features/alert/domain/repositories/notification_repositories.dart';

class SaveNotificationUseCase {
  final NotificationRepository repo;
  SaveNotificationUseCase(this.repo);
  Future<void> execute(NotificationEntity entity) =>
      repo.saveNotification(entity);
}
