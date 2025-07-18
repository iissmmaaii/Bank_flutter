import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/auth/presentation/bloc/bloc/login_bloc.dart';
import 'package:bankapp3/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => sl<LoginBloc>()..add(AutoLoginRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('تسجيل الدخول'), centerTitle: true),
        body: const LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'يرجى المصادقة باستخدام البيومترية',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                // ✅ نستخدم Builder لضمان صلاحية context
                Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed: () async {
                          try {
                            final token =
                                await FirebaseMessaging.instance.getToken();
                            print('📲 Device Token: $token');

                            context.read<LoginBloc>().add(
                              LoginCompleted(
                                userId: state.userId,
                                challenge: state.challenge,
                                deviceToken: token, // ✅ أرسل التوكن
                              ),
                            );
                          } catch (e) {
                            print('❌ خطأ في جلب التوكن: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('حدث خطأ أثناء المصادقة'),
                              ),
                            );
                          }
                        },
                        child: const Text('المصادقة الآن'),
                      ),
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text('ليس لديك حساب؟ سجل الآن'),
                ),
              ],
            ),
          );
        }

        // العرض العادي قبل طلب المصادقة
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'مرحبًا! اضغط لتسجيل الدخول',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<LoginBloc>().add(AutoLoginRequested());
                },
                child: const Text('تسجيل الدخول'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('ليس لديك حساب؟ سجل الآن'),
              ),
            ],
          ),
        );
      },
    );
  }
}
