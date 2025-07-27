import 'package:bankapp3/features/twofactorauthfeature/presentation/widgets/googlewidget.dart';
import 'package:bankapp3/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/twofactorauthfeature_bloc.dart';

class Setup2FAPage extends StatelessWidget {
  const Setup2FAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<TwofactorauthfeatureBloc>()..add(GetSecretEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text("إعداد المصادقة الثنائية")),
        body: BlocBuilder<TwofactorauthfeatureBloc, TwofactorauthfeatureState>(
          builder: (context, state) {
            if (state is TwofactorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TwofactorSecretLoaded) {
              return SecretDisplayWidget(secret: state.secret.secret);
            } else if (state is TwofactorError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("جارٍ تحميل البيانات..."));
            }
          },
        ),
      ),
    );
  }
}
