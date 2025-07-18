part of 'alert_bloc.dart';

sealed class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object> get props => [];
}

final class AlertInitial extends AlertState {}

class PaymentProcessing extends AlertState {}

class PaymentSuccess extends AlertState {}

class PaymentFailure extends AlertState {
  final String message;
  const PaymentFailure(this.message);
}
