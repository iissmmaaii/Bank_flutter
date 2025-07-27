import 'package:bankapp3/features/twofactorauthfeature/presentation/widgets/verifywidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/injection_container.dart';
import '../bloc/twofactorauthfeature_bloc.dart';

class Verify2FAPage extends StatelessWidget {
  const Verify2FAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TwofactorauthfeatureBloc>(
      create: (_) => sl<TwofactorauthfeatureBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("تحقق من الرمز")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              BlocListener<TwofactorauthfeatureBloc, TwofactorauthfeatureState>(
                listener: (context, state) {
                  if (state is TwofactorVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم التحقق بنجاح!")),
                    );
                    // إذا تريد تحويل المستخدم بعد التحقق
                    Navigator.pushReplacementNamed(context, '/login');
                  } else if (state is TwofactorError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: BlocBuilder<
                  TwofactorauthfeatureBloc,
                  TwofactorauthfeatureState
                >(
                  builder: (context, state) {
                    if (state is TwofactorSecretLoaded) {
                      return Column(
                        children: [
                          Text("المفتاح السري: ${state.secret.secret}"),
                          const SizedBox(height: 20),
                          OtpVerificationFormWidget(
                            isLoading: state is TwofactorLoading,
                          ),
                        ],
                      );
                    }
                    return OtpVerificationFormWidget(
                      isLoading: state is TwofactorLoading,
                    );
                  },
                ),
              ),
        ),
      ),
    );
  }
}
