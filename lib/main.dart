import 'package:bankapp3/features/account/presentation/pages/account-page.dart';
import 'package:bankapp3/features/alert/presentation/bloc/bloc/notification_bloc.dart';
import 'package:bankapp3/features/alert/presentation/bloc/alert_bloc.dart';
import 'package:bankapp3/features/alert/presentation/pages/notificationpage.dart';
import 'package:bankapp3/features/auth/presentation/pages/login_page.dart';
import 'package:bankapp3/features/auth/presentation/pages/signup_page.dart';
import 'package:bankapp3/features/twofactorauthfeature/presentation/pages/verifypage.dart';
import 'package:bankapp3/injection_container.dart';
import 'package:bankapp3/startuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:bankapp3/features/alert/data/datasource/notification_local_datasource.dart';
import 'package:bankapp3/features/alert/data/models/notification_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();

  FirebaseMessaging.onMessage.listen(_handleNotification);
  FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      _handleNotification(message);
    }
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (_) => sl<NotificationBloc>()..add(LoadNotifications()),
        ),
        BlocProvider<AlertBloc>(create: (_) => sl<AlertBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _handleNotification(RemoteMessage message) async {
  final notification = message.notification;
  final data = message.data;

  if (notification != null) {
    final newNotification = NotificationModel(
      id: const Uuid().v4(),
      title: notification.title ?? '',
      body: notification.body ?? '',
      userId: data['userId'] ?? '',
      amount: double.tryParse(data['amount'] ?? '0') ?? 0,
      cardNumber: data['cardNumber'] ?? '',
      isAccepted: null,
    );

    await sl<NotificationLocalDataSource>().insert(newNotification);

    sl<NotificationBloc>().add(LoadNotifications());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartUpPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const AccountPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/recover': (context) => const Verify2FAPage(),
      },
    );
  }
}
