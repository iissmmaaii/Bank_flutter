import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/twofactorauthfeature_bloc.dart';

class OtpVerificationFormWidget extends StatefulWidget {
  final bool isLoading;
  const OtpVerificationFormWidget({super.key, required this.isLoading});

  @override
  State<OtpVerificationFormWidget> createState() =>
      _OtpVerificationFormWidgetState();
}

class _OtpVerificationFormWidgetState extends State<OtpVerificationFormWidget> {
  final _otpController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: "رقم الهاتف"),
        ),
        TextField(
          controller: _otpController,
          decoration: const InputDecoration(labelText: "رمز OTP"),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed:
              widget.isLoading
                  ? null
                  : () {
                    BlocProvider.of<TwofactorauthfeatureBloc>(context).add(
                      VerifyOtpEvent(
                        otp: _otpController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                      ),
                    );
                  },
          child: const Text("تحقق"),
        ),
        if (widget.isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
