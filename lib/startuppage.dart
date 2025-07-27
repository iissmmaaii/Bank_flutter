import 'package:bankapp3/features/auth/presentation/pages/login_page.dart';
import 'package:bankapp3/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  Future<bool> isUserLoggedIn() async {
    try {
      final storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'id');
      return userId != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const LoginPage();
        } else {
          return const SignupPage();
        }
      },
    );
  }
}
