import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/alert/presentation/bloc/bloc/notification_bloc.dart';
import 'package:bankapp3/features/alert/presentation/bloc/alert_bloc.dart';
import 'package:bankapp3/injection_container.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // إعادة تحميل الإشعارات عند فتح الصفحة
    Future.microtask(() {
      context.read<NotificationBloc>().add(LoadNotifications());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: MultiBlocProvider(
        providers: [
          // فقط نوفر AlertBloc لأن NotificationBloc موجود مسبقاً في الـ context
          BlocProvider(create: (_) => sl<AlertBloc>()),
        ],
        child: BlocBuilder<NotificationBloc, NotificationState>(
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
                                  onPressed: () {
                                    // الموافقة
                                    context.read<NotificationBloc>().add(
                                      MarkNotification(notif.id, true),
                                    );
                                    context.read<AlertBloc>().add(
                                      PaymentApproved(
                                        notif.userId,
                                        notif.amount,
                                        notif.cardNumber,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    // الرفض
                                    context.read<NotificationBloc>().add(
                                      MarkNotification(notif.id, false),
                                    );
                                    context.read<AlertBloc>().add(
                                      PaymentRejected(
                                        notif.userId,
                                        notif.amount,
                                        notif.cardNumber,
                                      ),
                                    );
                                  },
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
      ),
    );
  }
}
