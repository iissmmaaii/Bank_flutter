import 'package:bankapp3/features/alert/domain/entities/notificationentity.dart';
import 'package:bankapp3/features/alert/domain/usecases/getnotificationusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/savenotificationusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/updatenotificationusecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getUseCase;
  final SaveNotificationUseCase saveUseCase;
  final UpdateNotificationStatusUseCase updateUseCase;

  NotificationBloc(this.getUseCase, this.saveUseCase, this.updateUseCase)
    : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      print('Loading notifications...');
      emit(NotificationLoading());
      try {
        final data = await getUseCase.execute();
        print('Loaded notifications count: ${data.length}');
        emit(NotificationLoaded(data));
      } catch (e) {
        print('Error loading notifications: $e');
      }
    });

    on<AddNotification>((event, emit) async {
      print('Adding notification: ${event.notification.title}');
      try {
        await saveUseCase.execute(event.notification);
        add(LoadNotifications());
      } catch (e) {
        print('Error adding notification: $e');
      }
    });

    on<MarkNotification>((event, emit) async {
      print(
        'Marking notification id: ${event.id} as accepted: ${event.accepted}',
      );
      try {
        await updateUseCase(event.id, event.accepted);
        add(LoadNotifications());
      } catch (e) {
        print('Error updating notification status: $e');
      }
    });
  }
}
