part of 'twofactorauthfeature_bloc.dart';

sealed class TwofactorauthfeatureEvent extends Equatable {
  const TwofactorauthfeatureEvent();

  @override
  List<Object> get props => [];
}

class GetSecretEvent extends TwofactorauthfeatureEvent {}

class VerifyOtpEvent extends TwofactorauthfeatureEvent {
  final String otp;
  final String email;
  final String phoneNumber;

  const VerifyOtpEvent({
    required this.otp,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [otp, email, phoneNumber];
}
