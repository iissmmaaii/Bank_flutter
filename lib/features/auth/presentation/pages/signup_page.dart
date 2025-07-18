import 'package:bankapp3/features/auth/presentation/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/auth/presentation/bloc/signin/signup_bloc.dart';
//import 'package:bankapp3/features/auth/presentation/widgets/signup_form.dart';
import 'package:bankapp3/injection_container.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (_) => sl<SignupBloc>(),
      child: const Scaffold(body: SafeArea(child: SignupForm())),
    );
  }
}
