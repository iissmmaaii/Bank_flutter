import 'package:bankapp3/features/alert/domain/repositories/notification_repositories.dart';

class UpdateNotificationStatusUseCase {
  final NotificationRepository repo;
  UpdateNotificationStatusUseCase(this.repo);
  Future<void> call(String id, bool accepted) =>
      repo.updateNotificationStatus(id, accepted);
}
