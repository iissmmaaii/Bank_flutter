// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bankapp3/features/alert/domain/usecases/approvepaymentusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/rejectpaymentusecase.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  Approvepaymentusecase approvepaymentusecase;
  RejectPayment rejectPayment;
  AlertBloc(this.approvepaymentusecase, this.rejectPayment)
    : super(AlertInitial()) {
    on<PaymentApproved>(_paymentapproved);
    on<PaymentRejected>(_paymentrejected);
  }
  Future<void> _paymentapproved(
    PaymentApproved event, // 👈 النوع الصحيح هون
    Emitter<AlertState> emit,
  ) async {
    emit(PaymentProcessing());
    try {
      await approvepaymentusecase.execute(
        event.userId,
        event.amount,
        event.cardNumber,
      );
    } catch (err) {
      emit(PaymentFailure(err.toString()));
    }
  }

  Future<void> _paymentrejected(
    PaymentRejected event,
    Emitter<AlertState> emit,
  ) async {
    emit(PaymentProcessing());
    try {
      await rejectPayment.execute(event.userId, event.amount, event.cardNumber);
    } catch (err) {
      emit(PaymentFailure(err.toString()));
    }
  }
}
