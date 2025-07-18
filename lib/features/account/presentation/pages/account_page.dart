import 'package:bankapp3/features/alert/presentation/pages/notificationpage.dart';
import 'package:bankapp3/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/account/presentation/bloc/accountuser_bloc.dart';
import 'package:bankapp3/features/account/presentation/widgets/user_account_info_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountuserBloc>(
      create: (context) => sl<AccountuserBloc>()..add(GetAccountInfoEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'معلومات الحساب',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
          elevation: 4.0,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                context.read<AccountuserBloc>().add(GetAccountInfoEvent());
              },
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: const UserAccountInfoWidget(),
        ),
      ),
    );
  }
}
