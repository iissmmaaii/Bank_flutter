import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/auth/presentation/bloc/bloc/login_bloc.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
          );
        } else if (state is LoginError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoginBiometricPrompt) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'يرجى المصادقة باستخدام البيومترية',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<LoginBloc>().add(
                    LoginCompleted(
                      userId: state.userId,
                      challenge: state.challenge,
                      deviceToken: null,
                    ),
                  );
                },
                child: const Text('مصادقة'),
              ),
            ],
          );
        }
        return ElevatedButton(
          onPressed: () {
            context.read<LoginBloc>().add(AutoLoginRequested());
          },
          child: const Text('تسجيل الدخول'),
        );
      },
    );
  }
}
