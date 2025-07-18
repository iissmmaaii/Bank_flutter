import 'package:bankapp3/features/alert/data/datasource/notification_local_datasource.dart';
import 'package:bankapp3/features/alert/domain/entities/notificationentity.dart';
import 'package:bankapp3/features/alert/data/models/notification_model.dart';
import 'package:bankapp3/features/alert/domain/repositories/notification_repositories.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveNotification(NotificationEntity notification) async {
    final model = NotificationModel.fromEntity(notification);
    await localDataSource.insert(model);
  }

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    final models = await localDataSource.fetchAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateNotificationStatus(String id, bool isAccepted) async {
    await localDataSource.updateStatus(id, isAccepted);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await localDataSource.delete(id);
  }
}
