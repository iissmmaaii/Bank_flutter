import 'package:bankapp3/features/account/presentation/pages/account-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/account/presentation/bloc/accountuser_bloc.dart';

class ChargeAmountForm extends StatefulWidget {
  const ChargeAmountForm({Key? key}) : super(key: key);

  @override
  State<ChargeAmountForm> createState() => _ChargeAmountFormState();
}

class _ChargeAmountFormState extends State<ChargeAmountForm> {
  final _formKey = GlobalKey<FormState>();
  final _receiverController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _receiverController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final receiverCard = _receiverController.text.trim();
      final amount = _amountController.text.trim();

      context.read<AccountuserBloc>().add(
        ChargeAmountEvent(receiverCardNumber: receiverCard, amount: amount),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountuserBloc, AccountuserState>(
      listener: (context, state) {
        if (state is ChargeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          // ✅ الانتقال إلى صفحة AccountPage بعد النجاح
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AccountPage()),
          );
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is AccountLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _receiverController,
                decoration: const InputDecoration(
                  labelText: 'رقم بطاقة المستلم',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم بطاقة المستلم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال المبلغ';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'يرجى إدخال مبلغ صالح أكبر من صفر';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('شحن', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }
}
