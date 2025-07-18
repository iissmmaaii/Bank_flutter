import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/alert/presentation/bloc/bloc/notification_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text('لا توجد إشعارات حالياً'));
            }
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return ListTile(
                  title: Text(notif.title),
                  subtitle: Text(notif.body),
                  trailing:
                      notif.isAccepted == null
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed:
                                    () => context.read<NotificationBloc>().add(
                                      MarkNotification(notif.id, true),
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed:
                                    () => context.read<NotificationBloc>().add(
                                      MarkNotification(notif.id, false),
                                    ),
                              ),
                            ],
                          )
                          : Icon(
                            notif.isAccepted!
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                notif.isAccepted! ? Colors.green : Colors.red,
                          ),
                );
              },
            );
          }
          return const Center(child: Text('لا توجد بيانات'));
        },
      ),
    );
  }
}
