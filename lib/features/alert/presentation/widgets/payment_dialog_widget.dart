// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bankapp3/features/alert/presentation/bloc/alert_bloc.dart';

class PaymentDialogWidget extends StatelessWidget {
  final String userId;
  final double amount;
  final String cardNumber;

  const PaymentDialogWidget({
    Key? key,
    required this.userId,
    required this.amount,
    required this.cardNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('طلب دفع'),
      content: Text('هل توافق على دفع $amount؟'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AlertBloc>().add(
              PaymentRejected(userId, amount, cardNumber),
            );
          },
          child: const Text('رفض'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AlertBloc>().add(
              PaymentApproved(userId, amount, cardNumber),
            );
          },
          child: const Text('موافقة'),
        ),
      ],
    );
  }
}
