import 'package:flutter/material.dart';
import 'package:bankapp3/features/account/presentation/widgets/charge_amount_form.dart';

class ChargeAmountPage extends StatelessWidget {
  const ChargeAmountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحويل مبلغ'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ChargeAmountForm(),
      ),
    );
  }
}
