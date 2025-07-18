// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'alert_bloc.dart';

sealed class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

class PaymentApproved extends AlertEvent {
  final String userId;
  final double amount;
  final String cardNumber;
  const PaymentApproved(this.userId, this.amount, this.cardNumber);
}

class PaymentRejected extends AlertEvent {
  final String userId;
  final double amount;
  final String cardNumber;
  const PaymentRejected(this.userId, this.amount, this.cardNumber);
}
