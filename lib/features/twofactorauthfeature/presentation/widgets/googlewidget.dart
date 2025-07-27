import 'package:flutter/material.dart';

class SecretDisplayWidget extends StatelessWidget {
  final String secret;
  const SecretDisplayWidget({super.key, required this.secret});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("انسخ المفتاح وأضفه إلى تطبيق Google Authenticator:"),
          const SizedBox(height: 20),
          SelectableText(
            secret,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/verify2fa');
            },
            child: const Text("تم، تابع"),
          ),
        ],
      ),
    );
  }
}
